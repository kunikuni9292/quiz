import 'package:flutter/material.dart';

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  bool isCorrect = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '日本の首都はどこですか？',
      'answers': ['大阪', '東京', '名古屋', '福岡'],
      'correctIndex': 1,
    },
    {
      'question': '1 + 1 = ?',
      'answers': ['1', '2', '3', '4'],
      'correctIndex': 1,
    },
    {
      'question': '地球で一番大きな動物は？',
      'answers': ['象', 'キリン', 'シロナガスクジラ', 'ライオン'],
      'correctIndex': 2,
    },
    {
      'question': '虹は何色ありますか？',
      'answers': ['5色', '6色', '7色', '8色'],
      'correctIndex': 2,
    },
    {
      'question': '日本で一番高い山は？',
      'answers': ['富士山', '北岳', '奥穂高岳', '間ノ岳'],
      'correctIndex': 0,
    },
  ];

  void answerQuestion(int selectedIndex) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      isCorrect =
          selectedIndex == questions[currentQuestionIndex]['correctIndex'];
      if (isCorrect) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        isAnswered = false;
        isCorrect = false;
      }
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isAnswered = false;
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズアプリ'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 進捗表示
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 20),

            // 問題番号とスコア
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '問題 ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'スコア: $score',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 問題文
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                currentQuestion['question'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // 選択肢
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion['answers'].length,
                itemBuilder: (context, index) {
                  final answer = currentQuestion['answers'][index];
                  final isCorrectAnswer =
                      index == currentQuestion['correctIndex'];

                  Color? buttonColor;
                  if (isAnswered) {
                    if (isCorrectAnswer) {
                      buttonColor = Colors.green;
                    } else if (!isCorrectAnswer) {
                      buttonColor = Colors.red[100];
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      onPressed: () => answerQuestion(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor ?? Colors.blue[100],
                        foregroundColor: isAnswered && isCorrectAnswer
                            ? Colors.white
                            : Colors.black87,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        answer,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 次へボタンまたは結果
            if (isAnswered) ...[
              const SizedBox(height: 20),
              if (!isLastQuestion)
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    '次の問題へ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              else
                _buildFinalResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final percentage = (score / questions.length * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow[300]!),
      ),
      child: Column(
        children: [
          const Text(
            '🎉 クイズ終了！ 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '正解数: $score / ${questions.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '正答率: $percentage%',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text(
              'もう一度挑戦',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
