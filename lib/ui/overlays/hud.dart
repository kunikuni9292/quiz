import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../../game/my_game.dart';
import '../../game/utils/constants.dart';

class Hud extends StatelessWidget {
  final MyGame game;
  const Hud({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gameScreenSize = Vector2(screenSize.width, screenSize.height);

    // レスポンシブサイズの計算
    final scaledPadding = UIConstants.getScaledPadding(gameScreenSize);
    final scaledButtonSize = UIConstants.getScaledButtonSize(gameScreenSize);
    final scaledFontSize = UIConstants.getScaledFontSize(gameScreenSize);

    return Stack(
      children: [
        // 地面の固定表示（UI レイヤー）
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height * 0.25, // 画面の下部25%に地面表示
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF32CD32), // ライムグリーン（上部）
                  Color(0xFF228B22), // フォレストグリーン（中部）
                  Color(0xFF006400), // ダークグリーン（下部）
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              children: [
                // 地面の境界線
                Container(
                  height: 4,
                  color: const Color(0xFF006400),
                ),
                // 地面タイル模様（オプション）
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      // シンプルなドット模様で地面らしさを演出
                      color: Color(0xFF228B22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // コイン・ライフ表示（左上）
        Positioned(
          top: scaledPadding,
          left: scaledPadding,
          child: _buildStatusDisplay(scaledButtonSize, scaledFontSize),
        ),

        // 操作説明（右上）
        Positioned(
          top: scaledPadding,
          right: scaledPadding,
          child: _buildControlsDisplay(scaledFontSize * 0.8),
        ),

        // ゲーム状態表示（画面中央上部）
        Positioned(
          top: scaledPadding,
          left: 0,
          right: 0,
          child: _buildGameStateDisplay(scaledFontSize),
        ),

        // ゲーム操作ボタン（右下）
        Positioned(
          bottom: scaledPadding + (screenSize.height * 0.25), // 地面の上に配置
          right: scaledPadding,
          child: _buildGameControls(context, scaledButtonSize, scaledFontSize),
        ),
      ],
    );
  }

  Widget _buildStatusDisplay(double buttonSize, double fontSize) {
    return Row(
      children: [
        // コイン数表示
        Row(
          children: [
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Icon(
                Icons.monetization_on,
                color: Colors.orange,
                size: buttonSize * 0.7,
              ),
            ),
            SizedBox(width: buttonSize * 0.2),
            Text(
              '${game.coinCount}${game.coinMultiplier > 1 ? " ×${game.coinMultiplier}" : ""}',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: buttonSize * 0.8),
        // ライフ数表示
        Row(
          children: [
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink, width: 2),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.pink,
                size: buttonSize * 0.7,
              ),
            ),
            SizedBox(width: buttonSize * 0.2),
            Text(
              '${game.lifeCount}',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlsDisplay(double fontSize) {
    return Container(
      padding: EdgeInsets.all(fontSize * 0.5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎮 操作方法',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: fontSize * 0.3),
          Text(
            '←→/A,D: 移動',
            style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
          ),
          Text(
            'スペース: ジャンプ',
            style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
          ),
          Text(
            '🟥を踏んで倒せ！',
            style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
          ),
          Text(
            '🟨コイン集め',
            style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
          ),
          Text(
            '🟩ゴールを目指せ！',
            style: TextStyle(color: Colors.white, fontSize: fontSize * 0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStateDisplay(double fontSize) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize,
          vertical: fontSize * 0.5,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'ステージ ${game.currentStageIndex + 1} - マリオ風ゲーム',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                blurRadius: 2,
                color: Colors.black,
                offset: Offset(1, 1),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameControls(
      BuildContext context, double buttonSize, double fontSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // リトライボタン
        Container(
          width: buttonSize * 2.5,
          height: buttonSize * 1.5,
          margin: EdgeInsets.only(bottom: buttonSize * 0.3),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonSize * 0.3),
              ),
            ),
            onPressed: () {
              _showRetryDialog(context);
            },
            icon: Icon(Icons.refresh, size: fontSize * 0.8),
            label: Flexible(
              child: Text(
                'リトライ',
                style: TextStyle(fontSize: fontSize * 0.7),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),

        // メニューボタン
        Container(
          width: buttonSize * 2.5,
          height: buttonSize * 1.5,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonSize * 0.3),
              ),
            ),
            onPressed: () {
              _showMenuDialog(context);
            },
            icon: Icon(Icons.menu, size: fontSize * 0.8),
            label: Flexible(
              child: Text(
                'メニュー',
                style: TextStyle(fontSize: fontSize * 0.7),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRetryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('リトライ'),
          content: const Text('現在のステージをやり直しますか？\n（ライフとコインがリセットされます）'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                game.restartStage();
              },
              child: const Text('リトライ'),
            ),
          ],
        );
      },
    );
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('メニュー'),
          content: const Text('何をしますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('続ける'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
                game.restartStage();
              },
              child: const Text('リトライ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
                game.resetGame();
              },
              child: const Text('最初から'),
            ),
          ],
        );
      },
    );
  }
}
