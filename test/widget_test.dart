// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/main.dart';

void main() {
  testWidgets('クイズアプリの基本テスト', (WidgetTester tester) async {
    // アプリをビルド
    await tester.pumpWidget(const ProviderScope(child: QuizApp()));
    await tester.pumpAndSettle();

    // 最初の問題が表示されていることを確認
    expect(find.text('日本の首都は？'), findsOneWidget);
    expect(find.text('東京'), findsOneWidget);
    expect(find.text('大阪'), findsOneWidget);
    expect(find.text('名古屋'), findsOneWidget);
    expect(find.text('福岡'), findsOneWidget);

    // 正解を選択
    await tester.tap(find.text('東京'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 2問目の問題が表示されていることを確認
    expect(find.text('世界で最も大きな大陸は？'), findsOneWidget);
    expect(find.text('アジア'), findsOneWidget);
    expect(find.text('アフリカ'), findsOneWidget);
    expect(find.text('北アメリカ'), findsOneWidget);
    expect(find.text('南アメリカ'), findsOneWidget);

    // 正解を選択
    await tester.tap(find.text('アジア'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 結果画面が表示されていることを確認
    expect(find.text('クイズ終了！'), findsOneWidget);
    expect(find.text('スコア: 2/2'), findsOneWidget);
    expect(find.text('もう一度挑戦'), findsOneWidget);

    // リトライボタンをタップ
    await tester.tap(find.text('もう一度挑戦'));
    await tester.pump();
    await tester.pumpAndSettle();

    // 最初の問題に戻っていることを確認
    expect(find.text('日本の首都は？'), findsOneWidget);
  });
}
