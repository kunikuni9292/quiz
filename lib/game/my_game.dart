import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'components/player.dart';
import 'components/touch_controller.dart';

class MyGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late TouchController touchController;

  @override
  Future<void> onLoad() async {
    // シンプルな背景色
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF87CEEB), // 空色
    ));

    // 地面を追加
    add(RectangleComponent(
      position: Vector2(0, size.y - 100),
      size: Vector2(size.x, 100),
      paint: Paint()..color = const Color(0xFF8B4513), // 茶色
    ));

    // プレーヤーを地面の上に接するように配置
    // 地面のY座標は size.y - 100
    // プレーヤーのサイズは40x40で、anchorがcenterなので
    // プレーヤーの下端が地面の上端に接するようにする
    final groundY = size.y - 100;
    final playerY = groundY - 20; // プレーヤーの高さの半分(40/2=20)を引く
    player = Player(position: Vector2(size.x / 2, playerY));
    add(player);

    // タッチコントローラーを追加
    touchController = TouchController();
    add(touchController);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // 画面サイズが変更された時にコントローラーのレイアウトを更新
    if (isMounted) {
      touchController.updateLayout();
    }
  }
}
