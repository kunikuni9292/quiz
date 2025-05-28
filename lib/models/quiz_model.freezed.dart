// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return _Quiz.fromJson(json);
}

/// @nodoc
mixin _$Quiz {
  String get question => throw _privateConstructorUsedError;
  List<String> get answers => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCopyWith<Quiz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCopyWith<$Res> {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) then) =
      _$QuizCopyWithImpl<$Res, Quiz>;
  @useResult
  $Res call({String question, List<String> answers, String correctAnswer});
}

/// @nodoc
class _$QuizCopyWithImpl<$Res, $Val extends Quiz>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answers = null,
    Object? correctAnswer = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizImplCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$$QuizImplCopyWith(
          _$QuizImpl value, $Res Function(_$QuizImpl) then) =
      __$$QuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String question, List<String> answers, String correctAnswer});
}

/// @nodoc
class __$$QuizImplCopyWithImpl<$Res>
    extends _$QuizCopyWithImpl<$Res, _$QuizImpl>
    implements _$$QuizImplCopyWith<$Res> {
  __$$QuizImplCopyWithImpl(_$QuizImpl _value, $Res Function(_$QuizImpl) _then)
      : super(_value, _then);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? answers = null,
    Object? correctAnswer = null,
  }) {
    return _then(_$QuizImpl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizImpl implements _Quiz {
  const _$QuizImpl(
      {required this.question,
      required final List<String> answers,
      required this.correctAnswer})
      : _answers = answers;

  factory _$QuizImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizImplFromJson(json);

  @override
  final String question;
  final List<String> _answers;
  @override
  List<String> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  final String correctAnswer;

  @override
  String toString() {
    return 'Quiz(question: $question, answers: $answers, correctAnswer: $correctAnswer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, question,
      const DeepCollectionEquality().hash(_answers), correctAnswer);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      __$$QuizImplCopyWithImpl<_$QuizImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizImplToJson(
      this,
    );
  }
}

abstract class _Quiz implements Quiz {
  const factory _Quiz(
      {required final String question,
      required final List<String> answers,
      required final String correctAnswer}) = _$QuizImpl;

  factory _Quiz.fromJson(Map<String, dynamic> json) = _$QuizImpl.fromJson;

  @override
  String get question;
  @override
  List<String> get answers;
  @override
  String get correctAnswer;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizState _$QuizStateFromJson(Map<String, dynamic> json) {
  return _QuizState.fromJson(json);
}

/// @nodoc
mixin _$QuizState {
  List<Category> get categories => throw _privateConstructorUsedError;
  String get selectedCategoryId => throw _privateConstructorUsedError;
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  bool get isAnswered => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  bool get showResult => throw _privateConstructorUsedError;
  int get timeLimit => throw _privateConstructorUsedError;
  double get remainingTime => throw _privateConstructorUsedError;
  bool get isTimeUp => throw _privateConstructorUsedError;

  /// Serializes this QuizState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStateCopyWith<QuizState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStateCopyWith<$Res> {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) then) =
      _$QuizStateCopyWithImpl<$Res, QuizState>;
  @useResult
  $Res call(
      {List<Category> categories,
      String selectedCategoryId,
      List<QuizQuestion> questions,
      int currentQuestionIndex,
      int score,
      bool isAnswered,
      bool isCorrect,
      bool showResult,
      int timeLimit,
      double remainingTime,
      bool isTimeUp});
}

/// @nodoc
class _$QuizStateCopyWithImpl<$Res, $Val extends QuizState>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategoryId = null,
    Object? questions = null,
    Object? currentQuestionIndex = null,
    Object? score = null,
    Object? isAnswered = null,
    Object? isCorrect = null,
    Object? showResult = null,
    Object? timeLimit = null,
    Object? remainingTime = null,
    Object? isTimeUp = null,
  }) {
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryId: null == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      showResult: null == showResult
          ? _value.showResult
          : showResult // ignore: cast_nullable_to_non_nullable
              as bool,
      timeLimit: null == timeLimit
          ? _value.timeLimit
          : timeLimit // ignore: cast_nullable_to_non_nullable
              as int,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as double,
      isTimeUp: null == isTimeUp
          ? _value.isTimeUp
          : isTimeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizStateImplCopyWith<$Res>
    implements $QuizStateCopyWith<$Res> {
  factory _$$QuizStateImplCopyWith(
          _$QuizStateImpl value, $Res Function(_$QuizStateImpl) then) =
      __$$QuizStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Category> categories,
      String selectedCategoryId,
      List<QuizQuestion> questions,
      int currentQuestionIndex,
      int score,
      bool isAnswered,
      bool isCorrect,
      bool showResult,
      int timeLimit,
      double remainingTime,
      bool isTimeUp});
}

