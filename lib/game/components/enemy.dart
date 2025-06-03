import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../my_game.dart';

enum EnemyType { goomba }

enum EnemyState { walk, die }

class Enemy extends RectangleComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final EnemyType type;
  EnemyState state = EnemyState.walk;
  double speed = 0;
  int hp = 1;

  Enemy({required Vector2 position, required this.type})
      : super(
          position: position,
          size: EnemyConstants.size,
          anchor: Anchor.bottomLeft,
          paint: Paint()..color = Colors.red, // 敵は赤い四角で代用
        );

  @override
  Future<void> onLoad() async {
    speed = EnemyConstants.walkSpeed(type);
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.bottomLeft,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == EnemyState.walk) {
      position.x += speed * dt;
      // 画面端で反転
      if (position.x < 0 || position.x + size.x > gameRef.size.x) {
        speed = -speed;
        // flipHorizontally は RectangleComponent にないので、色で示す場合は省略
      }
    } else if (state == EnemyState.die) {
      removeFromParent();
    }
  }

  /// プレイヤーに踏まれたときに呼び出される
  void onStomped() {
    hp = 0;
    state = EnemyState.die;
    // 後でアニメーションを置き換えたりする場合はここで対応
  }
}
