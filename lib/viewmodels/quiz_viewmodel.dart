import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quiz/models/category_model.dart';
import 'package:quiz/models/quiz_model.dart';
import 'package:quiz/data/quiz_data.dart';

part 'quiz_viewmodel.g.dart';

@riverpod
class QuizViewModel extends _$QuizViewModel {
  @override
  QuizState build() {
    return QuizState(
      categories: QuizData.categories,
      selectedCategoryId: '',
      questions: [],
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
      timeLimit: 30,
      remainingTime: 30,
      isTimeUp: false,
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
      remainingTime: state.timeLimit,
      isTimeUp: false,
    );
  }

  void answerQuestion(String answer) {
    if (state.isAnswered) return;

    final currentQuestion = state.questions[state.currentQuestionIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;

    state = state.copyWith(
      isAnswered: true,
      isCorrect: isCorrect,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        isAnswered: false,
        isCorrect: false,
        remainingTime: state.timeLimit,
        isTimeUp: false,
      );
    } else {
      state = state.copyWith(showResult: true);
    }
  }

  void resetQuiz() {
    state = QuizState(
      categories: QuizData.categories,
      selectedCategoryId: '',
      questions: [],
      currentQuestionIndex: 0,
      score: 0,
      isAnswered: false,
      isCorrect: false,
      showResult: false,
      timeLimit: 30,
      remainingTime: 30,
      isTimeUp: false,
    );
  }

  void updateTimer(int remainingTime) {
    state = state.copyWith(
      remainingTime: remainingTime,
      isTimeUp: remainingTime <= 0,
    );
  }
}
