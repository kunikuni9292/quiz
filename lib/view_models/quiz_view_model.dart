import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/quiz_model.dart';
import '../models/quiz_data.dart';

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizState>((
  ref,
) {
  return QuizViewModel();
});

class QuizViewModel extends StateNotifier<QuizState> {
  Timer? _timer;

  QuizViewModel()
      : super(
          QuizState(
            currentQuestionIndex: 0,
            score: 0,
            questions: quizData,
            isAnswered: false,
            isCorrect: false,
            showResult: false,
            timeLimit: 10,
            remainingTime: 10,
            isTimeUp: false,
            categories: [],
            selectedCategoryId: '',
          ),
        ) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(
        remainingTime: state.timeLimit.toDouble(), isTimeUp: false);

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(
            remainingTime: (state.remainingTime - 0.01)
                .clamp(0.0, state.timeLimit.toDouble()));
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    state = state.copyWith(isTimeUp: true, isAnswered: true);

    Future.delayed(const Duration(seconds: 1), () {
      if (state.currentQuestionIndex < state.questions.length - 1) {
        state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          isAnswered: false,
          isCorrect: false,
          isTimeUp: false,
        );
        _startTimer();
      } else {
        state = state.copyWith(showResult: true);
      }
    });
  }

  void answerQuestion(String selectedAnswer) {
    if (state.isAnswered) return;

    _timer?.cancel();
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
          isTimeUp: false,
        );
        _startTimer();
      } else {
        state = state.copyWith(showResult: true);
      }
    });
  }

  void resetQuiz() {
    _timer?.cancel();
    state = state.copyWith(
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
      isTimeUp: false,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
