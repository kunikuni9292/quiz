import 'package:flutter/material.dart';
import 'dart:async';

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
  bool isQuestionStarted = false;

  // 早押し用の変数
  int currentSegmentIndex = 0;
  Timer? questionTimer;
  int timeRemaining = 0;
  bool canAnswer = false;

  // 文字入力用の変数
  bool isInputMode = false;
  int currentCharIndex = 0;
  int inputTimeRemaining = 0;
  Timer? inputTimer;
  List<String> userInput = [];
  bool inputTimeOut = false;

  final List<Map<String, dynamic>> questions = [
    {
      'segments': ['1603年に江戸幕府を開き、', '関ヶ原の戦いで勝利した', 'この戦国武将は誰でしょう？'],
      'answers': ['織田信長', '徳川家康', '豊臣秀吉', '武田信玄'],
      'correctIndex': 1,
      'fullQuestion': '1603年に江戸幕府を開き、関ヶ原の戦いで勝利したこの戦国武将は誰でしょう？',
      'inputFormat': '徳川◯◯◯◯',
      'targetInput': '家康',
      'charOptions': [
        ['い', 'う', 'み', 'や'], // 1文字目
        ['え', 'あ', 'み', 'な'], // 2文字目
        ['や', 'ゆ', 'み', 'よ'], // 3文字目
        ['す', 'た', 'み', 'ず'], // 4文字目
      ],
      'correctChars': ['い', 'え', 'や', 'す'], // いえやす = 家康
    },
    {
      'segments': ['アインシュタインが提唱した', '質量とエネルギーの等価性を表す', '有名な物理学の公式は何でしょう？'],
      'answers': ['E=mc²', 'F=ma', 'E=hf', 'pV=nRT'],
      'correctIndex': 0,
      'fullQuestion': 'アインシュタインが提唱した質量とエネルギーの等価性を表す有名な物理学の公式は何でしょう？',
      'inputFormat': 'E=◯◯²',
      'targetInput': 'mc',
      'charOptions': [
        ['m', 'n', 'p', 'q'],
        ['c', 'd', 'v', 'x'],
      ],
      'correctChars': ['m', 'c'],
    },
    {
      'segments': ['地球上で最も深い海溝であり、', '太平洋西部に位置する', 'この海溝の名前は何でしょう？'],
      'answers': ['日本海溝', 'マリアナ海溝', 'クリル海溝', 'ペルー・チリ海溝'],
      'correctIndex': 1,
      'fullQuestion': '地球上で最も深い海溝であり、太平洋西部に位置するこの海溝の名前は何でしょう？',
      'inputFormat': 'マリ◯◯海溝',
      'targetInput': 'アナ',
      'charOptions': [
        ['ア', 'イ', 'エ', 'オ'],
        ['ナ', 'マ', 'サ', 'タ'],
      ],
      'correctChars': ['ア', 'ナ'],
    },
    {
      'segments': ['1989年にベルリンの壁が崩壊し、', 'ヨーロッパの冷戦が終結した年に', '日本では何時代が始まったでしょう？'],
      'answers': ['昭和時代', '平成時代', '令和時代', '大正時代'],
      'correctIndex': 1,
      'fullQuestion': '1989年にベルリンの壁が崩壊し、ヨーロッパの冷戦が終結した年に日本では何時代が始まったでしょう？',
      'inputFormat': '◯◯時代',
      'targetInput': '平成',
      'charOptions': [
        ['平', '明', '昭', '令'],
        ['成', '治', '和', '和'],
      ],
      'correctChars': ['平', '成'],
    },
    {
      'segments': ['原子番号6で、', 'ダイヤモンドやグラファイトの主成分であり、', '有機化合物の基本元素は何でしょう？'],
      'answers': ['酸素', '炭素', '窒素', '水素'],
      'correctIndex': 1,
      'fullQuestion': '原子番号6で、ダイヤモンドやグラファイトの主成分であり、有機化合物の基本元素は何でしょう？',
      'inputFormat': '◯◯',
      'targetInput': '炭素',
      'charOptions': [
        ['炭', '酸', '窒', '水'],
        ['素', '化', '分', '合'],
      ],
      'correctChars': ['炭', '素'],
    },
  ];

  void startQuestion() {
    setState(() {
      isQuestionStarted = true;
      currentSegmentIndex = 0;
      timeRemaining = 15; // 15秒でタイムアウト
      canAnswer = true;
      isAnswered = false;
      isInputMode = false;
      userInput.clear();
      currentCharIndex = 0;
      inputTimeOut = false;
    });

    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    questionTimer?.cancel();
    questionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentSegmentIndex <
          questions[currentQuestionIndex]['segments'].length - 1) {
        setState(() {
          currentSegmentIndex++;
        });
      }
    });

    // 全体のタイムアウトタイマー
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0 && canAnswer) {
        setState(() {
          timeRemaining--;
        });
      } else if (timeRemaining == 0 && canAnswer) {
        timer.cancel();
        _timeOut();
      } else {
        timer.cancel();
      }
    });
  }

  void _timeOut() {
    questionTimer?.cancel();
    setState(() {
      canAnswer = false;
      isAnswered = true;
      isCorrect = false;
    });
  }

  void startInputMode() {
    if (!canAnswer || isAnswered) return;

    questionTimer?.cancel();

    setState(() {
      canAnswer = false;
      isInputMode = true;
      currentCharIndex = 0;
      inputTimeRemaining = 3;
      userInput.clear();
    });

    _startInputTimer();
  }

  void _startInputTimer() {
    inputTimer?.cancel();
    inputTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (inputTimeRemaining > 0) {
        setState(() {
          inputTimeRemaining--;
        });
      } else {
        timer.cancel();
        _inputTimeOut();
      }
    });
  }

  void _inputTimeOut() {
    inputTimer?.cancel();
    setState(() {
      inputTimeOut = true;
      isInputMode = false;
      isAnswered = true;
      isCorrect = false;
    });
  }

  void selectCharacter(String char) {
    if (!isInputMode) return;

    inputTimer?.cancel();

    final currentQuestion = questions[currentQuestionIndex];
    final correctChars = currentQuestion['correctChars'] as List<String>;

    setState(() {
      userInput.add(char);
    });

    // 一文字でも間違えたら即座に不正解
    if (char != correctChars[currentCharIndex]) {
      setState(() {
        isInputMode = false;
        isAnswered = true;
        isCorrect = false;
      });
      return;
    }

    setState(() {
      currentCharIndex++;
    });

    if (currentCharIndex >= correctChars.length) {
      // 全て正解で入力完了
      _completeInput();
    } else {
      // 次の文字へ
      setState(() {
        inputTimeRemaining = 3;
      });
      _startInputTimer();
    }
  }

  void _completeInput() {
    inputTimer?.cancel();

    final currentQuestion = questions[currentQuestionIndex];
    final correctChars = currentQuestion['correctChars'] as List<String>;

    bool allCorrect = true;
    for (int i = 0; i < correctChars.length; i++) {
      if (i >= userInput.length || userInput[i] != correctChars[i]) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      isInputMode = false;
      isAnswered = true;
      isCorrect = allCorrect;

      if (isCorrect) {
        // 早押しボーナス + 入力ボーナス
        int segmentBonus = (3 - currentSegmentIndex) * 2;
        int inputBonus = 3; // 入力成功ボーナス
        int totalPoints = segmentBonus + inputBonus;
        score += totalPoints.clamp(1, 10);
      }
    });
  }

  void nextQuestion() {
    questionTimer?.cancel();
    inputTimer?.cancel();
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        isQuestionStarted = false;
        currentSegmentIndex = 0;
        isAnswered = false;
        isCorrect = false;
        canAnswer = false;
        isInputMode = false;
        userInput.clear();
        currentCharIndex = 0;
        inputTimeOut = false;
      }
    });
  }

  void resetQuiz() {
    questionTimer?.cancel();
    inputTimer?.cancel();
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isAnswered = false;
      isCorrect = false;
      isQuestionStarted = false;
      currentSegmentIndex = 0;
      canAnswer = false;
      isInputMode = false;
      userInput.clear();
      currentCharIndex = 0;
      inputTimeOut = false;
    });
  }

  String _getCurrentQuestionText() {
    final segments =
        questions[currentQuestionIndex]['segments'] as List<String>;
    return segments.take(currentSegmentIndex + 1).join(' ');
  }

  String _getInputDisplay() {
    final currentQuestion = questions[currentQuestionIndex];
    final inputFormat = currentQuestion['inputFormat'] as String;
    final correctChars = currentQuestion['correctChars'] as List<String>;

    String display = inputFormat;
    for (int i = 0; i < correctChars.length; i++) {
      if (i < userInput.length) {
        display = display.replaceFirst('◯', userInput[i]);
      }
    }
    return display;
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    inputTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('早押し文字入力クイズ'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        toolbarHeight: 50, // AppBarの高さを縮小
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // パディングを縮小
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 進捗表示
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              const SizedBox(height: 8), // スペースを縮小

              // 問題番号とスコア
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '問題 ${currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold), // フォントサイズを縮小
                  ),
                  Text(
                    'スコア: $score',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold), // フォントサイズを縮小
                  ),
                ],
              ),
              const SizedBox(height: 8), // スペースを縮小

              // タイマー表示
              if (isQuestionStarted && canAnswer)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8), // パディングを縮小
                  decoration: BoxDecoration(
                    color:
                        timeRemaining <= 5 ? Colors.red[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        color: timeRemaining <= 5 ? Colors.red : Colors.blue,
                        size: 16, // アイコンサイズを縮小
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '残り時間: ${timeRemaining}秒',
                        style: TextStyle(
                          fontSize: 14, // フォントサイズを縮小
                          fontWeight: FontWeight.bold,
                          color: timeRemaining <= 5 ? Colors.red : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

              // 入力モードのタイマー表示
              if (isInputMode)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: inputTimeRemaining <= 1
                        ? Colors.red[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.keyboard,
                        color: inputTimeRemaining <= 1
                            ? Colors.red
                            : Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '文字選択: ${inputTimeRemaining}秒',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: inputTimeRemaining <= 1
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),

              // 問題文 - Expandedで高さを調整
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12), // パディングを縮小
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isQuestionStarted)
                        const Text(
                          '準備はいいですか？\n「問題開始」を押してください',
                          style: TextStyle(
                            fontSize: 16, // フォントサイズを縮小
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        Text(
                          _getCurrentQuestionText(),
                          style: const TextStyle(
                            fontSize: 16, // フォントサイズを縮小
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (isAnswered &&
                          MediaQuery.of(context).size.height >
                              600) // 画面が大きい場合のみ表示
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '正解: ${currentQuestion['answers'][currentQuestion['correctIndex']]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 入力表示エリア
              if (isInputMode || isAnswered && userInput.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow[300]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '形式: ${currentQuestion['inputFormat']}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getInputDisplay(),
                        style: const TextStyle(
                          fontSize: 20, // やや縮小
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isInputMode)
                        Text(
                          '${currentCharIndex + 1}文字目を選択',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.orange),
                        ),
                    ],
                  ),
                ),

              // 問題開始ボタンまたは解答ボタン
              if (!isQuestionStarted)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: startQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12), // パディングを縮小
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '🚀 問題開始！',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold), // フォントサイズを縮小
                    ),
                  ),
                )
              else if (canAnswer)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: startInputMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '⚡ 解答！',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              // 文字選択ボタン - Expandedで残りのスペースを活用
              if (isInputMode)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${currentCharIndex + 1}文字目を選択',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            childAspectRatio: 3.0, // ボタンの比率を調整
                            children: (currentQuestion['charOptions']
                                    [currentCharIndex] as List<String>)
                                .map((char) => ElevatedButton(
                                      onPressed: () => selectCharacter(char),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text(
                                        char,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 結果表示
              if (isAnswered) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrect ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isCorrect
                            ? '🎉 正解！'
                            : inputTimeOut
                                ? '⏰ タイムアウト'
                                : '❌ 不正解',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      if (isCorrect) ...[
                        Text(
                          '段階: ${currentSegmentIndex + 1} | 入力: ${userInput.join('')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ] else if (userInput.isNotEmpty) ...[
                        Text(
                          '入力: ${userInput.join('')} | 正解: ${currentQuestion['correctChars'].join('')}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (!isLastQuestion)
                  ElevatedButton(
                    onPressed: nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      '次の問題へ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  _buildFinalResult(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final maxPossibleScore = questions.length * 10;
    final percentage = (score / maxPossibleScore * 100).round();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.yellow[300]!),
      ),
      child: Column(
        children: [
          const Text(
            '🏆 クイズ終了！',
            style: TextStyle(
              fontSize: 18, // フォントサイズを縮小
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '総得点: $score / $maxPossibleScore点 ($percentage%)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _getGradeMessage(percentage),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: resetQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text(
              'もう一度挑戦',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _getGradeMessage(int percentage) {
    if (percentage >= 80) return '🥇 クイズ王級！';
    if (percentage >= 60) return '🥈 上級者！';
    if (percentage >= 40) return '🥉 中級者！';
    return '📚 初心者！';
  }
}
