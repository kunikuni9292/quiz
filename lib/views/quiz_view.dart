import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/viewmodels/quiz_viewmodel.dart';

class QuizView extends HookConsumerWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizViewModelProvider);
    final viewModel = ref.read(quizViewModelProvider.notifier);

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
          child: quizState.questions.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '問題 ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        quizState
                            .questions[quizState.currentQuestionIndex].question,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      ...quizState
                          .questions[quizState.currentQuestionIndex].options
                          .asMap()
                          .entries
                          .map((entry) {
                        final option = entry.value;
                        final isSelected = quizState.isAnswered &&
                            option ==
                                quizState
                                    .questions[quizState.currentQuestionIndex]
                                    .correctAnswer;
                        final isWrong = quizState.isAnswered &&
                            !quizState.isCorrect &&
                            option ==
                                quizState
                                    .questions[quizState.currentQuestionIndex]
                                    .correctAnswer;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
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
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const Spacer(),
                      if (quizState.isAnswered)
                        ElevatedButton(
                          onPressed: () {
                            if (quizState.currentQuestionIndex <
                                quizState.questions.length - 1) {
                              viewModel.nextQuestion();
                            } else {
                              Navigator.pushNamed(context, '/result');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            quizState.currentQuestionIndex <
                                    quizState.questions.length - 1
                                ? '次の問題へ'
                                : '結果を見る',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
