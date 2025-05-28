// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
  question: json['question'] as String,
  answers: (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
  correctAnswer: json['correctAnswer'] as String,
);

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
      'correctAnswer': instance.correctAnswer,
    };

_$QuizStateImpl _$$QuizStateImplFromJson(Map<String, dynamic> json) =>
    _$QuizStateImpl(
      currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      questions:
          (json['questions'] as List<dynamic>)
              .map((e) => Quiz.fromJson(e as Map<String, dynamic>))
              .toList(),
      isAnswered: json['isAnswered'] as bool? ?? false,
      isCorrect: json['isCorrect'] as bool? ?? false,
      showResult: json['showResult'] as bool? ?? false,
    );

Map<String, dynamic> _$$QuizStateImplToJson(_$QuizStateImpl instance) =>
    <String, dynamic>{
      'currentQuestionIndex': instance.currentQuestionIndex,
      'score': instance.score,
      'questions': instance.questions,
      'isAnswered': instance.isAnswered,
      'isCorrect': instance.isCorrect,
      'showResult': instance.showResult,
    };