/// @nodoc
class __$$QuizStateImplCopyWithImpl<$Res>
    extends _$QuizStateCopyWithImpl<$Res, _$QuizStateImpl>
    implements _$$QuizStateImplCopyWith<$Res> {
  __$$QuizStateImplCopyWithImpl(
      _$QuizStateImpl _value, $Res Function(_$QuizStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategoryId = null,
    Object? questions = null,
    Object? currentQuestionIndex = null,
    Object? score = null,
    Object? isAnswered = null,
    Object? isCorrect = null,
    Object? showResult = null,
    Object? timeLimit = null,
    Object? remainingTime = null,
    Object? isTimeUp = null,
  }) {
    return _then(_$QuizStateImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryId: null == selectedCategoryId
          ? _value.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      showResult: null == showResult
          ? _value.showResult
          : showResult // ignore: cast_nullable_to_non_nullable
              as bool,
      timeLimit: null == timeLimit
          ? _value.timeLimit
          : timeLimit // ignore: cast_nullable_to_non_nullable
              as int,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as double,
      isTimeUp: null == isTimeUp
          ? _value.isTimeUp
          : isTimeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizStateImpl implements _QuizState {
  const _$QuizStateImpl(
      {required final List<Category> categories,
      required this.selectedCategoryId,
      required final List<QuizQuestion> questions,
      required this.currentQuestionIndex,
      required this.score,
      required this.isAnswered,
      required this.isCorrect,
      required this.showResult,
      required this.timeLimit,
      required this.remainingTime,
      required this.isTimeUp})
      : _categories = categories,
        _questions = questions;

  factory _$QuizStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizStateImplFromJson(json);

  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String selectedCategoryId;
  final List<QuizQuestion> _questions;
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final int currentQuestionIndex;
  @override
  final int score;
  @override
  final bool isAnswered;
  @override
  final bool isCorrect;
  @override
  final bool showResult;
  @override
  final int timeLimit;
  @override
  final double remainingTime;
  @override
  final bool isTimeUp;

  @override
  String toString() {
    return 'QuizState(categories: $categories, selectedCategoryId: $selectedCategoryId, questions: $questions, currentQuestionIndex: $currentQuestionIndex, score: $score, isAnswered: $isAnswered, isCorrect: $isCorrect, showResult: $showResult, timeLimit: $timeLimit, remainingTime: $remainingTime, isTimeUp: $isTimeUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.isAnswered, isAnswered) ||
                other.isAnswered == isAnswered) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.showResult, showResult) ||
                other.showResult == showResult) &&
            (identical(other.timeLimit, timeLimit) ||
                other.timeLimit == timeLimit) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.isTimeUp, isTimeUp) ||
                other.isTimeUp == isTimeUp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      selectedCategoryId,
      const DeepCollectionEquality().hash(_questions),
      currentQuestionIndex,
      score,
      isAnswered,
      isCorrect,
      showResult,
      timeLimit,
      remainingTime,
      isTimeUp);

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      __$$QuizStateImplCopyWithImpl<_$QuizStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizStateImplToJson(
      this,
    );
  }
}

abstract class _QuizState implements QuizState {
  const factory _QuizState(
      {required final List<Category> categories,
      required final String selectedCategoryId,
      required final List<QuizQuestion> questions,
      required final int currentQuestionIndex,
      required final int score,
      required final bool isAnswered,
      required final bool isCorrect,
      required final bool showResult,
      required final int timeLimit,
      required final double remainingTime,
      required final bool isTimeUp}) = _$QuizStateImpl;

  factory _QuizState.fromJson(Map<String, dynamic> json) =
      _$QuizStateImpl.fromJson;

  @override
  List<Category> get categories;
  @override
  String get selectedCategoryId;
  @override
  List<QuizQuestion> get questions;
  @override
  int get currentQuestionIndex;
  @override
  int get score;
  @override
  bool get isAnswered;
  @override
  bool get isCorrect;
  @override
  bool get showResult;
  @override
  int get timeLimit;
  @override
  double get remainingTime;
  @override
  bool get isTimeUp;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
          QuizQuestion value, $Res Function(QuizQuestion) then) =
      _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call(
      {String id, String question, List<String> options, String correctAnswer});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
          _$QuizQuestionImpl value, $Res Function(_$QuizQuestionImpl) then) =
      __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String question, List<String> options, String correctAnswer});
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
      _$QuizQuestionImpl _value, $Res Function(_$QuizQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
  }) {
    return _then(_$QuizQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl(
      {required this.id,
      required this.question,
      required final List<String> options,
      required this.correctAnswer})
      : _options = options;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String question;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final String correctAnswer;

  @override
  String toString() {
    return 'QuizQuestion(id: $id, question: $question, options: $options, correctAnswer: $correctAnswer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, question,
      const DeepCollectionEquality().hash(_options), correctAnswer);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(
      this,
    );
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion(
      {required final String id,
      required final String question,
      required final List<String> options,
      required final String correctAnswer}) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get question;
  @override
  List<String> get options;
  @override
  String get correctAnswer;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
