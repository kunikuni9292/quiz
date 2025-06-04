import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'dart:ui';
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

  // 追加: 画面向きで変わる倍率
  late int coinMultiplier;

  // ステージ管理
  int currentStageIndex = 0;
  final List<LevelData> levels = LevelData.allLevels();

  // プレイヤー参照
  late Player player;

  // 動的世界サイズ
  late Vector2 worldSize;

  @override
  Future<void> onLoad() async {
    // レスポンシブデザイン対応: 画面サイズを取得
    final screenSize = size;

    // 先に倍率を計算
    _updateMultiplier(screenSize);

    // 固定解像度ビューポート用のサイズ
    final fixedResolution = Vector2(1600, 900);

    // 動的世界サイズを計算（固定解像度基準）
    worldSize = GameConstants.getWorldSize(fixedResolution);

    // 地面のY座標を固定解像度基準で計算
    final groundY = GameConstants.getGroundY(fixedResolution);
    final groundThickness = GameConstants.getGroundThickness(fixedResolution);
    final currentLevel = levels[currentStageIndex];

    // 背景を固定解像度に合わせて描画
    add(Background(
      groundY: groundY,
      groundThickness: groundThickness,
    ));

    // プレイヤーを地面の上に設置（固定解像度基準）
    final playerSpawnPosition =
        GameConstants.getPlayerSpawnPosition(fixedResolution);
    player = Player(position: playerSpawnPosition);
    add(player);

    // 地面プラットフォームを画面下端に固定して配置
    add(Platform(
      position: Vector2(0, groundY),
      size: Vector2(worldSize.x, groundThickness),
    ));

    // その他のプラットフォーム／敵／アイテムを追加
    await _loadLevelContent(currentLevel, groundY, fixedResolution);

    // カメラ設定：固定解像度対応
    _setupCamera(fixedResolution, groundY);

    // HUD オーバーレイを表示
    overlays.add('Hud');
  }

  // 画面サイズが変わったら倍率も更新
  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    _updateMultiplier(canvasSize);
  }

  void _updateMultiplier(Vector2 s) {
    final bool isLandscape = s.x >= s.y;
    coinMultiplier = isLandscape ? 1 : 2;
    print('画面向き: ${isLandscape ? "横" : "縦"}, コイン倍率: ${coinMultiplier}x');
  }

  Future<void> _loadLevelContent(
      LevelData level, double groundY, Vector2 screenSize) async {
    if (level.loadType == LevelLoadType.code) {
      // プラットフォームを配置（固定解像度に応じてスケール）
      for (final plat in level.platformList) {
        final scaledPosition =
            GameConstants.getScaledSize(plat.position, screenSize);
        final scaledSize = GameConstants.getScaledSize(plat.size, screenSize);

        final absoluteY = scaledPosition.y < 0
            ? groundY + scaledPosition.y // 地面からの相対位置
            : scaledPosition.y; // 絶対位置
        final platform = Platform(
            position: Vector2(scaledPosition.x, absoluteY), size: scaledSize);
        add(platform);
      }
    }

    // 敵を配置（固定解像度に応じてスケール）
    for (final e in level.enemyList) {
      final scaledPosition =
          GameConstants.getScaledSize(e.position, screenSize);
      final absoluteY = scaledPosition.y < 0
          ? groundY + scaledPosition.y // 地面からの相対位置
          : scaledPosition.y; // 絶対位置
      add(Enemy(position: Vector2(scaledPosition.x, absoluteY), type: e.type));
    }

    // アイテムを配置（固定解像度に応じてスケール）
    for (final it in level.itemList) {
      final scaledPosition =
          GameConstants.getScaledSize(it.position, screenSize);
      final absoluteY = scaledPosition.y < 0
          ? groundY + scaledPosition.y // 地面からの相対位置
          : scaledPosition.y; // 絶対位置
      add(Item(position: Vector2(scaledPosition.x, absoluteY), type: it.type));
    }

    // ゴールフラグを配置（固定解像度に応じてスケール）
    final scaledGoalPosition =
        GameConstants.getScaledSize(level.goalPosition, screenSize);
    final goalY = scaledGoalPosition.y < 0
        ? groundY + scaledGoalPosition.y // 地面からの相対位置
        : scaledGoalPosition.y; // 絶対位置
    add(GoalFlag(position: Vector2(scaledGoalPosition.x, goalY)));
  }

  void _setupCamera(Vector2 screenSize, double groundY) {
    // ① ビューポートはそのまま固定解像度
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1600, 900));

    // ② プレイヤーを横方向のみ追従（縦方向は固定）
    camera.follow(player, horizontalOnly: true);

    // ③ カメラの初期Y位置を地面が見える位置に固定
    final targetCameraY = groundY - (900 * 0.3);
    camera.viewfinder.position = Vector2(
      player.position.x, // プレイヤーのX座標から開始
      targetCameraY,
    );

    // デバッグ情報を出力
    print('カメラ設定: ワールドサイズ=$worldSize, プレイヤー位置=${player.position}');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // camera.follow()が水平追従を担当するので、ここでは境界制限のみ
    final cameraPos = camera.viewfinder.position;
    final halfViewWidth = 800.0; // 1600/2

    // X軸の境界制限（ワールドからはみ出さないように）
    if (cameraPos.x < halfViewWidth) {
      camera.viewfinder.position = Vector2(halfViewWidth, cameraPos.y);
    } else if (cameraPos.x > worldSize.x - halfViewWidth) {
      camera.viewfinder.position =
          Vector2(worldSize.x - halfViewWidth, cameraPos.y);
    }

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

  /// プレイヤーがコイン取得時に呼び出す（倍率対応）
  void addCoin() {
    coinCount += coinMultiplier;
    print('コイン獲得! +${coinMultiplier} (合計: $coinCount)');
  }

  /// 現在ステージをリスタートする
  Future<void> restartStage() async {
    // ライフを初期値に戻す
    lifeCount = 3;
    // コインカウントを初期値に戻す
    coinCount = 0;

    removeAll(children);
    await onLoad();
    resumeEngine();
    overlays.remove('GameOver');
    overlays.remove('StageClear');
    overlays.add('Hud');
  }

  /// ゲーム全体をリセットして最初から始める
  Future<void> resetGame() async {
    // 全ての状態を初期値に戻す
    lifeCount = 3;
    coinCount = 0;
    currentStageIndex = 0;

    removeAll(children);
    overlays.removeAll(['GameOver', 'StageClear', 'Hud']);
    await onLoad();
    resumeEngine();
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
