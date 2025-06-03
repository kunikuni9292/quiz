import 'package:flutter/material.dart';
import '../../game/my_game.dart';

class PauseMenu extends StatelessWidget {
  final MyGame game;
  const PauseMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ポーズ中',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.resumeEngine();
                game.overlays.remove('PauseMenu');
              },
              child: const Text('再開する'),
            ),
            ElevatedButton(
              onPressed: () {
                game.restartStage();
                game.overlays.remove('PauseMenu');
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
