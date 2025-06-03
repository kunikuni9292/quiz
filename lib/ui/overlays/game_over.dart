import 'package:flutter/material.dart';
import '../../game/my_game.dart';

class GameOverOverlay extends StatelessWidget {
  final MyGame game;
  const GameOverOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ゲームオーバー',
              style: TextStyle(fontSize: 28, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.restartStage();
                game.overlays.remove('GameOver');
                game.overlays.add('Hud');
              },
              child: const Text('リトライ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('タイトルに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
