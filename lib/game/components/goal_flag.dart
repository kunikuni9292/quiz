import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../my_game.dart';
import 'player.dart';

class GoalFlag extends RectangleComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  GoalFlag({required Vector2 position})
      : super(
          position: position,
          size: Vector2(32, 64),
          anchor: Anchor.bottomLeft,
          paint: Paint()..color = Colors.purple, // 紫色のフラグで代用
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.bottomLeft,
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      gameRef.onStageClear();
    }
  }
}
