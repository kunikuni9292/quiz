import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Background extends RectangleComponent {
  /// 画面の「地面の上端 Y 座標」
  final double groundY;

  /// 地面部分の厚み（Y 方向の高さ）
  final double groundThickness;

  Background({
    required this.groundY,
    required this.groundThickness,
  }) : super(
          size: Vector2.zero(), // 実際のサイズは onGameResize で受け取る
          position: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    // 特に何もしない
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    // GameWidget が持つ「実際のキャンバスサイズ（ピクセル換算）」を受け取るタイミング
    size.setFrom(canvasSize); // size.x=canvasSize.x, size.y=canvasSize.y
    print('[Background] onGameResize: canvasSize = $canvasSize, size = $size');
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) {
    final rect = toRect(); // (0,0)-(size.x, size.y) がキャンバス全体

    // ─── ① 空のグラデーションを「画面の上から groundY まで」の領域に描く ─────────────────
    final skyRect = Rect.fromLTWH(0, 0, rect.width, groundY);
    final skyGradient = LinearGradient(
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
    final skyPaint = Paint()..shader = skyGradient.createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // ─── ② 地面のグラデーションを「groundY から下限まで」に描く ────────────────────────
    final groundRect = Rect.fromLTWH(
      0,
      groundY,
      rect.width,
      groundThickness,
    );
    final grassGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF32CD32), // ライムグリーン（上部）
        const Color(0xFF228B22), // フォレストグリーン（中部）
        const Color(0xFF006400), // ダークグリーン（下部）
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    final grassPaint = Paint()..shader = grassGradient.createShader(groundRect);
    canvas.drawRect(groundRect, grassPaint);

    // 地面境界線を少し太めに描いて強調
    final borderPaint = Paint()
      ..color = const Color(0xFF006400)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(0, groundY),
      Offset(rect.width, groundY),
      borderPaint,
    );

    // ─── ③ おまけ：地面タイル模様（任意） ───────────────────────────────────
    _drawGroundTiles(canvas, groundRect);

    // ─── ④ 雲などを「空の領域」に上書き描画（お好みで） ──────────────────────────
    _drawClouds(canvas, skyRect);

    super.render(canvas);
  }

  void _drawGroundTiles(Canvas canvas, Rect groundRect) {
    final blockPaint1 = Paint()..color = const Color(0xFF8B4513);
    final blockPaint2 = Paint()..color = const Color(0xFFA0522D);
    const tileSize = 20.0;

    for (double x = groundRect.left; x < groundRect.right; x += tileSize) {
      for (double y = groundRect.top; y < groundRect.bottom; y += tileSize) {
        final isOffset = ((y / tileSize).round() % 2 == 1);
        final offsetX = isOffset ? tileSize / 2 : 0;
        final tileRect = Rect.fromLTWH(
          x + offsetX,
          y,
          tileSize,
          tileSize,
        );
        canvas.drawRect(tileRect, blockPaint1);

        // 簡単な罫線を入れてブロック模様っぽく
        final linePaint = Paint()
          ..color = blockPaint2.color
          ..strokeWidth = 1;
        canvas.drawLine(tileRect.topLeft, tileRect.topRight, linePaint);
        canvas.drawLine(tileRect.topLeft, tileRect.bottomLeft, linePaint);
      }
    }
  }

  void _drawClouds(Canvas canvas, Rect skyRect) {
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
    _drawCloud(canvas, Offset(skyRect.width * 0.2, skyRect.height * 0.2), 60,
        cloudPaint);
    _drawCloud(canvas, Offset(skyRect.width * 0.5, skyRect.height * 0.3), 55,
        cloudPaint);
    _drawCloud(canvas, Offset(skyRect.width * 0.8, skyRect.height * 0.15), 65,
        cloudPaint);
  }

  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size * 0.8, paint);
    canvas.drawCircle(
      Offset(center.dx - size * 0.5, center.dy),
      size * 0.6,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + size * 0.5, center.dy),
      size * 0.6,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - size * 0.2, center.dy - size * 0.4),
      size * 0.5,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + size * 0.2, center.dy - size * 0.4),
      size * 0.5,
      paint,
    );
  }
}
