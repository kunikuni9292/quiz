import 'package:freezed_annotation/freezed_annotation.dart';

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
    required int currentQuestionIndex,
    required int score,
    required List<Quiz> questions,
    @Default(false) bool isAnswered,
    @Default(false) bool isCorrect,
    @Default(false) bool showResult,
  }) = _QuizState;

  factory QuizState.fromJson(Map<String, dynamic> json) =>
      _$QuizStateFromJson(json);
}
