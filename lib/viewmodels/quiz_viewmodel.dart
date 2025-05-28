import 'dart:async';
import 'package:quiz/models/quiz_model.dart';
import 'package:quiz/data/quiz_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizViewModelProvider =
    StateNotifierProvider<QuizViewModel, QuizState>((ref) {
  return QuizViewModel();
});

class QuizViewModel extends StateNotifier<QuizState> {
  Timer? _timer;

  QuizViewModel()
      : super(
          QuizState(
            currentQuestionIndex: 0,
            score: 0,
            questions: QuizData.getQuestionsByCategory('general'),
            isAnswered: false,
            isCorrect: false,
            showResult: false,
            timeLimit: 10,
            remainingTime: 10.0,
            isTimeUp: false,
            categories: QuizData.categories,
            selectedCategoryId: '',
          ),
        );

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

  // タイマーを開始するメソッド
  void startTimer() {
    _startTimer();
  }

  // タイマーを停止するメソッド
  void stopTimer() {
    _timer?.cancel();
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
          remainingTime: state.timeLimit.toDouble(),
        );
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

    // 1秒後に次の問題へ自動で移動
    Future.delayed(const Duration(seconds: 1), () {
      if (state.currentQuestionIndex < state.questions.length - 1) {
        state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
          isAnswered: false,
          isCorrect: false,
          isTimeUp: false,
          remainingTime: state.timeLimit.toDouble(),
        );
      } else {
        state = state.copyWith(
          showResult: true,
          isAnswered: false,
          isCorrect: false,
        );
      }
    });
  }

  void resetQuiz() {
    _timer?.cancel();
    state = QuizState(
      currentQuestionIndex: 0,
      score: 0,
      questions: state.questions,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
      timeLimit: 10,
      remainingTime: 10.0,
      isTimeUp: false,
      categories: state.categories,
      selectedCategoryId: state.selectedCategoryId,
    );
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      questions: QuizData.getQuestionsByCategory(categoryId),
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
      remainingTime: state.timeLimit.toDouble(),
      isTimeUp: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
