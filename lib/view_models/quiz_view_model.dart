import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/quiz_model.dart';
import '../models/quiz_data.dart';

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
          questions: quizData,
          isAnswered: false,
          isCorrect: false,
          showResult: false,
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
      } else {
        state = state.copyWith(showResult: true);
      }
    });
  }

  void resetQuiz() {
    state = state.copyWith(
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
    );
  }
}
