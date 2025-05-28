import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'views/quiz_view.dart';

void main() {
  runApp(const ProviderScope(child: QuizApp()));
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'クイズアプリv3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const QuizView(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '日本の首都は？',
      'answers': ['東京', '大阪', '名古屋', '福岡'],
      'correctAnswer': '東京',
    },
    {
      'question': '世界で最も大きな大陸は？',
      'answers': ['アジア', 'アフリカ', '北アメリカ', '南アメリカ'],
      'correctAnswer': 'アジア',
    },
    // ここに問題を追加できます
  ];

  void _answerQuestion(String selectedAnswer) {
    setState(() {
      if (selectedAnswer ==
          _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズアプリ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          _currentQuestionIndex < _questions.length
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...(_questions[_currentQuestionIndex]['answers']
                            as List<String>)
                        .map(
                          (answer) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed: () => _answerQuestion(answer),
                              child: Text(answer),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'クイズ終了！\nスコア: $_score/${_questions.length}',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetQuiz,
                      child: const Text('もう一度挑戦'),
                    ),
                  ],
                ),
              ),
    );
  }
}
