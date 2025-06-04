import 'package:flame/components.dart';
import '../components/enemy.dart';
import '../components/item.dart';
import 'package:flutter/material.dart';

enum LevelLoadType { code, tiled }

class PlatformData {
  final Vector2 position;
  final Vector2 size;
  PlatformData({required this.position, required this.size});
}

class EnemyData {
  final Vector2 position;
  final EnemyType type;
  EnemyData({required this.position, required this.type});
}

class ItemData {
  final Vector2 position;
  final ItemType type;
  ItemData({required this.position, required this.type});
}

class LevelData {
  final LevelLoadType loadType;
  final String tiledFile; // 後日 Tiled を使う場合用
  final List<PlatformData> platformList;
  final List<EnemyData> enemyList;
  final List<ItemData> itemList;
  final Vector2 goalPosition;
  final List<Color> backgroundColors; // 今は色で背景代用

  LevelData({
    required this.loadType,
    this.tiledFile = '',
    required this.platformList,
    required this.enemyList,
    required this.itemList,
    required this.goalPosition,
    required this.backgroundColors,
  });

  static List<LevelData> allLevels() {
    return [
      LevelData(
        loadType: LevelLoadType.code,
        platformList: [
          // プラットフォームの位置（基準サイズ600pxでの相対位置）
          PlatformData(
              position: Vector2(300, -100), size: Vector2(200, 30)), // 浮遊足場
          PlatformData(
              position: Vector2(600, -150), size: Vector2(150, 25)), // 高い足場
          PlatformData(
              position: Vector2(900, -80), size: Vector2(180, 35)), // 長い足場
        ],
        enemyList: [
          EnemyData(
              position: Vector2(500, -32), type: EnemyType.goomba), // 地面の敵
          EnemyData(
              position: Vector2(750, -32), type: EnemyType.goomba), // 2体目の敵
        ],
        itemList: [
          ItemData(
              position: Vector2(350, -130), type: ItemType.coin), // 足場上のコイン
          ItemData(
              position: Vector2(650, -180), type: ItemType.coin), // 高い足場のコイン
          ItemData(
              position: Vector2(800, -50), type: ItemType.mushroom), // パワーアップ
          ItemData(position: Vector2(1100, -40), type: ItemType.coin), // 遠くのコイン
        ],
        goalPosition: Vector2(1400, -80), // ゴールフラグ（世界の右端近く）
        backgroundColors: [
          Colors.lightBlue.shade200,
          Colors.lightGreen.shade200,
          Colors.green.shade700,
        ],
      ),
      // 今後のステージを追加する場合は LevelLoadType.tiled などで登録
    ];
  }
}
