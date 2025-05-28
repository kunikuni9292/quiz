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

    useEffect(() {
      // 問題文と表示文字をリセット
      final questionText = currentQuestion.question;
      displayedText.value = '';

      // ローカルの文字インデックス
      var charIndex = 0;

      // このEffect専用のタイマー
      final timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (t) {
          if (charIndex < questionText.length) {
            displayedText.value += questionText[charIndex++];
          } else {
            t.cancel();
          }
        },
      );

      // クリーンアップはこのタイマーだけをキャンセル
      return timer.cancel;
    }, [quizState.currentQuestionIndex]);

    if (quizState.showResult) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/result');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
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
                                '${quizState.remainingTime}秒',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  displayedText.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final option = currentQuestion.options[index];
                    final isSelected = quizState.isAnswered &&
                        option == currentQuestion.correctAnswer;
                    final isWrong = quizState.isAnswered &&
                        option != currentQuestion.correctAnswer;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ElevatedButton(
                        onPressed: quizState.isAnswered
                            ? null
                            : () => viewModel.answerQuestion(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.white,
                          foregroundColor: isSelected || isWrong
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected || isWrong
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
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
