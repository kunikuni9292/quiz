// Web環境用のスタブファイル
// window_sizeパッケージの関数をWeb環境で無効化するためのダミー実装

import 'package:flutter/material.dart';

void setWindowTitle(String title) {
  // Web環境では何もしない
}

void setWindowMinSize(Size size) {
  // Web環境では何もしない
}

void setWindowMaxSize(Size size) {
  // Web環境では何もしない
}

void setWindowFrame(Rect rect) {
  // Web環境では何もしない
}
