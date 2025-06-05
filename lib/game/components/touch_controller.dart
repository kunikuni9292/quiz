import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../my_game.dart';

enum TouchControllerLayout {
  portrait, // 縦持ち（ゲームボーイ風）
  landscape, // 横持ち（左右端配置）
}

class TouchController extends PositionComponent with HasGameReference<MyGame> {
  TouchControllerLayout layout = TouchControllerLayout.portrait;

  // ボタンコンポーネント
  late TouchButton leftButton;
  late TouchButton rightButton;
  late TouchButton jumpButton;

  // ボタンの状態
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isJumpPressed = false;

  // ボタンサイズ
  static const double buttonSize = 60.0;
  static const double buttonSpacing = 20.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _createButtons();
    _updateLayout();
  }

  void _createButtons() {
    // 左移動ボタン
    leftButton = TouchButton(
      size: Vector2.all(buttonSize),
      text: '←',
      onPressed: () => _setLeftPressed(true),
      onReleased: () => _setLeftPressed(false),
    );

    // 右移動ボタン
    rightButton = TouchButton(
      size: Vector2.all(buttonSize),
      text: '→',
      onPressed: () => _setRightPressed(true),
      onReleased: () => _setRightPressed(false),
    );

    // ジャンプボタン
    jumpButton = TouchButton(
      size: Vector2.all(buttonSize),
      text: 'J',
      onPressed: () => _setJumpPressed(true),
      onReleased: () => _setJumpPressed(false),
    );

    add(leftButton);
    add(rightButton);
    add(jumpButton);
  }

  void _setLeftPressed(bool pressed) {
    isLeftPressed = pressed;
    game.player.setLeftPressed(pressed);
  }

  void _setRightPressed(bool pressed) {
    isRightPressed = pressed;
    game.player.setRightPressed(pressed);
  }

  void _setJumpPressed(bool pressed) {
    isJumpPressed = pressed;
    game.player.setJumpPressed(pressed);
  }

  void updateLayout() {
    // 画面の縦横比で判定
    final aspectRatio = game.size.x / game.size.y;

    if (aspectRatio > 1.0) {
      layout = TouchControllerLayout.landscape;
    } else {
      layout = TouchControllerLayout.portrait;
    }

    _updateLayout();
  }

  void _updateLayout() {
    switch (layout) {
      case TouchControllerLayout.portrait:
        _setupPortraitLayout();
        break;
      case TouchControllerLayout.landscape:
        _setupLandscapeLayout();
        break;
    }
  }

  void _setupPortraitLayout() {
    // ゲームボーイ風レイアウト：画面下部に配置
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;
    final bottomMargin = 40.0;
    final controllerY = screenHeight - buttonSize - bottomMargin;

    // 左右移動ボタンを左側に配置
    leftButton.position = Vector2(
      buttonSpacing + buttonSize / 2,
      controllerY,
    );

    rightButton.position = Vector2(
      buttonSpacing * 2 + buttonSize * 1.5,
      controllerY,
    );

    // ジャンプボタンを右側に配置
    jumpButton.position = Vector2(
      screenWidth - buttonSpacing - buttonSize / 2,
      controllerY,
    );
  }

  void _setupLandscapeLayout() {
    // 横持ちレイアウト：左右端に配置
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;
    final sideMargin = 30.0;
    final centerY = screenHeight / 2;

    // 左移動ボタンを左下に配置
    leftButton.position = Vector2(
      sideMargin + buttonSize / 2,
      centerY + buttonSize / 2 + buttonSpacing / 2,
    );

    // 右移動ボタンを左上に配置
    rightButton.position = Vector2(
      sideMargin + buttonSize / 2,
      centerY - buttonSize / 2 - buttonSpacing / 2,
    );

    // ジャンプボタンを右側に配置
    jumpButton.position = Vector2(
      screenWidth - sideMargin - buttonSize / 2,
      centerY,
    );
  }
}

class TouchButton extends RectangleComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  bool _isPressed = false;
  late TextComponent _textComponent;

  TouchButton({
    required Vector2 size,
    required this.text,
    required this.onPressed,
    required this.onReleased,
  }) : super(
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // ボタンの見た目を設定
    paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // 枠線を追加（親と完全に一致させるため、topLeftアンカーを使用）
    add(RectangleComponent(
      position: Vector2.zero(), // 親の中心に配置
      size: size,
      paint: Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
      anchor: Anchor.topLeft,
    ));

    // テキストを追加（親の中心に配置）
    _textComponent = TextComponent(
      text: text,
      position: Vector2.zero(), // 親の中心に配置
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topLeft,
    );
    add(_textComponent);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (!_isPressed) {
      _isPressed = true;
      paint.color = Colors.black.withOpacity(0.6);
      onPressed();
    }
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (_isPressed) {
      _isPressed = false;
      paint.color = Colors.black.withOpacity(0.3);
      onReleased();
    }
    return true;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    if (_isPressed) {
      _isPressed = false;
      paint.color = Colors.black.withOpacity(0.3);
      onReleased();
    }
    return true;
  }
}
