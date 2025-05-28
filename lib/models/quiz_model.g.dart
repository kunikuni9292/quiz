// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
      question: json['question'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
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
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCategoryId: json['selectedCategoryId'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      isAnswered: json['isAnswered'] as bool,
      isCorrect: json['isCorrect'] as bool,
      showResult: json['showResult'] as bool,
      timeLimit: (json['timeLimit'] as num).toInt(),
      remainingTime: (json['remainingTime'] as num).toDouble(),
      isTimeUp: json['isTimeUp'] as bool,
    );

Map<String, dynamic> _$$QuizStateImplToJson(_$QuizStateImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'selectedCategoryId': instance.selectedCategoryId,
      'questions': instance.questions,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'score': instance.score,
      'isAnswered': instance.isAnswered,
      'isCorrect': instance.isCorrect,
      'showResult': instance.showResult,
      'timeLimit': instance.timeLimit,
      'remainingTime': instance.remainingTime,
      'isTimeUp': instance.isTimeUp,
    };

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswer: json['correctAnswer'] as String,
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
    };
