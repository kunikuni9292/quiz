import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_models/quiz_view_model.dart';

class QuizView extends HookConsumerWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizViewModelProvider);
    final viewModel = ref.read(quizViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズアプリ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          quizState.currentQuestionIndex < quizState.questions.length
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quizState
                          .questions[quizState.currentQuestionIndex]
                          .question,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...quizState
                        .questions[quizState.currentQuestionIndex]
                        .answers
                        .map(
                          (answer) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed:
                                  quizState.isAnswered
                                      ? null
                                      : () => viewModel.answerQuestion(answer),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    quizState.isAnswered
                                        ? (answer ==
                                                quizState
                                                    .questions[quizState
                                                        .currentQuestionIndex]
                                                    .correctAnswer
                                            ? Colors.green
                                            : Colors.red)
                                        : null,
                              ),
                              child: Text(answer),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'クイズ終了！\nスコア: ${quizState.score}/${quizState.questions.length}',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: viewModel.resetQuiz,
                      child: const Text('もう一度挑戦'),
                    ),
                  ],
                ),
              ),
    );
  }
}
