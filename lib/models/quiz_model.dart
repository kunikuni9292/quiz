import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz/models/category_model.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String question,
    required List<String> answers,
    required String correctAnswer,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    required List<Category> categories,
    required String selectedCategoryId,
    required List<QuizQuestion> questions,
    required int currentQuestionIndex,
    required int score,
    required bool isAnswered,
    required bool isCorrect,
    required bool showResult,
    required int timeLimit,
    required double remainingTime,
    required bool isTimeUp,
  }) = _QuizState;

  factory QuizState.fromJson(Map<String, dynamic> json) =>
      _$QuizStateFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String question,
    required List<String> options,
    required String correctAnswer,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
