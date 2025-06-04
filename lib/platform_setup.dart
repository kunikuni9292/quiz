import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

Future<void> setupPlatformSpecific() async {
  try {
    // デスクトップ用のウィンドウサイズ設定
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      setWindowTitle('My Mario Game');
      setWindowMinSize(const Size(1280, 720));
      setWindowMaxSize(const Size(1920, 1080));
      setWindowFrame(const Rect.fromLTWH(100, 100, 1280, 720));
    }

    // モバイル用の画面回転設定
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // ステータスバーとナビゲーションバーを非表示（モバイルのみ）
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  } catch (e) {
    print('プラットフォーム設定でエラーが発生しました: $e');
  }
}
