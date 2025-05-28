import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quiz/viewmodels/quiz_viewmodel.dart';
import 'dart:async';

class QuizView extends HookConsumerWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizViewModelProvider);
    final viewModel = ref.read(quizViewModelProvider.notifier);
    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
    final displayedText = useState('');
    final isAnimationStopped = useState(false);
    final showOptions = useState(false);
    final currentCharIndex = useState(0);
    final userAnswer = useState<String>('');
    final currentOptions = useState<List<String>>([]);
    final optionTimer = useState<Timer?>(null);
    final optionRemainingTime = useState(3);
    final isOptionTimeUp = useState(false);
    final isAnimationComplete = useState(false);

    // 選択肢の文字を生成する関数
    List<String> generateOptionChars(String answer, int charIndex) {
      if (charIndex >= answer.length) return [];

      // 正解の文字
      final correctChar = answer[charIndex];
      final Set<String> usedChars = {correctChar};

      // ランダムな文字を生成（正解の文字以外）
      final randomChars = List.generate(3, (_) {
        String randomChar;
        do {
          // ひらがな、カタカナの範囲からランダムに選択
          final isHiragana = DateTime.now().millisecondsSinceEpoch % 2 == 0;
          int charCode;
          if (isHiragana) {
            // ひらがな
            charCode = 0x3040 +
                (DateTime.now().millisecondsSinceEpoch % (0x309F - 0x3040));
          } else {
            // カタカナ
            charCode = 0x30A0 +
                (DateTime.now().millisecondsSinceEpoch % (0x30FF - 0x30A0));
          }
          randomChar = String.fromCharCode(charCode);
        } while (usedChars.contains(randomChar));
        usedChars.add(randomChar);
        return randomChar;
      });

      // 正解の文字とランダムな文字を混ぜる
      final allChars = [...randomChars, correctChar];
      allChars.shuffle();
      return allChars;
    }

    // タイマーを開始する関数
    void startOptionTimer() {
      optionRemainingTime.value = 3;
      isOptionTimeUp.value = false;
      optionTimer.value?.cancel();
      optionTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (optionRemainingTime.value > 0) {
          optionRemainingTime.value--;
        } else {
          timer.cancel();
          isOptionTimeUp.value = true;
          // 制限時間切れで不正解
          viewModel.answerQuestion('不正解');
        }
      });
    }

    useEffect(() {
      // 問題文と表示文字をリセット
      final questionText = currentQuestion.question;
      displayedText.value = '';
      isAnimationStopped.value = false;
      showOptions.value = false;
      currentCharIndex.value = 0;
      userAnswer.value = '';
      currentOptions.value = [];
      optionTimer.value?.cancel();
      optionRemainingTime.value = 3;
      isOptionTimeUp.value = false;
      isAnimationComplete.value = false;

      // ローカルの文字インデックス
      var charIndex = 0;

      // このEffect専用のタイマー
      final timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (t) {
          if (!isAnimationStopped.value && charIndex < questionText.length) {
            displayedText.value += questionText[charIndex++];
          } else {
            t.cancel();
            // 問題文のアニメーションが完了したことを記録
            isAnimationComplete.value = true;
            // 問題文のアニメーション終了後にタイマーを開始
            if (!isAnimationStopped.value) {
              viewModel.startTimer();
            }
          }
        },
      );

      // クリーンアップ
      return () {
        timer.cancel();
        optionTimer.value?.cancel();
      };
    }, [quizState.currentQuestionIndex]);

    // 文字選択時の処理
    void handleCharSelection(String selectedChar) {
      final correctAnswer = currentQuestion.correctAnswer;
      if (selectedChar == correctAnswer[currentCharIndex.value]) {
        userAnswer.value += selectedChar;
        if (userAnswer.value.length == correctAnswer.length) {
          // 完全な回答が完成した場合
          optionTimer.value?.cancel();
          viewModel.answerQuestion(userAnswer.value);
        } else {
          // 次の文字の選択肢を表示
          currentCharIndex.value++;
          currentOptions.value =
              generateOptionChars(correctAnswer, currentCharIndex.value);
          startOptionTimer();
        }
      } else {
        // 不正解の場合
        optionTimer.value?.cancel();
        viewModel.answerQuestion('不正解');
      }
    }

    // ストップボタン押下時の処理
    void handleStopButton() {
      isAnimationStopped.value = true;
      showOptions.value = true;
      currentOptions.value =
          generateOptionChars(currentQuestion.correctAnswer, 0);
      viewModel.stopTimer();
      startOptionTimer();
    }

    // 結果画面への遷移をuseEffectで制御
    useEffect(() {
      if (quizState.showResult) {
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, '/result');
        });
      }
      return null;
    }, [quizState.showResult]);

    if (quizState.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '問題 ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: quizState.remainingTime /
                                    quizState.timeLimit,
                                backgroundColor: Colors.white.withAlpha(30),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  quizState.remainingTime > 6
                                      ? Colors.green
                                      : quizState.remainingTime > 3
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                                minHeight: 20,
                              ),
                            ),
                            Text(
                              '${quizState.remainingTime.toStringAsFixed(2)}秒',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'スコア: ${quizState.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      displayedText.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isAnimationStopped.value)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: handleStopButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '解答！',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (showOptions.value)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (userAnswer.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Text(
                            userAnswer.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isOptionTimeUp.value)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            '残り時間: ${optionRemainingTime.value}秒',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: currentOptions.value
                            .map((char) => SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: ElevatedButton(
                                    onPressed: () => handleCharSelection(char),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      char,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              if (quizState.isAnswered)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedOpacity(
                    opacity: quizState.isAnswered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: quizState.isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quizState.isCorrect ? '正解！' : '不正解...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
