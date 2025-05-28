import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_models/quiz_view_model.dart';
import '../models/quiz_model.dart';

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
          quizState.showResult
              ? _buildResultScreen(context, quizState, viewModel)
              : _buildQuizScreen(context, quizState, viewModel),
    );
  }

  Widget _buildQuizScreen(
    BuildContext context,
    QuizState quizState,
    QuizViewModel viewModel,
  ) {
    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
    final progress =
        (quizState.currentQuestionIndex + 1) / quizState.questions.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // プログレスバー
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          // 進捗状況
          Text(
            '問題 ${quizState.currentQuestionIndex + 1}/${quizState.questions.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // スコア
          Text(
            'スコア: ${quizState.score}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),
          // 問題文
          Text(
            currentQuestion.question,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // 選択肢
          ...currentQuestion.answers.map(
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
                          ? (answer == currentQuestion.correctAnswer
                              ? Colors.green
                              : Colors.red)
                          : null,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  answer,
                  style: TextStyle(
                    color:
                        quizState.isAnswered
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          ),
          if (quizState.isAnswered) ...[
            const SizedBox(height: 16),
            Text(
              quizState.isCorrect ? '正解！' : '不正解...',
              style: TextStyle(
                color: quizState.isCorrect ? Colors.green : Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultScreen(
    BuildContext context,
    QuizState quizState,
    QuizViewModel viewModel,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'クイズ終了！',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'スコア: ${quizState.score}/${quizState.questions.length}',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: viewModel.resetQuiz,
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            child: const Text('もう一度挑戦'),
          ),
        ],
      ),
    );
  }
}
