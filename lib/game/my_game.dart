import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'components/player.dart';
import 'components/platform.dart';
import 'components/enemy.dart';
import 'components/item.dart';
import 'components/goal_flag.dart';
import 'components/background.dart';
import 'level/level_data.dart';
import 'utils/constants.dart';

class MyGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // HUD 表示用のステータス
  int coinCount = 0;
  int lifeCount = 3;

  // ステージ管理
  int currentStageIndex = 0;
  final List<LevelData> levels = LevelData.allLevels();

  // プレイヤー参照
  late Player player;

  @override
  Future<void> onLoad() async {
    // 1. 背景（現時点では単色コンテナで代用）
    add(Background(layerColors: levels[currentStageIndex].backgroundColors));

    // 2. プレイヤーを生成して指定位置に配置
    // 地面より1px上に浮かせて配置し、重力で確実に落ちて着地するようにする
    final playerSpawnY =
        levels[currentStageIndex].groundY - PlayerConstants.smallSize.y - 1;
    player = Player(position: Vector2(100, playerSpawnY));
    add(player);
    print(
        'Player spawned at: (100, $playerSpawnY), ground Y: ${levels[currentStageIndex].groundY}');

    // 3. 足場を配置
    if (levels[currentStageIndex].loadType == LevelLoadType.code) {
      print(
          'Placing ${levels[currentStageIndex].platformList.length} platforms');
      for (final plat in levels[currentStageIndex].platformList) {
        final platform = Platform(position: plat.position, size: plat.size);
        add(platform);
        print('Platform added at: ${plat.position}, size: ${plat.size}');
      }
    } else {
      // 後から Tiled 読み込みを実装するときはここを差し替える
    }

    // 4. 敵を配置
    for (final e in levels[currentStageIndex].enemyList) {
      add(Enemy(position: e.position, type: e.type));
    }

    // 5. アイテムを配置
    for (final it in levels[currentStageIndex].itemList) {
      add(Item(position: it.position, type: it.type));
    }

    // 6. ゴールフラグを配置
    add(GoalFlag(position: levels[currentStageIndex].goalPosition));

    // 7. カメラ設定を改善
    camera.viewfinder.visibleGameSize = Vector2(800, 600);
    camera.follow(player);

    // 8. HUD オーバーレイを表示
    overlays.add('Hud');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // ライフが 0 ならゲームオーバー
    if (lifeCount <= 0) {
      pauseEngine();
      overlays.remove('Hud');
      overlays.add('GameOver');
    }
  }

  /// ステージクリア時に呼び出す
  void onStageClear() {
    pauseEngine();
    overlays.remove('Hud');
    overlays.add('StageClear');
  }

  /// プレイヤーがライフ失った際に呼び出す
  void reduceLife() {
    lifeCount--;
  }

  /// プレイヤーがコイン取得時に呼び出す
  void addCoin() {
    coinCount++;
  }

  /// 現在ステージをリスタートする
  Future<void> restartStage() async {
    removeAll(children);
    await onLoad();
    resumeEngine();
    overlays.add('Hud');
  }

  /// 次のステージへ移動
  Future<void> nextStage() async {
    removeAll(children);
    currentStageIndex++;
    if (currentStageIndex >= levels.length) {
      // 全クリア → タイトル or リザルト画面へ遷移実装
      overlays.add('GameOver'); // 仮にゲームオーバーにしておく
    } else {
      await onLoad();
      resumeEngine();
      overlays.add('Hud');
    }
  }
}
