import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  late Paint _paint;

  @override
  Future<void> onLoad() async {
    // マリオらしいブロック風の見た目
    _paint = Paint()..color = const Color(0xFF8B4513); // 茶色のブロック
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
    ));
    print(
        'Platform Hitbox added: position=${position}, size=${size}, anchor=topLeft');
  }

  @override
  void render(Canvas canvas) {
    // ブロック風の描画
    final rect = toRect();

    // メインの茶色ブロック
    canvas.drawRect(rect, _paint);

    // ブロックの枠線（明るい茶色）
    final borderPaint = Paint()
      ..color = const Color(0xFFD2691E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);

    // ブロック内部の模様（格子状）
    final gridPaint = Paint()
      ..color = const Color(0xFFA0522D)
      ..strokeWidth = 1;

    // 縦線
    for (double x = rect.left + size.x / 3; x < rect.right; x += size.x / 3) {
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), gridPaint);
    }

    // 横線
    for (double y = rect.top + size.y / 3; y < rect.bottom; y += size.y / 3) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), gridPaint);
    }

    super.render(canvas);
  }
}
