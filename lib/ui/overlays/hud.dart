import 'package:flutter/material.dart';
import '../../game/my_game.dart';

class Hud extends StatelessWidget {
  final MyGame game;
  const Hud({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 既存のコイン・ライフ表示（左上）
        Positioned(
          top: 10,
          left: 10,
          child: Row(
            children: [
              // コイン数表示
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: const Icon(Icons.monetization_on,
                        color: Colors.orange, size: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${game.coinCount}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              blurRadius: 2,
                              color: Colors.black,
                              offset: Offset(1, 1))
                        ]),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // ライフ数表示
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.pink, width: 2),
                    ),
                    child: const Icon(Icons.favorite,
                        color: Colors.pink, size: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${game.lifeCount}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              blurRadius: 2,
                              color: Colors.black,
                              offset: Offset(1, 1))
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 操作説明（右上）
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '🎮 操作方法',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '←→/A,D: 移動',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'スペース: ジャンプ',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  '🟥を踏んで倒せ！',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  '🟨コイン集め',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  '🟩ゴールを目指せ！',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // ゲーム状態表示（画面中央上部）
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                'ステージ ${game.currentStageIndex + 1} - マリオ風ゲーム',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                        blurRadius: 2,
                        color: Colors.black,
                        offset: Offset(1, 1))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
