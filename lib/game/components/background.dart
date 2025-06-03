import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Background extends RectangleComponent {
  final List<Color> layerColors;

  Background({required this.layerColors})
      : super(
          size: Vector2(1600, 600),
        );

  @override
  Future<void> onLoad() async {
    // マリオらしい空の背景
  }

  @override
  void render(Canvas canvas) {
    final rect = toRect();

    // マリオらしい空のグラデーション背景
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF87CEEB), // 明るい空色
        const Color(0xFF87CEFA), // ライトスカイブルー
        const Color(0xFFB0E0E6), // パウダーブルー
        const Color(0xFFE0F6FF), // アリスブルー
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // 雲を描画
    _drawClouds(canvas, rect);

    super.render(canvas);
  }

  void _drawClouds(Canvas canvas, Rect rect) {
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);

    // 雲1
    _drawCloud(canvas, Offset(200, 80), 60, cloudPaint);

    // 雲2
    _drawCloud(canvas, Offset(500, 120), 50, cloudPaint);

    // 雲3
    _drawCloud(canvas, Offset(800, 60), 70, cloudPaint);

    // 雲4
    _drawCloud(canvas, Offset(1200, 100), 55, cloudPaint);
  }

  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    // 雲を複数の円で構成
    canvas.drawCircle(center, size * 0.8, paint);
    canvas.drawCircle(
        Offset(center.dx - size * 0.5, center.dy), size * 0.6, paint);
    canvas.drawCircle(
        Offset(center.dx + size * 0.5, center.dy), size * 0.6, paint);
    canvas.drawCircle(Offset(center.dx - size * 0.2, center.dy - size * 0.4),
        size * 0.5, paint);
    canvas.drawCircle(Offset(center.dx + size * 0.2, center.dy - size * 0.4),
        size * 0.5, paint);
  }
}
