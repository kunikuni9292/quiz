import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../my_game.dart';
import 'player.dart';

enum ItemType { coin, mushroom }

class Item extends RectangleComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final ItemType type;
  bool collected = false;

  Item({required Vector2 position, required this.type})
      : super(
          position: position,
          size: ItemConstants.size(type),
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    // アイテムの見た目を改善
    _updateItemAppearance();
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.bottomLeft,
    ));
  }

  void _updateItemAppearance() {
    if (type == ItemType.coin) {
      paint = Paint()..color = Colors.yellow;
    } else if (type == ItemType.mushroom) {
      paint = Paint()..color = Colors.green;
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = toRect();

    if (type == ItemType.coin) {
      // コインを円形で描画
      final center = Offset(rect.center.dx, rect.center.dy);
      final radius = size.x / 2;

      // 外側の金色の円
      final outerPaint = Paint()..color = Colors.amber;
      canvas.drawCircle(center, radius, outerPaint);

      // 内側の黄色の円
      final innerPaint = Paint()..color = Colors.yellow;
      canvas.drawCircle(center, radius * 0.8, innerPaint);

      // 枠線
      final borderPaint = Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(center, radius, borderPaint);
    } else if (type == ItemType.mushroom) {
      // キノコを描画
      canvas.drawRect(rect, paint!);

      // キノコの帽子部分（上半分を赤に）
      final capRect =
          Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * 0.6);
      final capPaint = Paint()..color = Colors.red;
      canvas.drawRect(capRect, capPaint);

      // キノコの軸部分（下半分を白に）
      final stemRect = Rect.fromLTWH(rect.left + rect.width * 0.3,
          rect.top + rect.height * 0.6, rect.width * 0.4, rect.height * 0.4);
      final stemPaint = Paint()..color = Colors.white;
      canvas.drawRect(stemRect, stemPaint);

      // 白い斑点
      final spotPaint = Paint()..color = Colors.white;
      canvas.drawCircle(
          Offset(rect.left + rect.width * 0.3, rect.top + rect.height * 0.2),
          2,
          spotPaint);
      canvas.drawCircle(
          Offset(rect.left + rect.width * 0.7, rect.top + rect.height * 0.3),
          2,
          spotPaint);
    }

    super.render(canvas);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (!collected && other is Player) {
      collected = true;
      if (type == ItemType.coin) {
        gameRef.addCoin();
      } else if (type == ItemType.mushroom) {
        gameRef.player.becomeBig();
      }
      removeFromParent();
    }
  }
}
