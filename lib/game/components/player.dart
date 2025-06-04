import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../my_game.dart';
import 'platform.dart';
import 'enemy.dart';
import 'item.dart';
import 'goal_flag.dart';

enum PlayerState { idle, run, jump, fall, stomp }

class Player extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<MyGame> {
  Vector2 velocity = Vector2.zero();
  PlayerState state = PlayerState.idle;
  bool onGround = false;

  // パワーアップ状態
  bool isBig = false;

  // マリオらしい動きのための状態
  bool isMovingLeft = false;
  bool isMovingRight = false;
  bool jumpPressed = false;

  // 踏みつけ後の無敵状態
  bool isInvincible = false;
  double stompTimer = 0;

  // 物理演算の単純化
  double _lastGroundY = 0;
  bool _wasOnGround = false;

  // 画面サイズの保存（動的サイズ計算用）
  late Vector2 _screenSize;

  Player({required Vector2 position})
      : super(
          position: position,
          anchor: Anchor.bottomLeft,
        ) {
    onGround = true;
    state = PlayerState.idle;
  }

  @override
  Future<void> onLoad() async {
    // 画面サイズを取得して保存
    _screenSize = gameRef.size;

    // 画面サイズに応じたプレイヤーサイズを設定
    size = PlayerConstants.getSmallSize(_screenSize);

    // プレイヤー画像を読み込み
    try {
      sprite = await Sprite.load('illust701.png');
    } catch (e) {
      // 画像読み込み失敗時は色で代用
      _updatePlayerColor();
    }

    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.bottomLeft,
    ));
  }

  void _updatePlayerColor() {
    // スプライトが使えない場合の色設定
    final paint = Paint();
    if (isBig) {
      paint.color = Colors.red;
    } else {
      switch (state) {
        case PlayerState.idle:
          paint.color = Colors.blue;
          break;
        case PlayerState.run:
          paint.color = isMovingLeft ? Colors.lightBlue : Colors.indigo;
          break;
        case PlayerState.jump:
          paint.color = Colors.cyan;
          break;
        case PlayerState.fall:
          paint.color = Colors.teal;
          break;
        case PlayerState.stomp:
          paint.color = Colors.yellow;
          break;
      }
    }

    // 無敵中は点滅効果
    if (isInvincible && (stompTimer * 10).round() % 2 == 0) {
      paint.color = Colors.white;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // 左右キーの状態を更新
    isMovingLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    isMovingRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // ジャンプキーの状態を更新
    jumpPressed = keysPressed.contains(LogicalKeyboardKey.space);

    // ジャンプの初回判定
    if (jumpPressed && onGround) {
      _performJump();
    }

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 物理演算の単純化
    _updatePhysics(dt);

    // 踏みつけ後の無敵タイマー処理
    _updateInvincibilityTimer(dt);

    // 位置更新
    position += velocity * dt;

    // 地面チェック（毎フレーム確実に実行）
    _checkGroundCollision();

    // 状態更新
    _updateState();

    // 画面下に落ちたらリスポーン処理
    if (position.y >
        _screenSize.y + GameConstants.getFallThreshold(_screenSize)) {
      gameRef.reduceLife();
      respawn();
    }

    // 見た目を更新（スプライトが無い場合のみ）
    if (sprite == null) {
      _updatePlayerColor();
    }
  }

  void _updatePhysics(double dt) {
    // 水平移動の処理
    _updateHorizontalMovement(dt);

    // 垂直移動（重力とジャンプ）の処理
    _updateVerticalMovement(dt);

    // 地面状態の更新
    _wasOnGround = onGround;

    // 地面から離れているかチェック（簡易的）
    if (onGround && velocity.y < 0) {
      onGround = false; // ジャンプ開始時に地面から離れる
    }
  }

  void _updateHorizontalMovement(double dt) {
    final moveAcceleration = PlayerConstants.getMoveAcceleration(_screenSize);
    final friction = PlayerConstants.getFriction(_screenSize);
    final maxMoveSpeed = PlayerConstants.getMaxMoveSpeed(_screenSize);

    if (isMovingLeft) {
      velocity.x -= moveAcceleration * dt;
    } else if (isMovingRight) {
      velocity.x += moveAcceleration * dt;
    } else {
      // 摩擦による減速
      if (velocity.x > 0) {
        velocity.x = (velocity.x - friction * dt).clamp(0, double.infinity);
      } else if (velocity.x < 0) {
        velocity.x =
            (velocity.x + friction * dt).clamp(double.negativeInfinity, 0);
      }
    }

    // 最高速度制限
    velocity.x = velocity.x.clamp(-maxMoveSpeed, maxMoveSpeed);
  }

  void _updateVerticalMovement(double dt) {
    final gravity = PlayerConstants.getGravity(_screenSize);

    if (!onGround) {
      // 空中にいる場合は重力を適用
      if (state == PlayerState.jump && jumpPressed && velocity.y < 0) {
        // ジャンプボタン押し続けで高さ調整
        velocity.y += gravity * dt * PlayerConstants.jumpGravityMultiplier;
      } else {
        velocity.y += gravity * dt;
      }
    } else {
      // 地面にいる場合はY速度をリセット
      if (velocity.y > 0) {
        velocity.y = 0;
      }
    }
  }

  void _updateState() {
    if (onGround) {
      if (velocity.x.abs() > PlayerConstants.runThreshold) {
        state = PlayerState.run;
      } else {
        state = PlayerState.idle;
      }
    } else {
      if (velocity.y < 0) {
        state = PlayerState.jump;
      } else {
        state = PlayerState.fall;
      }
    }
  }

  void _updateInvincibilityTimer(double dt) {
    if (isInvincible) {
      stompTimer -= dt;
      if (stompTimer <= 0) {
        isInvincible = false;
      }
    }
  }

  void _performJump() {
    final jumpSpeed = PlayerConstants.getJumpSpeed(_screenSize);
    velocity.y = -jumpSpeed;
    state = PlayerState.jump;
    onGround = false;
  }

  void _checkGroundCollision() {
    // 地面のY座標を取得（地面の上端）
    final groundY = GameConstants.getGroundY(_screenSize);
    final playerBottom = position.y + size.y;

    // プレイヤーの下端が地面の上端に接触または下にある場合
    if (playerBottom >= groundY) {
      // プレイヤーを地面の上に正確に配置
      position.y = groundY - size.y;
      velocity.y = 0;
      onGround = true;
    } else {
      // プレイヤーが地面から離れている場合
      onGround = false;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 無敵中は敵との当たり判定をスキップ
    if (isInvincible && other is Enemy) return;

    if (other is Platform) {
      _handlePlatformCollision(other, intersectionPoints);
    } else if (other is Enemy) {
      _handleEnemyCollision(other);
    } else if (other is Item) {
      _handleItemCollision(other);
    } else if (other is GoalFlag) {
      gameRef.onStageClear();
    }
  }

  void _handlePlatformCollision(
      Platform platform, Set<Vector2> intersectionPoints) {
    final playerBottom = position.y + size.y;
    final platformTop = platform.position.y;

    // プレイヤーが地面の範囲内にいて、落下中または地面にいる場合
    if (playerBottom >= platformTop &&
        position.y <= platformTop + platform.size.y &&
        velocity.y >= 0) {
      // プレイヤーを地面の上に正確に配置
      position.y = platformTop - size.y;
      velocity.y = 0;
      onGround = true;
      _lastGroundY = platformTop;
    }
  }

  void _handleEnemyCollision(Enemy enemy) {
    final playerBottomY = position.y + size.y;
    final enemyTopY = enemy.position.y;

    if (playerBottomY <=
        enemyTopY + GameConstants.getStompTolerance(_screenSize)) {
      // 踏みつけ成功
      state = PlayerState.stomp;
      final stompBounceSpeed = PlayerConstants.getStompBounceSpeed(_screenSize);
      velocity.y = -stompBounceSpeed;
      enemy.onStomped();

      // 踏みつけ後の無敵フレームを付与
      isInvincible = true;
      stompTimer = PlayerConstants.stompInvincibleTime;
    } else {
      takeDamage();
    }
  }

  void _handleItemCollision(Item item) {
    if (item.type == ItemType.coin) {
      gameRef.addCoin();
    } else if (item.type == ItemType.mushroom) {
      becomeBig();
    }
    item.removeFromParent();
  }

  void takeDamage() {
    if (isBig) {
      isBig = false;
      size = PlayerConstants.getSmallSize(_screenSize);
    } else {
      gameRef.reduceLife();
      respawn();
    }
  }

  void becomeBig() {
    if (!isBig) {
      isBig = true;
      size = PlayerConstants.getBigSize(_screenSize);
    }
  }

  void respawn() {
    final respawnPosition = GameConstants.getPlayerSpawnPosition(_screenSize);
    position = respawnPosition;
    velocity = Vector2.zero();
    state = PlayerState.idle;
    onGround = true;
    isInvincible = false;
    stompTimer = 0;
    isMovingLeft = false;
    isMovingRight = false;
    jumpPressed = false;
  }
}
