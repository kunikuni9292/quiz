import 'package:flutter/material.dart';
import '../../game/my_game.dart';

class StageClearOverlay extends StatelessWidget {
  final MyGame game;
  const StageClearOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ステージクリア！おめでとう！',
              style: TextStyle(fontSize: 24, color: Colors.yellowAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.nextStage();
                game.overlays.remove('StageClear');
                game.overlays.add('Hud');
              },
              child: const Text('次へ進む'),
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
