import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../my_game.dart';

class Player extends RectangleComponent
    with KeyboardHandler, HasGameReference<MyGame> {
  static const double moveSpeed = 200.0;
  static const double jumpSpeed = 300.0;
  static const double gravity = 800.0;

  Vector2 velocity = Vector2.zero();

  // 移動状態
  bool isMovingLeft = false;
  bool isMovingRight = false;
  bool isJumping = false;
  bool onGround = true;

  // タッチ操作用の状態
  bool touchLeftPressed = false;
  bool touchRightPressed = false;
  bool touchJumpPressed = false;

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 40),
          paint: Paint()..color = Colors.red,
          anchor: Anchor.center,
        );

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // 左右キーの状態を更新
    bool keyboardLeft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    bool keyboardRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // キーボードとタッチの入力を統合
    isMovingLeft = keyboardLeft || touchLeftPressed;
    isMovingRight = keyboardRight || touchRightPressed;

    // ジャンプキーの状態を更新
    bool keyboardJump = keysPressed.contains(LogicalKeyboardKey.space);
    bool jumpPressed = keyboardJump || touchJumpPressed;

    // ジャンプ処理（地面にいる時のみ）
    if (jumpPressed && onGround && !isJumping) {
      velocity.y = -jumpSpeed;
      onGround = false;
      isJumping = true;
    }

    return true;
  }

  // タッチ操作用のメソッド
  void setLeftPressed(bool pressed) {
    touchLeftPressed = pressed;
    _updateMovementState();
  }

  void setRightPressed(bool pressed) {
    touchRightPressed = pressed;
    _updateMovementState();
  }

  void setJumpPressed(bool pressed) {
    touchJumpPressed = pressed;
    if (pressed && onGround && !isJumping) {
      velocity.y = -jumpSpeed;
      onGround = false;
      isJumping = true;
    }
  }

  void _updateMovementState() {
    // タッチ操作による移動状態を更新
    isMovingLeft = touchLeftPressed;
    isMovingRight = touchRightPressed;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 水平移動
    velocity.x = 0;
    if (isMovingLeft) {
      velocity.x = -moveSpeed;
    } else if (isMovingRight) {
      velocity.x = moveSpeed;
    }

    // 重力の適用
    if (!onGround) {
      velocity.y += gravity * dt;
    }

    // 位置更新
    position += velocity * dt;

    // 地面との当たり判定
    final groundY = game.size.y - 100; // 地面のY座標
    final playerBottom = position.y + size.y / 2;

    if (playerBottom >= groundY) {
      // 地面に着地
      position.y = groundY - size.y / 2;
      velocity.y = 0;
      onGround = true;
      isJumping = false;
    }

    // 画面境界チェック（左右）
    final halfWidth = size.x / 2;
    position.x = position.x.clamp(halfWidth, game.size.x - halfWidth);
  }
}
