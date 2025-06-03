import 'package:flame/components.dart';
import '../components/enemy.dart';
import '../components/item.dart';

// プレイヤー関連定数
class PlayerConstants {
  // 後で画像に置き換えるときは以下のコメントを活用
  // static const String spriteSheetPath = 'assets/images/player/player_sprites.png';
  static final Vector2 frameSize = Vector2(32, 32);
  static final Vector2 smallSize = Vector2(32, 32);
  static final Vector2 bigSize = Vector2(48, 48);

  // マリオらしい動きのための定数
  static const double moveAcceleration = 600; // px/s^2 加速度
  static const double friction = 800; // px/s^2 地面での減速
  static const double maxMoveSpeed = 150; // 最高速度
  static const double jumpSpeed = 300;
  static const double gravity = 800;
  static const double stompBounceSpeed = 200;
  static const double respawnY = 418; // 地面（450）の32px上に配置

  // ジャンプの高さを調整するための定数
  static const double jumpGraceTime = 0.2; // ジャンプボタン押し続けで上昇維持
  static const double stompInvincibleTime = 0.1; // 踏みつけ後の無敵時間
}

// 敵関連定数
class EnemyConstants {
  static Vector2 size = Vector2(32, 32);
  // 後でスプライトを指定する場合はコメントを参照
  // static String spriteSheetPath(EnemyType type) {
  //   switch(type) {
  //     case EnemyType.goomba: return 'assets/images/enemy/goomba.png';
  //   }
  // }
  static double walkSpeed(EnemyType type) {
    switch (type) {
      case EnemyType.goomba:
        return -50; // 画面左向きに歩かせる場合は負の値
    }
  }
}

// アイテム関連定数
class ItemConstants {
  static Vector2 size(ItemType type) {
    switch (type) {
      case ItemType.coin:
        return Vector2(16, 16);
      case ItemType.mushroom:
        return Vector2(16, 16);
    }
  }

  // 後で画像パスを設定する場合のコメント
  // static String imagePath(ItemType type) {
  //   switch(type) {
  //     case ItemType.coin: return 'assets/images/items/coin.png';
  //     case ItemType.mushroom: return 'assets/images/items/mushroom.png';
  //   }
  // }
}

// 背景レイヤー用
class BackgroundConstants {
  // 後日、'assets/images/background/bg_layerX.png' などに置き換え可能
}

// ステージ関連
class StageConstants {
  static const double defaultWorldWidth = 1600;
  static const double defaultWorldHeight = 600;
  static const double groundY = 450; // 地面の Y 座標
}
