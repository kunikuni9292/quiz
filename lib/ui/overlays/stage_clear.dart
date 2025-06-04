import 'package:flutter/material.dart';
import '../../game/my_game.dart';

class StageClearOverlay extends StatelessWidget {
  final MyGame game;
  const StageClearOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.yellowAccent.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 48,
              color: Colors.yellowAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'ステージクリア！',
              style: TextStyle(
                fontSize: 28,
                color: Colors.yellowAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'おめでとうございます！',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'コイン: ${game.coinCount}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.yellowAccent,
              ),
            ),
            const SizedBox(height: 24),

            // 次のステージに進むボタン
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                game.nextStage();
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text(
                '次のステージへ',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 12),

            // このステージをもう一度プレイ
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                game.restartStage();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                'もう一度プレイ',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 12),

            // 最初からやり直すボタン
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                game.resetGame();
              },
              icon: const Icon(Icons.replay),
              label: const Text(
                '最初からやり直す',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 12),

            // タイトルに戻るボタン
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.home),
              label: const Text(
                'タイトルに戻る',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
