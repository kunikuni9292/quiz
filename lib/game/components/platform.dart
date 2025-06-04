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
    // 地面らしい緑色の見た目
    _paint = Paint()..color = const Color(0xFF228B22); // 緑色の地面
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
    final rect = toRect();

    // 地面の描画（緑色）
    canvas.drawRect(rect, _paint);

    // 地面の枠線（濃い緑色）
    final borderPaint = Paint()
      ..color = const Color(0xFF006400)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(rect, borderPaint);

    // 草の模様を表現する小さな線
    final grassPaint = Paint()
      ..color = const Color(0xFF32CD32)
      ..strokeWidth = 2;

    // 草のような縦線を描画
    for (double x = rect.left + 10; x < rect.right; x += 20) {
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.top + 8), grassPaint);
    }

    super.render(canvas);
  }
}
