import 'package:flame/components.dart';
import '../components/enemy.dart';
import '../components/item.dart';

// ゲーム全体の定数管理
class GameConstants {
  // 動的世界サイズ計算（スマホ横画面基準）
  static Vector2 getWorldSize(Vector2 screenSize) {
    // 横画面を前提として、画面の幅と高さをそのまま使用
    // 世界の幅は画面幅の3倍程度にしてスクロール感を出す
    final worldWidth = screenSize.x * 3.0;
    final worldHeight = screenSize.y;
    return Vector2(worldWidth, worldHeight);
  }

  // プレイヤーの初期位置を画面下部に設定
  static Vector2 getPlayerSpawnPosition(Vector2 screenSize) {
    final playerSize = getScaledPlayerSize(screenSize);
    // プレイヤーを画面下部の少し上に配置
    final spawnY =
        screenSize.y - screenSize.y * 0.25 - playerSize.y; // 画面下から25%上の位置
    final spawnX = screenSize.x * 0.1; // 画面幅の10%の位置

    return Vector2(spawnX, spawnY);
  }

  // プレイヤーの足元に地面を配置
  static double getGroundY(Vector2 screenSize) {
    final playerSize = getScaledPlayerSize(screenSize);
    final playerY = screenSize.y - screenSize.y * 0.25 - playerSize.y;
    // プレイヤーの下端（足元）から地面開始
    return playerY + playerSize.y;
  }

  // 地面の厚さ：プレイヤーの足元から画面下端まで
  static double getGroundThickness(Vector2 screenSize) {
    final groundY = getGroundY(screenSize);
    return screenSize.y - groundY;
  }

  // 衝突判定の許容値（画面サイズに比例）
  static double getCollisionTolerance(Vector2 screenSize) {
    return screenSize.y * 0.01; // 画面高さの1%
  }

  static double getStompTolerance(Vector2 screenSize) {
    return screenSize.y * 0.01; // 画面高さの1%
  }

  static double getFallThreshold(Vector2 screenSize) {
    return screenSize.y * 0.2; // 画面高さの20%
  }

  // プレイヤーサイズも画面に比例
  static Vector2 getScaledPlayerSize(Vector2 screenSize) {
    final baseSize = 32.0;
    final scale = screenSize.y / 600.0; // 600pxを基準とする
    final scaledSize = baseSize * scale;
    return Vector2(scaledSize, scaledSize);
  }

  static Vector2 getScaledPlayerBigSize(Vector2 screenSize) {
    final baseSize = 48.0;
    final scale = screenSize.y / 600.0;
    final scaledSize = baseSize * scale;
    return Vector2(scaledSize, scaledSize);
  }

  // レスポンシブデザイン対応（より精密に）
  static Vector2 getScaledSize(Vector2 baseSize, Vector2 screenSize) {
    const baseScreenHeight = 600.0; // 基準となる画面高さ
    final scale = screenSize.y / baseScreenHeight;
    return Vector2(baseSize.x * scale, baseSize.y * scale);
  }

  static double getScaledValue(double baseValue, Vector2 screenSize) {
    const baseScreenHeight = 600.0;
    final scale = screenSize.y / baseScreenHeight;
    return baseValue * scale;
  }

  // カメラ設定用
  static Vector2 getCameraInitialPosition(Vector2 screenSize) {
    final groundY = getGroundY(screenSize);
    final camHalfHeight = screenSize.y / 2;
    final cameraOffsetY = getScaledValue(80, screenSize);
    return Vector2(
      screenSize.x * 0.5, // 画面中央
      groundY - camHalfHeight + cameraOffsetY,
    );
  }
}

// プレイヤー関連定数（動的サイズ対応）
class PlayerConstants {
  // 動的サイズ取得メソッド
  static Vector2 getSmallSize(Vector2 screenSize) =>
      GameConstants.getScaledPlayerSize(screenSize);

  static Vector2 getBigSize(Vector2 screenSize) =>
      GameConstants.getScaledPlayerBigSize(screenSize);

  // 物理定数も画面サイズに比例させる
  static double getMoveAcceleration(Vector2 screenSize) =>
      GameConstants.getScaledValue(600, screenSize);

  static double getFriction(Vector2 screenSize) =>
      GameConstants.getScaledValue(800, screenSize);

  static double getMaxMoveSpeed(Vector2 screenSize) =>
      GameConstants.getScaledValue(150, screenSize);

  static double getJumpSpeed(Vector2 screenSize) =>
      GameConstants.getScaledValue(300, screenSize);

  static double getGravity(Vector2 screenSize) =>
      GameConstants.getScaledValue(800, screenSize);

  static double getStompBounceSpeed(Vector2 screenSize) =>
      GameConstants.getScaledValue(200, screenSize);

  // 固定値の定数
  static const double jumpGravityMultiplier = 0.5;
  static const double runThreshold = 10.0;
  static const double jumpGraceTime = 0.2;
  static const double stompInvincibleTime = 0.1;
}

// 敵関連定数（動的サイズ対応）
class EnemyConstants {
  static Vector2 getSize(Vector2 screenSize) {
    return GameConstants.getScaledSize(Vector2(32, 32), screenSize);
  }

  static double getWalkSpeed(EnemyType type, Vector2 screenSize) {
    final baseSpeed = switch (type) {
      EnemyType.goomba => -50.0,
    };
    return GameConstants.getScaledValue(baseSpeed, screenSize);
  }
}

// アイテム関連定数（動的サイズ対応）
class ItemConstants {
  static Vector2 getSize(ItemType type, Vector2 screenSize) {
    final baseSize = switch (type) {
      ItemType.coin => Vector2(16, 16),
      ItemType.mushroom => Vector2(16, 16),
    };
    return GameConstants.getScaledSize(baseSize, screenSize);
  }
}

// 背景レイヤー用
class BackgroundConstants {
  // 後日、'assets/images/background/bg_layerX.png' などに置き換え可能
}

// ステージ関連
class StageConstants {
  static const double defaultWorldWidth = 1600;
  static const double defaultWorldHeight = 600;
  // groundYは動的に計算されるため削除
}

// UIレスポンシブ定数
class UIConstants {
  static const double hudPadding = 16.0;
  static const double buttonSize = 48.0;
  static const double fontSize = 24.0;
  static const double controlPanelWidth = 200.0;

  // 画面サイズに応じたUI調整
  static double getScaledFontSize(Vector2 screenSize) {
    final scaledSize = GameConstants.getScaledValue(fontSize, screenSize);
    return scaledSize.clamp(16.0, 32.0);
  }

  static double getScaledButtonSize(Vector2 screenSize) {
    final scaledSize = GameConstants.getScaledValue(buttonSize, screenSize);
    return scaledSize.clamp(40.0, 80.0);
  }

  static double getScaledPadding(Vector2 screenSize) {
    final scaledSize = GameConstants.getScaledValue(hudPadding, screenSize);
    return scaledSize.clamp(12.0, 24.0);
  }
}
