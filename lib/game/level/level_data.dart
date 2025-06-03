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
  final double worldWidth;
  final double worldHeight;
  final double groundY;

  LevelData({
    required this.loadType,
    this.tiledFile = '',
    required this.platformList,
    required this.enemyList,
    required this.itemList,
    required this.goalPosition,
    required this.backgroundColors,
    required this.worldWidth,
    required this.worldHeight,
    required this.groundY,
  });

  static List<LevelData> allLevels() {
    return [
      LevelData(
        loadType: LevelLoadType.code,
        platformList: [
          PlatformData(position: Vector2(0, 450), size: Vector2(800, 50)),
          PlatformData(position: Vector2(200, 350), size: Vector2(150, 20)),
          // 必要なら他の足場を追加
        ],
        enemyList: [
          EnemyData(position: Vector2(400, 418), type: EnemyType.goomba),
          // 他の敵を追加する場合はここに記載
        ],
        itemList: [
          ItemData(position: Vector2(250, 318), type: ItemType.coin),
          ItemData(position: Vector2(500, 450), type: ItemType.mushroom),
        ],
        goalPosition: Vector2(1200, 386),
        backgroundColors: [
          Colors.lightBlue.shade200,
          Colors.lightGreen.shade200,
          Colors.green.shade700,
        ],
        worldWidth: 1600,
        worldHeight: 600,
        groundY: 450,
      ),
      // 今後のステージを追加する場合は LevelLoadType.tiled などで登録
    ];
  }
}
