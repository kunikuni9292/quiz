import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'game/my_game.dart';
import 'ui/overlays/hud.dart';
import 'ui/overlays/pause_menu.dart';
import 'ui/overlays/game_over.dart';
import 'ui/overlays/stage_clear.dart';

// 条件付きimport: Web環境では専用のスタブを使用
import 'platform_setup.dart' if (dart.library.html) 'platform_setup_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // プラットフォーム固有の設定
  await setupPlatformSpecific();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            // 回転ごとに新しい Game インスタンスを作成して安定性を確保
            final isLandscape = constraints.maxWidth >= constraints.maxHeight;
            final myGame = MyGame();

            print(
                '画面サイズ変更: ${constraints.maxWidth}x${constraints.maxHeight} (${isLandscape ? "横" : "縦"})');

            return GameWidget<MyGame>(
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
            );
          },
        ),
      ),
    );
  }
}
