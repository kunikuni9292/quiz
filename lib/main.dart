import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/my_game.dart';
import 'ui/overlays/hud.dart';
import 'ui/overlays/pause_menu.dart';
import 'ui/overlays/game_over.dart';
import 'ui/overlays/stage_clear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myGame = MyGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<MyGame>(
          game: myGame,
          overlayBuilderMap: {
            'Hud': (BuildContext context, MyGame game) => Hud(game: game),
            'PauseMenu': (BuildContext context, MyGame game) =>
                PauseMenu(game: game),
            'GameOver': (BuildContext context, MyGame game) =>
                GameOverOverlay(game: game),
            'StageClear': (BuildContext context, MyGame game) =>
                StageClearOverlay(game: game),
          },
          initialActiveOverlays: const ['Hud'],
        ),
      ),
    );
  }
}
