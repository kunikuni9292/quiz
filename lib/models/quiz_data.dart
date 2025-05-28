import 'package:quiz/models/quiz_model.dart';

final List<QuizQuestion> quizData = [
  const QuizQuestion(
    id: '1',
    question: '日本の首都は？',
    options: ['東京', '大阪', '名古屋', '福岡'],
    correctAnswer: '東京',
  ),
  const QuizQuestion(
    id: '2',
    question: '世界で最も大きな大陸は？',
    options: ['アジア', 'アフリカ', '北アメリカ', '南アメリカ'],
    correctAnswer: 'アジア',
  ),
  const QuizQuestion(
    id: '3',
    question: '1+1は？',
    options: ['1', '2', '3', '4'],
    correctAnswer: '2',
  ),
  const QuizQuestion(
    id: '4',
    question: '日本の国花は？',
    options: ['桜', '菊', '梅', '牡丹'],
    correctAnswer: '桜',
  ),
  const QuizQuestion(
    id: '5',
    question: '世界で最も高い山は？',
    options: ['エベレスト', 'K2', 'マッターホルン', '富士山'],
    correctAnswer: 'エベレスト',
  ),
];
