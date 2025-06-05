import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

enum QuizCategory {
  general('一般常識', Colors.blue, Icons.lightbulb),
  science('科学', Colors.green, Icons.science),
  history('歴史', Colors.orange, Icons.castle),
  okinawa('沖縄クイズ', Colors.purple, Icons.beach_access);

  const QuizCategory(this.displayName, this.color, this.icon);
  final String displayName;
  final Color color;
  final IconData icon;
}

class Enemy {
  final String name;
  final String emoji;
  final int maxHp;
  int currentHp;
  final QuizCategory category;

  Enemy({
    required this.name,
    required this.emoji,
    required this.maxHp,
    required this.category,
  }) : currentHp = maxHp;

  double get hpPercentage => currentHp / maxHp;
  bool get isDefeated => currentHp <= 0;

  void takeDamage(int damage) {
    currentHp = (currentHp - damage).clamp(0, maxHp);
  }

  void heal() {
    currentHp = maxHp;
  }
}

class ConfettiParticle {
  double x;
  double y;
  double velocityX;
  double velocityY;
  double rotation;
  double rotationSpeed;
  Color color;
  double size;
  double gravity;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
    required this.gravity,
  });

  void update() {
    x += velocityX;
    y += velocityY;
    velocityY += gravity;
    rotation += rotationSpeed;
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> with TickerProviderStateMixin {
  QuizCategory? selectedCategory;
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

  // バトル用の変数
  Enemy? currentEnemy;
  bool isAttacking = false;
  int lastDamage = 0;
  late AnimationController _attackController;
  late AnimationController _shakeController;
  late Animation<double> _attackAnimation;
  late Animation<double> _shakeAnimation;

  // 紙吹雪用の変数
  late AnimationController _confettiController;
  List<ConfettiParticle> confettiParticles = [];
  bool isConfettiActive = false;
  Timer? confettiTimer;

  final Map<QuizCategory, Enemy> enemies = {
    QuizCategory.general: Enemy(
      name: '知識の番人',
      emoji: '📚',
      maxHp: 100,
      category: QuizCategory.general,
    ),
    QuizCategory.science: Enemy(
      name: '実験マシン',
      emoji: '🧪',
      maxHp: 120,
      category: QuizCategory.science,
    ),
    QuizCategory.history: Enemy(
      name: '時の武将',
      emoji: '⚔️',
      maxHp: 150,
      category: QuizCategory.history,
    ),
    QuizCategory.okinawa: Enemy(
      name: 'シーサー',
      emoji: '🦁',
      maxHp: 90,
      category: QuizCategory.okinawa,
    ),
  };

  final Map<QuizCategory, List<Map<String, dynamic>>> questionsByCategory = {
    QuizCategory.general: [
      {
        'segments': ['日本の首都であり、', '人口約1400万人を擁する', 'この都市の名前は？'],
        'answers': ['大阪', '東京', '名古屋', '福岡'],
        'correctIndex': 1,
        'fullQuestion': '日本の首都であり、人口約1400万人を擁するこの都市の名前は？',
        'inputFormat': '◯◯',
        'targetInput': '東京',
        'charOptions': [
          ['東', '西', '南', '北'],
          ['京', '阪', '海', '都'],
        ],
        'correctChars': ['東', '京'],
      },
      {
        'segments': ['国際連合の本部があり、', '自由の女神像で有名な', 'アメリカのこの都市は？'],
        'answers': ['ロサンゼルス', 'ニューヨーク', 'シカゴ', 'ワシントン'],
        'correctIndex': 1,
        'fullQuestion': '国際連合の本部があり、自由の女神像で有名なアメリカのこの都市は？',
        'inputFormat': 'ニュー◯◯◯',
        'targetInput': 'ヨーク',
        'charOptions': [
          ['ヨ', 'ハ', 'マ', 'サ'],
          ['ー', 'ッ', 'ン', 'イ'],
          ['ク', 'グ', 'ス', 'ト'],
        ],
        'correctChars': ['ヨ', 'ー', 'ク'],
      },
      {
        'segments': ['富士山の高さは', '海抜3776メートルで', 'これは何合目でしょう？'],
        'answers': ['8合目', '9合目', '10合目', '頂上'],
        'correctIndex': 3,
        'fullQuestion': '富士山の高さは海抜3776メートルでこれは何合目でしょう？',
        'inputFormat': '◯◯',
        'targetInput': '頂上',
        'charOptions': [
          ['頂', '中', '下', '登'],
          ['上', '腹', '段', '部'],
        ],
        'correctChars': ['頂', '上'],
      },
      {
        'segments': ['フランスの首都で', 'エッフェル塔で有名な', 'この都市の名前は？'],
        'answers': ['ロンドン', 'パリ', 'ローマ', 'ベルリン'],
        'correctIndex': 1,
        'fullQuestion': 'フランスの首都でエッフェル塔で有名なこの都市の名前は？',
        'inputFormat': '◯◯',
        'targetInput': 'パリ',
        'charOptions': [
          ['パ', 'ロ', 'ベ', 'マ'],
          ['リ', 'ン', 'ル', 'ド'],
        ],
        'correctChars': ['パ', 'リ'],
      },
      {
        'segments': ['日本で一番大きな湖で', '滋賀県にある', 'この湖の名前は？'],
        'answers': ['霞ヶ浦', '琵琶湖', '浜名湖', '猪苗代湖'],
        'correctIndex': 1,
        'fullQuestion': '日本で一番大きな湖で滋賀県にあるこの湖の名前は？',
        'inputFormat': '◯◯湖',
        'targetInput': '琵琶',
        'charOptions': [
          ['琵', '霞', '浜', '猪'],
          ['琶', 'ヶ', '名', '苗'],
        ],
        'correctChars': ['琵', '琶'],
      },
      {
        'segments': ['12か月の中で', '一番日数が少ない', 'この月は何月？'],
        'answers': ['1月', '2月', '11月', '12月'],
        'correctIndex': 1,
        'fullQuestion': '12か月の中で一番日数が少ないこの月は何月？',
        'inputFormat': '◯月',
        'targetInput': '2',
        'charOptions': [
          ['1', '2', '11', '12'],
        ],
        'correctChars': ['2'],
      },
      {
        'segments': ['日本の国花として親しまれ', '春に美しく咲く', 'この花の名前は？'],
        'answers': ['梅', '桜', '菊', '藤'],
        'correctIndex': 1,
        'fullQuestion': '日本の国花として親しまれ春に美しく咲くこの花の名前は？',
        'inputFormat': '◯',
        'targetInput': '桜',
        'charOptions': [
          ['梅', '桜', '菊', '藤'],
        ],
        'correctChars': ['桜'],
      },
      {
        'segments': ['世界で一番高い山で', 'ネパールとチベットの境にある', 'この山の名前は？'],
        'answers': ['K2', 'エベレスト', '富士山', 'キリマンジャロ'],
        'correctIndex': 1,
        'fullQuestion': '世界で一番高い山でネパールとチベットの境にあるこの山の名前は？',
        'inputFormat': 'エベ◯◯◯',
        'targetInput': 'レスト',
        'charOptions': [
          ['レ', 'ー', 'リ', 'ラ'],
          ['ス', 'ン', 'シ', 'サ'],
          ['ト', 'グ', 'ク', 'プ'],
        ],
        'correctChars': ['レ', 'ス', 'ト'],
      },
      {
        'segments': ['日本の通貨単位で', '硬貨や紙幣に使われる', 'この単位は何？'],
        'answers': ['ドル', '円', 'ユーロ', 'ウォン'],
        'correctIndex': 1,
        'fullQuestion': '日本の通貨単位で硬貨や紙幣に使われるこの単位は何？',
        'inputFormat': '◯',
        'targetInput': '円',
        'charOptions': [
          ['ド', '円', 'ユ', 'ウ'],
        ],
        'correctChars': ['円'],
      },
      {
        'segments': ['一週間は全部で', '7日間ありますが', '一年は何日間？'],
        'answers': ['364日', '365日', '366日', '367日'],
        'correctIndex': 1,
        'fullQuestion': '一週間は全部で7日間ありますが一年は何日間？',
        'inputFormat': '◯◯◯日',
        'targetInput': '365',
        'charOptions': [
          ['3', '2', '4', '1'],
          ['6', '5', '7', '8'],
          ['5', '4', '6', '7'],
        ],
        'correctChars': ['3', '6', '5'],
      },
    ],
    QuizCategory.science: [
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
        'segments': ['DNAの二重らせん構造を', '発見したイギリスの科学者', 'この人物の名前は？'],
        'answers': ['ダーウィン', 'ワトソン', 'ニュートン', 'ホーキング'],
        'correctIndex': 1,
        'fullQuestion': 'DNAの二重らせん構造を発見したイギリスの科学者この人物の名前は？',
        'inputFormat': 'ワト◯◯',
        'targetInput': 'ソン',
        'charOptions': [
          ['ソ', 'ダ', 'ニ', 'ホ'],
          ['ン', 'ー', 'ュ', 'ー'],
        ],
        'correctChars': ['ソ', 'ン'],
      },
      {
        'segments': ['水の化学式は', 'H2Oですが', '酸素の化学式は何？'],
        'answers': ['O', 'O2', 'H2O2', 'CO2'],
        'correctIndex': 1,
        'fullQuestion': '水の化学式はH2Oですが酸素の化学式は何？',
        'inputFormat': 'O◯',
        'targetInput': '2',
        'charOptions': [
          ['2', '3', '4', '1'],
        ],
        'correctChars': ['2'],
      },
      {
        'segments': ['光の速度は秒速約', '30万キロメートルですが', 'これを科学記号で表すと？'],
        'answers': ['1×10⁸ m/s', '3×10⁸ m/s', '9×10⁸ m/s', '6×10⁸ m/s'],
        'correctIndex': 1,
        'fullQuestion': '光の速度は秒速約30万キロメートルですがこれを科学記号で表すと？',
        'inputFormat': '◯×10⁸ m/s',
        'targetInput': '3',
        'charOptions': [
          ['1', '3', '9', '6'],
        ],
        'correctChars': ['3'],
      },
      {
        'segments': ['人間の体で最も硬い', '部分といえば', 'どこの部位？'],
        'answers': ['骨', '歯', '爪', '毛'],
        'correctIndex': 1,
        'fullQuestion': '人間の体で最も硬い部分といえばどこの部位？',
        'inputFormat': '◯',
        'targetInput': '歯',
        'charOptions': [
          ['骨', '歯', '爪', '毛'],
        ],
        'correctChars': ['歯'],
      },
      {
        'segments': ['重力を発見した', 'イギリスの物理学者', 'この人物の名前は？'],
        'answers': ['ガリレイ', 'ニュートン', 'アインシュタイン', 'ダーウィン'],
        'correctIndex': 1,
        'fullQuestion': '重力を発見したイギリスの物理学者この人物の名前は？',
        'inputFormat': 'ニュー◯◯',
        'targetInput': 'トン',
        'charOptions': [
          ['ト', 'ガ', 'ア', 'ダ'],
          ['ン', 'リ', 'イ', 'ー'],
        ],
        'correctChars': ['ト', 'ン'],
      },
      {
        'segments': ['地球から太陽までの', '距離の単位として使われる', 'この単位の名前は？'],
        'answers': ['光年', '天文単位', 'パーセク', 'キロメートル'],
        'correctIndex': 1,
        'fullQuestion': '地球から太陽までの距離の単位として使われるこの単位の名前は？',
        'inputFormat': '天文◯◯',
        'targetInput': '単位',
        'charOptions': [
          ['単', '光', 'パ', 'キ'],
          ['位', '年', 'ー', 'ロ'],
        ],
        'correctChars': ['単', '位'],
      },
      {
        'segments': ['血液の赤い色の', '原因となる成分', 'この物質の名前は？'],
        'answers': ['ヘモグロビン', 'アドレナリン', 'インスリン', 'ドーパミン'],
        'correctIndex': 0,
        'fullQuestion': '血液の赤い色の原因となる成分この物質の名前は？',
        'inputFormat': 'ヘモ◯◯◯◯',
        'targetInput': 'グロビン',
        'charOptions': [
          ['グ', 'ア', 'イ', 'ド'],
          ['ロ', 'ド', 'ン', 'ー'],
          ['ビ', 'レ', 'ス', 'パ'],
          ['ン', 'ナ', 'リ', 'ミ'],
        ],
        'correctChars': ['グ', 'ロ', 'ビ', 'ン'],
      },
    ],
    QuizCategory.history: [
      {
        'segments': ['1603年に江戸幕府を開き、', '関ヶ原の戦いで勝利した', 'この戦国武将は誰でしょう？'],
        'answers': ['織田信長', '徳川家康', '豊臣秀吉', '武田信玄'],
        'correctIndex': 1,
        'fullQuestion': '1603年に江戸幕府を開き、関ヶ原の戦いで勝利したこの戦国武将は誰でしょう？',
        'inputFormat': '徳川◯◯◯◯',
        'targetInput': '家康',
        'charOptions': [
          ['い', 'う', 'み', 'や'],
          ['え', 'あ', 'み', 'な'],
          ['や', 'ゆ', 'み', 'よ'],
          ['す', 'た', 'み', 'ず'],
        ],
        'correctChars': ['い', 'え', 'や', 'す'],
      },
      {
        'segments': [
          '1989年にベルリンの壁が崩壊し、',
          'ヨーロッパの冷戦が終結した年に',
          '日本では何時代が始まったでしょう？'
        ],
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
        'segments': ['1192年に鎌倉幕府を開いた', '源氏の棟梁で', 'この人物の名前は？'],
        'answers': ['源義経', '源頼朝', '源義仲', '源為朝'],
        'correctIndex': 1,
        'fullQuestion': '1192年に鎌倉幕府を開いた源氏の棟梁でこの人物の名前は？',
        'inputFormat': '源◯◯◯',
        'targetInput': '頼朝',
        'charOptions': [
          ['よ', 'い', 'う', 'お'],
          ['り', 'し', 'ち', 'き'],
          ['と', 'も', 'の', 'こ'],
        ],
        'correctChars': ['よ', 'り', 'と'],
      },
      {
        'segments': ['天下統一を目指し', '本能寺の変で亡くなった', 'この戦国武将は誰？'],
        'answers': ['織田信長', '豊臣秀吉', '徳川家康', '武田信玄'],
        'correctIndex': 0,
        'fullQuestion': '天下統一を目指し本能寺の変で亡くなったこの戦国武将は誰？',
        'inputFormat': '織田◯◯',
        'targetInput': '信長',
        'charOptions': [
          ['信', '秀', '家', '信'],
          ['長', '吉', '康', '玄'],
        ],
        'correctChars': ['信', '長'],
      },
      {
        'segments': ['1868年に起こった', '江戸時代から明治時代への', '政治的変革を何と呼ぶ？'],
        'answers': ['大政奉還', '明治維新', '戊辰戦争', '廃藩置県'],
        'correctIndex': 1,
        'fullQuestion': '1868年に起こった江戸時代から明治時代への政治的変革を何と呼ぶ？',
        'inputFormat': '明治◯◯',
        'targetInput': '維新',
        'charOptions': [
          ['維', '大', '戊', '廃'],
          ['新', '政', '辰', '藩'],
        ],
        'correctChars': ['維', '新'],
      },
      {
        'segments': ['1945年8月15日に', '昭和天皇が終戦を告げた', 'この放送を何と呼ぶ？'],
        'answers': ['玉音放送', '終戦勅語', '降伏宣言', '終戦詔書'],
        'correctIndex': 0,
        'fullQuestion': '1945年8月15日に昭和天皇が終戦を告げたこの放送を何と呼ぶ？',
        'inputFormat': '◯◯放送',
        'targetInput': '玉音',
        'charOptions': [
          ['玉', '終', '降', '終'],
          ['音', '戦', '伏', '戦'],
        ],
        'correctChars': ['玉', '音'],
      },
      {
        'segments': ['奈良時代に建立された', '東大寺の大仏で有名な', 'この天皇の名前は？'],
        'answers': ['聖武天皇', '桓武天皇', '嵯峨天皇', '醍醐天皇'],
        'correctIndex': 0,
        'fullQuestion': '奈良時代に建立された東大寺の大仏で有名なこの天皇の名前は？',
        'inputFormat': '◯◯天皇',
        'targetInput': '聖武',
        'charOptions': [
          ['聖', '桓', '嵯', '醍'],
          ['武', '武', '峨', '醐'],
        ],
        'correctChars': ['聖', '武'],
      },
      {
        'segments': ['1467年から約10年続いた', '室町時代の大乱', 'この戦乱の名前は？'],
        'answers': ['応仁の乱', '承久の乱', '保元の乱', '平治の乱'],
        'correctIndex': 0,
        'fullQuestion': '1467年から約10年続いた室町時代の大乱この戦乱の名前は？',
        'inputFormat': '◯◯の乱',
        'targetInput': '応仁',
        'charOptions': [
          ['応', '承', '保', '平'],
          ['仁', '久', '元', '治'],
        ],
        'correctChars': ['応', '仁'],
      },
      {
        'segments': ['平安時代に書かれた', '紫式部による長編小説', 'この作品の名前は？'],
        'answers': ['枕草子', '源氏物語', '竹取物語', '伊勢物語'],
        'correctIndex': 1,
        'fullQuestion': '平安時代に書かれた紫式部による長編小説この作品の名前は？',
        'inputFormat': '◯◯物語',
        'targetInput': '源氏',
        'charOptions': [
          ['源', '枕', '竹', '伊'],
          ['氏', '草', '取', '勢'],
        ],
        'correctChars': ['源', '氏'],
      },
      {
        'segments': ['1853年に浦賀に来航し', '日本の開国を迫った', 'アメリカの提督は誰？'],
        'answers': ['ハリス', 'ペリー', 'アダムス', 'ヘボン'],
        'correctIndex': 1,
        'fullQuestion': '1853年に浦賀に来航し日本の開国を迫ったアメリカの提督は誰？',
        'inputFormat': 'ペ◯◯',
        'targetInput': 'リー',
        'charOptions': [
          ['リ', 'ハ', 'ア', 'ヘ'],
          ['ー', 'リ', 'ダ', 'ボ'],
        ],
        'correctChars': ['リ', 'ー'],
      },
    ],
    QuizCategory.okinawa: [
      {
        'segments': ['沖縄県の県庁所在地で', '首里城があることで有名な', 'この市の名前は？'],
        'answers': ['宜野湾市', '那覇市', '浦添市', '沖縄市'],
        'correctIndex': 1,
        'fullQuestion': '沖縄県の県庁所在地で首里城があることで有名なこの市の名前は？',
        'inputFormat': '◯◯市',
        'targetInput': '那覇',
        'charOptions': [
          ['那', '宜', '浦', '沖'],
          ['覇', '野', '添', '縄'],
        ],
        'correctChars': ['那', '覇'],
      },
      {
        'segments': ['沖縄の伝統的な楽器で', '三線とも呼ばれる', 'この弦楽器の名前は？'],
        'answers': ['三味線', '三線', '琴', '琵琶'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の伝統的な楽器で三線とも呼ばれるこの弦楽器の名前は？',
        'inputFormat': '◯◯',
        'targetInput': '三線',
        'charOptions': [
          ['三', '二', '四', '五'],
          ['線', '弦', '味', '音'],
        ],
        'correctChars': ['三', '線'],
      },
      {
        'segments': ['沖縄の代表的な料理で', '豚肉を使った炒め物', 'この料理の名前は？'],
        'answers': ['ゴーヤチャンプルー', 'チャンプルー', 'ラフテー', 'タコライス'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の代表的な料理で豚肉を使った炒め物この料理の名前は？',
        'inputFormat': '◯◯◯◯◯◯',
        'targetInput': 'チャンプルー',
        'charOptions': [
          ['チ', 'ゴ', 'ラ', 'タ'],
          ['ャ', 'ー', 'フ', 'コ'],
          ['ン', 'ヤ', 'テ', 'ラ'],
          ['プ', 'チ', 'ー', 'イ'],
          ['ル', 'ャ', 'ー', 'ス'],
          ['ー', 'ン', '！', '。'],
        ],
        'correctChars': ['チ', 'ャ', 'ン', 'プ', 'ル', 'ー'],
      },
      {
        'segments': ['沖縄の方言で', 'ありがとうを意味する', 'この言葉は何？'],
        'answers': ['ハイサイ', 'ニフェーデービル', 'チャーガンジュー', 'ウチナーグチ'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の方言でありがとうを意味するこの言葉は何？',
        'inputFormat': 'ニフェー◯◯◯◯',
        'targetInput': 'デービル',
        'charOptions': [
          ['デ', 'ハ', 'チ', 'ウ'],
          ['ー', 'イ', 'ャ', 'チ'],
          ['ビ', 'サ', 'ー', 'ナ'],
          ['ル', 'イ', 'ガ', 'ー'],
        ],
        'correctChars': ['デ', 'ー', 'ビ', 'ル'],
      },
      {
        'segments': ['沖縄本島南部にある', '激戦地として知られる', 'この地名は？'],
        'answers': ['糸満', 'ひめゆり', '摩文仁', '南城'],
        'correctIndex': 0,
        'fullQuestion': '沖縄本島南部にある激戦地として知られるこの地名は？',
        'inputFormat': '◯◯',
        'targetInput': '糸満',
        'charOptions': [
          ['糸', 'ひ', '摩', '南'],
          ['満', 'め', '文', '城'],
        ],
        'correctChars': ['糸', '満'],
      },
      {
        'segments': ['沖縄の伝統的な踊りで', '手の動きが美しい', 'この舞踊の名前は？'],
        'answers': ['エイサー', '琉球舞踊', 'カチャーシー', '獅子舞'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の伝統的な踊りで手の動きが美しいこの舞踊の名前は？',
        'inputFormat': '琉球◯◯',
        'targetInput': '舞踊',
        'charOptions': [
          ['舞', 'エ', 'カ', '獅'],
          ['踊', 'イ', 'チ', '子'],
        ],
        'correctChars': ['舞', '踊'],
      },
      {
        'segments': ['沖縄の特産品で', '黒い色をした砂糖', 'この砂糖の名前は？'],
        'answers': ['白砂糖', '黒糖', '氷砂糖', '三温糖'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の特産品で黒い色をした砂糖この砂糖の名前は？',
        'inputFormat': '◯糖',
        'targetInput': '黒',
        'charOptions': [
          ['白', '黒', '氷', '三'],
        ],
        'correctChars': ['黒'],
      },
      {
        'segments': ['沖縄の海に生息する', '青い熱帯魚として有名な', 'この魚の名前は？'],
        'answers': ['マンタ', 'ナンヨウハギ', 'クマノミ', 'ジンベエザメ'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の海に生息する青い熱帯魚として有名なこの魚の名前は？',
        'inputFormat': 'ナンヨウ◯◯',
        'targetInput': 'ハギ',
        'charOptions': [
          ['ハ', 'マ', 'ク', 'ジ'],
          ['ギ', 'ン', 'マ', 'ン'],
        ],
        'correctChars': ['ハ', 'ギ'],
      },
      {
        'segments': ['沖縄の伝統的な家屋で', '赤い瓦屋根が特徴的な', 'この建築様式は？'],
        'answers': ['民家', '沖縄民家', '琉球建築', '南国建築'],
        'correctIndex': 2,
        'fullQuestion': '沖縄の伝統的な家屋で赤い瓦屋根が特徴的なこの建築様式は？',
        'inputFormat': '琉球◯◯',
        'targetInput': '建築',
        'charOptions': [
          ['建', '民', '沖', '南'],
          ['築', '家', '縄', '国'],
        ],
        'correctChars': ['建', '築'],
      },
      {
        'segments': ['沖縄の代表的な織物で', '鮮やかな色彩が美しい', 'この織物の名前は？'],
        'answers': ['友禅', '紅型', '絣', '久米島紬'],
        'correctIndex': 1,
        'fullQuestion': '沖縄の代表的な織物で鮮やかな色彩が美しいこの織物の名前は？',
        'inputFormat': '◯型',
        'targetInput': '紅',
        'charOptions': [
          ['友', '紅', '絣', '久'],
        ],
        'correctChars': ['紅'],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _attackController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _attackAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _attackController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _confettiController.addListener(() {
      if (isConfettiActive) {
        setState(() {
          for (var particle in confettiParticles) {
            particle.update();
          }
          // 画面外に出たパーティクルを削除
          confettiParticles.removeWhere((particle) =>
              particle.y > MediaQuery.of(context).size.height + 100);
        });
      }
    });
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    inputTimer?.cancel();
    confettiTimer?.cancel();
    _attackController.dispose();
    _shakeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get currentQuestions {
    return questionsByCategory[selectedCategory] ?? [];
  }

  void selectCategory(QuizCategory category) {
    setState(() {
      selectedCategory = category;
      currentEnemy = Enemy(
        name: enemies[category]!.name,
        emoji: enemies[category]!.emoji,
        maxHp: enemies[category]!.maxHp,
        category: category,
      );
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
      isAttacking = false;
      lastDamage = 0;
    });
  }

  void startQuestion() {
    setState(() {
      isQuestionStarted = true;
      currentSegmentIndex = 0;
      timeRemaining = 15;
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
          currentQuestions[currentQuestionIndex]['segments'].length - 1) {
        setState(() {
          currentSegmentIndex++;
        });
      }
    });

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

    final currentQuestion = currentQuestions[currentQuestionIndex];
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

    int segmentBonus = (3 - currentSegmentIndex) * 2;
    int inputBonus = 3;
    int damage = segmentBonus + inputBonus;

    setState(() {
      isInputMode = false;
      isAnswered = true;
      isCorrect = true;
      lastDamage = damage.clamp(1, 15);
      score += lastDamage;
    });

    _performAttack();
  }

  void _performAttack() {
    if (currentEnemy == null) return;

    setState(() {
      isAttacking = true;
    });

    _attackController.forward();
    _shakeController.forward();

    Timer(const Duration(milliseconds: 400), () {
      bool wasDefeated = currentEnemy!.isDefeated;
      currentEnemy!.takeDamage(lastDamage);

      // 敵を撃破した場合は紙吹雪を開始
      if (!wasDefeated && currentEnemy!.isDefeated) {
        _startConfetti();
      }

      setState(() {});
    });

    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        isAttacking = false;
      });
      _attackController.reset();
      _shakeController.reset();
    });
  }

  void _startConfetti() {
    final random = math.Random();
    final screenWidth = MediaQuery.of(context).size.width;

    confettiParticles.clear();

    // 50個の紙吹雪パーティクルを生成
    for (int i = 0; i < 50; i++) {
      confettiParticles.add(ConfettiParticle(
        x: random.nextDouble() * screenWidth,
        y: -20.0,
        velocityX: (random.nextDouble() - 0.5) * 4,
        velocityY: random.nextDouble() * 2 + 1,
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
        color: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
          Colors.pink,
          Colors.cyan,
        ][random.nextInt(8)],
        size: random.nextDouble() * 8 + 4,
        gravity: random.nextDouble() * 0.2 + 0.1,
      ));
    }

    setState(() {
      isConfettiActive = true;
    });

    _confettiController.forward();

    // 3秒後に紙吹雪を停止
    confettiTimer = Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        isConfettiActive = false;
        confettiParticles.clear();
      });
      _confettiController.reset();
    });
  }

  void nextQuestion() {
    questionTimer?.cancel();
    inputTimer?.cancel();
    setState(() {
      if (currentQuestionIndex < currentQuestions.length - 1) {
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
    confettiTimer?.cancel();
    _attackController.reset();
    _shakeController.reset();
    _confettiController.reset();
    setState(() {
      selectedCategory = null;
      currentEnemy = null;
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
      isAttacking = false;
      lastDamage = 0;
      isConfettiActive = false;
      confettiParticles.clear();
    });
  }

  String _getCurrentQuestionText() {
    final segments =
        currentQuestions[currentQuestionIndex]['segments'] as List<String>;
    return segments.take(currentSegmentIndex + 1).join(' ');
  }

  String _getInputDisplay() {
    final currentQuestion = currentQuestions[currentQuestionIndex];
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
  Widget build(BuildContext context) {
    // カテゴリ選択画面
    if (selectedCategory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('カテゴリ選択'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  '🎯 挑戦したいカテゴリを選択してください',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    children: QuizCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButton(
                          onPressed: () => selectCategory(category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: category.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(category.icon, size: 30),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  Text(
                                    category.displayName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${questionsByCategory[category]?.length ?? 0}問',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // クイズ画面
    final currentQuestion = currentQuestions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == currentQuestions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedCategory!.displayName}クイズ'),
        backgroundColor: selectedCategory!.color,
        foregroundColor: Colors.white,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            questionTimer?.cancel();
            inputTimer?.cancel();
            confettiTimer?.cancel();
            setState(() {
              selectedCategory = null;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 進捗表示
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / currentQuestions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(selectedCategory!.color),
                  ),
                  const SizedBox(height: 8),

                  // 問題番号とスコア
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '問題 ${currentQuestionIndex + 1}/${currentQuestions.length}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'スコア: $score',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 敵のHP表示
                  if (currentEnemy != null) ...[
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              _shakeAnimation.value * (isAttacking ? 1 : 0), 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedCategory!.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      selectedCategory!.color.withOpacity(0.3)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentEnemy!.emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      currentEnemy!.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: selectedCategory!.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: currentEnemy!.hpPercentage,
                                        backgroundColor: Colors.red[200],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          currentEnemy!.hpPercentage > 0.5
                                              ? Colors.green
                                              : currentEnemy!.hpPercentage > 0.2
                                                  ? Colors.orange
                                                  : Colors.red,
                                        ),
                                        minHeight: 6,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${currentEnemy!.currentHp}/${currentEnemy!.maxHp}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isAttacking && lastDamage > 0)
                                  AnimatedBuilder(
                                    animation: _attackAnimation,
                                    builder: (context, child) {
                                      return Opacity(
                                        opacity: 1.0 - _attackAnimation.value,
                                        child: Transform.translate(
                                          offset: Offset(
                                              0, -15 * _attackAnimation.value),
                                          child: Text(
                                            '💥 -$lastDamage',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                if (currentEnemy!.isDefeated)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      '🎯 撃破！',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                  ],

                  // タイマー表示
                  if (isQuestionStarted && canAnswer)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: timeRemaining <= 5
                            ? Colors.red[100]
                            : selectedCategory!.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color: timeRemaining <= 5
                                ? Colors.red
                                : selectedCategory!.color,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '残り時間: ${timeRemaining}秒',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: timeRemaining <= 5
                                  ? Colors.red
                                  : selectedCategory!.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 入力モードのタイマー表示
                  if (isInputMode)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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

                  // 問題文 - 表示領域を縮小
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedCategory!.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: selectedCategory!.color.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isQuestionStarted)
                            const Text(
                              '準備はいいですか？\n「問題開始」を押してください',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else
                            Text(
                              _getCurrentQuestionText(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (isAnswered &&
                              MediaQuery.of(context).size.height > 600)
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getInputDisplay(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selectedCategory!.color,
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
                          backgroundColor: selectedCategory!.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '🚀 問題開始！',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  else if (canAnswer)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: startInputMode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedCategory!.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '⚡ 解答！',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  // 文字選択ボタン - Expandedで残りのスペースを活用
                  if (isInputMode)
                    Expanded(
                      flex: 8,
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
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 3.0,
                                children: (currentQuestion['charOptions']
                                        [currentCharIndex] as List<String>)
                                    .map((char) => ElevatedButton(
                                          onPressed: () =>
                                              selectCharacter(char),
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
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.red),
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      _buildFinalResult(),
                  ],
                ],
              ),
            ),
          ),

          // 紙吹雪エフェクト
          if (isConfettiActive)
            IgnorePointer(
              child: CustomPaint(
                painter: ConfettiPainter(confettiParticles),
                size: Size.infinite,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFinalResult() {
    final maxPossibleScore = currentQuestions.length * 15;
    final percentage = (score / maxPossibleScore * 100).round();
    final isEnemyDefeated = currentEnemy?.isDefeated ?? false;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.yellow[300]!),
      ),
      child: Column(
        children: [
          Text(
            isEnemyDefeated
                ? '🎉 ${selectedCategory!.displayName}クリア！'
                : '🏆 ${selectedCategory!.displayName}クイズ終了！',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isEnemyDefeated ? Colors.green : Colors.orange,
            ),
          ),
          if (currentEnemy != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentEnemy!.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  isEnemyDefeated
                      ? '${currentEnemy!.name} 撃破！'
                      : '${currentEnemy!.name} 残HP: ${currentEnemy!.currentHp}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        isEnemyDefeated ? Colors.red : selectedCategory!.color,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(
            '総ダメージ: $score点',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _getBattleGradeMessage(score, isEnemyDefeated),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: resetQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory!.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'カテゴリ選択に戻る',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentEnemy?.heal();
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
                      isAttacking = false;
                      lastDamage = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'もう一度挑戦',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBattleGradeMessage(int totalDamage, bool isEnemyDefeated) {
    if (isEnemyDefeated) return '🥇 完全勝利！敵を撃破しました！';
    if (totalDamage >= 80) return '🥈 惜しい！もう少しで撃破でした！';
    if (totalDamage >= 50) return '🥉 良い攻撃！敵にダメージを与えました！';
    return '📚 修行が必要！もっと知識を身につけよう！';
  }

  String _getGradeMessage(int percentage) {
    if (percentage >= 80) return '🥇 クイズ王級！';
    if (percentage >= 60) return '🥈 上級者！';
    if (percentage >= 40) return '🥉 中級者！';
    return '📚 初心者！';
  }
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      // 長方形の紙吹雪を描画
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
