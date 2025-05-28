import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz/viewmodels/quiz_viewmodel.dart';

class QuizView extends HookConsumerWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizViewModelProvider);
    final viewModel = ref.read(quizViewModelProvider.notifier);

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

    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];

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
                child: Text(
                  currentQuestion.question,
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
