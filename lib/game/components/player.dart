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

class Player extends RectangleComponent
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

  Player({required Vector2 position})
      : super(
          position: position,
          size: PlayerConstants.smallSize,
          anchor: Anchor.bottomLeft,
        ) {
    // 初期状態では空中にいるとみなし、重力で地面に落ちるフローを正常に動作させる
    onGround = false;
    state = PlayerState.idle;
    print('Player onGround 初期値 = $onGround');
  }

  @override
  Future<void> onLoad() async {
    _updatePlayerAppearance();
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.bottomLeft,
    ));
  }

  void _updatePlayerAppearance() {
    // マリオらしい見た目にする（帽子付きの人型風）
    if (isBig) {
      paint = Paint()..color = Colors.red; // 大きいマリオは赤
    } else {
      switch (state) {
        case PlayerState.idle:
          paint = Paint()..color = Colors.blue; // 通常は青
          break;
        case PlayerState.run:
          if (isMovingLeft) {
            paint = Paint()..color = Colors.lightBlue; // 左向きは水色
          } else {
            paint = Paint()..color = Colors.indigo; // 右向きは濃紺
          }
          break;
        case PlayerState.jump:
          paint = Paint()..color = Colors.cyan; // ジャンプ中は水色
          break;
        case PlayerState.fall:
          paint = Paint()..color = Colors.teal; // 落下中は青緑
          break;
        case PlayerState.stomp:
          paint = Paint()..color = Colors.yellow; // 踏みつけ中は黄色
          break;
      }
    }

    // 無敵中は点滅効果
    if (isInvincible && (stompTimer * 10).round() % 2 == 0) {
      paint = Paint()..color = Colors.white;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // デバッグ出力
    if (keysPressed.isNotEmpty) {
      print('Keys pressed: ${keysPressed.map((k) => k.keyLabel).join(', ')}');
    }

    // 左右キーの状態を更新
    isMovingLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    isMovingRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // ジャンプキーの状態を更新
    jumpPressed = keysPressed.contains(LogicalKeyboardKey.space);

    // ジャンプの初回判定
    if (jumpPressed && onGround) {
      jump();
      print('Jump triggered!');
    }

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // デバッグ用：詳細な状態をフレームごとに表示
    print(
        'before: y=${position.y.toStringAsFixed(1)}, vy=${velocity.y.toStringAsFixed(1)}, onGround=$onGround, state=$state');

    // 地面にいる場合はY方向の速度をリセット（微小な重力による落下を防ぐ）
    if (onGround && state != PlayerState.stomp) {
      velocity.y = 0;
    }

    // マリオらしい左右移動の処理
    _updateHorizontalMovement(dt);

    // 地面にいないときだけジャンプ/重力処理を行う
    if (!onGround) {
      print('applying gravity: before vy=${velocity.y.toStringAsFixed(1)}');
      _updateJumpAndGravity(dt);
      print('applying gravity: after vy=${velocity.y.toStringAsFixed(1)}');
    }

    // 踏みつけ後の無敵タイマー処理
    _updateInvincibilityTimer(dt);

    // 位置更新
    position += velocity * dt;

    print(
        'after:  y=${position.y.toStringAsFixed(1)}, vy=${velocity.y.toStringAsFixed(1)}, onGround=$onGround, playerBottom=${(position.y + size.y).toStringAsFixed(1)}');

    // 演出用：ジャンプ中か落下中かを state で分ける
    if (!onGround) {
      if (velocity.y < 0 && state != PlayerState.jump) {
        state = PlayerState.jump;
      } else if (velocity.y > 0 && state != PlayerState.fall) {
        state = PlayerState.fall;
      }
    }

    // 画面下に落ちたらリスポーン処理
    if (position.y > gameRef.size.y + 100) {
      gameRef.reduceLife();
      respawn();
    }

    // 見た目を更新
    _updatePlayerAppearance();
  }

  void _updateHorizontalMovement(double dt) {
    if (isMovingLeft) {
      // 左への加速
      velocity.x -= PlayerConstants.moveAcceleration * dt;
      if (onGround && state != PlayerState.run) state = PlayerState.run;
    } else if (isMovingRight) {
      // 右への加速
      velocity.x += PlayerConstants.moveAcceleration * dt;
      if (onGround && state != PlayerState.run) state = PlayerState.run;
    } else {
      // ブレーキ（摩擦による減速）
      if (velocity.x > 0) {
        velocity.x -= PlayerConstants.friction * dt;
        if (velocity.x < 0) velocity.x = 0;
      } else if (velocity.x < 0) {
        velocity.x += PlayerConstants.friction * dt;
        if (velocity.x > 0) velocity.x = 0;
      }

      // 停止状態での色とステート更新
      if (onGround && velocity.x.abs() < 10) {
        state = PlayerState.idle;
      }
    }

    // 最高速度制限
    velocity.x = velocity.x
        .clamp(-PlayerConstants.maxMoveSpeed, PlayerConstants.maxMoveSpeed);
  }

  void _updateJumpAndGravity(double dt) {
    // 地面にいないときだけ重力を適用する
    if (!onGround) {
      // マリオらしいジャンプ：ボタン押し続けで高く跳べる
      if (state == PlayerState.jump && jumpPressed && velocity.y < 0) {
        // ジャンプボタンを押し続けていると、重力を半分に
        velocity.y += PlayerConstants.gravity * dt * 0.5;
      } else {
        // 通常の重力を適用
        velocity.y += PlayerConstants.gravity * dt;
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

  // MyGameから呼び出されるメソッド
  void moveLeft() {
    velocity.x = -PlayerConstants.maxMoveSpeed;
    if (onGround) state = PlayerState.run;
  }

  void moveRight() {
    velocity.x = PlayerConstants.maxMoveSpeed;
    if (onGround) state = PlayerState.run;
  }

  void stopMoving() {
    velocity.x = 0;
    if (onGround) {
      state = PlayerState.idle;
    }
  }

  void jump() {
    if (onGround) {
      velocity.y = -PlayerConstants.jumpSpeed;
      state = PlayerState.jump;
      onGround = false;
      print('Jump! velocity.y: ${velocity.y}'); // デバッグ用
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 無敵中は敵との当たり判定をスキップ
    if (isInvincible && other is Enemy) return;

    if (other is Platform) {
      print(
          'Collision with platform detected! Player Y: ${position.y.toStringAsFixed(1)}, PlayerBottom: ${(position.y + size.y).toStringAsFixed(1)}, Platform Top: ${other.position.y.toStringAsFixed(1)}, Velocity Y: ${velocity.y.toStringAsFixed(1)}');

      // intersectionPoints が空でなければ、どれだけ高速でも必ず着地扱い
      if (intersectionPoints.isNotEmpty && velocity.y >= 0) {
        final platformTop = other.position.y;
        // 着地処理：プレイヤーをプラットフォームの上にスナップ
        position.y = platformTop - size.y;
        velocity.y = 0;
        onGround = true;
        state = (velocity.x.abs() > 10) ? PlayerState.run : PlayerState.idle;
        print(
            'Landed on platform via collisionPoints! New position.y: ${position.y.toStringAsFixed(1)}, onGround: $onGround');
      } else {
        print(
            'Landing condition not met - intersectionPoints: ${intersectionPoints.length}, velocity.y >= 0: ${velocity.y >= 0}');
      }
    }

    if (other is Enemy) {
      // 踏みつけ or 接触判定
      final playerBottomY = position.y + size.y;
      final enemyTopY = other.position.y;
      if (playerBottomY <= enemyTopY + 5) {
        // 踏みつけ成功
        state = PlayerState.stomp;
        velocity.y = -PlayerConstants.stompBounceSpeed;
        other.onStomped();

        // 踏みつけ後の無敵フレームを付与
        isInvincible = true;
        stompTimer = PlayerConstants.stompInvincibleTime;
      } else {
        takeDamage();
      }
    }

    if (other is Item) {
      if (other.type == ItemType.coin) {
        gameRef.addCoin();
      } else if (other.type == ItemType.mushroom) {
        becomeBig();
      }
      other.removeFromParent();
    }

    if (other is GoalFlag) {
      gameRef.onStageClear();
    }
  }

  void takeDamage() {
    if (isBig) {
      isBig = false;
      size = PlayerConstants.smallSize;
      paint = Paint()..color = Colors.blue; // 小さい状態は青
    } else {
      gameRef.reduceLife();
      respawn();
    }
  }

  void becomeBig() {
    if (!isBig) {
      isBig = true;
      size = PlayerConstants.bigSize;
      paint = Paint()..color = Colors.indigo; // 大きい状態はインディゴ色
      // 後で「スプライトに差し替え」ここで対応
    }
  }

  void respawn() {
    // プレイヤーを少し上に浮かせて配置し、重力で落ちて着地するフローを正常に動作させる
    final respawnY = PlayerConstants.respawnY - 1;
    position = Vector2(100, respawnY);
    velocity = Vector2.zero();
    state = PlayerState.idle;
    onGround = false; // 初期状態では空中にいるとみなす
    isInvincible = false;
    stompTimer = 0;
    isMovingLeft = false;
    isMovingRight = false;
    jumpPressed = false;
  }
}
