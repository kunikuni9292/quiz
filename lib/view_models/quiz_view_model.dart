import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/quiz_model.dart';

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizState>((
  ref,
) {
  return QuizViewModel();
});

class QuizViewModel extends StateNotifier<QuizState> {
  QuizViewModel()
    : super(
        QuizState(
          currentQuestionIndex: 0,
          score: 0,
          questions: [
            const Quiz(
              question: '日本の首都は？',
              answers: ['東京', '大阪', '名古屋', '福岡'],
              correctAnswer: '東京',
            ),
            const Quiz(
              question: '世界で最も大きな大陸は？',
              answers: ['アジア', 'アフリカ', '北アメリカ', '南アメリカ'],
              correctAnswer: 'アジア',
            ),
          ],
        ),
      );

  void answerQuestion(String selectedAnswer) {
    final currentQuestion = state.questions[state.currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion.correctAnswer;

    state = state.copyWith(
      isAnswered: true,
      isCorrect: isCorrect,
      score: isCorrect ? state.score + 1 : state.score,
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (state.currentQuestionIndex < state.questions.length - 1) {
        state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          isAnswered: false,
          isCorrect: false,
        );
      }
    });
  }

  void resetQuiz() {
    state = state.copyWith(
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
    );
  }
}
