import 'package:quiz/models/category_model.dart';
import 'package:quiz/models/quiz_model.dart';

class QuizData {
  static final List<Category> categories = [
    const Category(
      id: 'general',
      name: '一般常識',
      description: '日常生活で役立つ知識を学びましょう',
      questionCount: 10,
    ),
    const Category(
      id: 'science',
      name: '科学',
      description: '科学の基礎知識を学びましょう',
      questionCount: 10,
    ),
    const Category(
      id: 'history',
      name: '歴史',
      description: '日本の歴史について学びましょう',
      questionCount: 10,
    ),
    const Category(
      id: 'okinawa',
      name: '沖縄クイズ',
      description: '沖縄の文化、歴史、食べ物、観光地に関する問題です',
      questionCount: 10,
    ),
  ];

  static List<QuizQuestion> getQuestionsByCategory(String categoryId) {
    switch (categoryId) {
      case 'general':
        return [
          const QuizQuestion(
            id: 'g1',
            question: '日本の首都は？',
            options: ['東京', '大阪', '名古屋', '福岡'],
            correctAnswer: '東京',
          ),
          const QuizQuestion(
            id: 'g2',
            question: '1+1は？',
            options: ['1', '2', '3', '4'],
            correctAnswer: '2',
          ),
          const QuizQuestion(
            id: 'g3',
            question: '日本の国花は？',
            options: ['桜', '菊', '梅', '牡丹'],
            correctAnswer: '桜',
          ),
          const QuizQuestion(
            id: 'g4',
            question: '世界で最も大きな大陸は？',
            options: ['アジア', 'アフリカ', '北アメリカ', '南アメリカ'],
            correctAnswer: 'アジア',
          ),
          const QuizQuestion(
            id: 'g5',
            question: '世界で最も高い山は？',
            options: ['エベレスト', 'K2', 'マッターホルン', '富士山'],
            correctAnswer: 'エベレスト',
          ),
          const QuizQuestion(
            id: 'g6',
            question: '日本の人口は約何人？',
            options: ['1億人', '1億2千万人', '1億5千万人', '2億人'],
            correctAnswer: '1億2千万人',
          ),
          const QuizQuestion(
            id: 'g7',
            question: '世界で最も長い川は？',
            options: ['ナイル川', 'アマゾン川', 'ミシシッピ川', '長江'],
            correctAnswer: 'ナイル川',
          ),
          const QuizQuestion(
            id: 'g8',
            question: '日本の面積は約何平方キロメートル？',
            options: ['30万km²', '37万km²', '40万km²', '45万km²'],
            correctAnswer: '37万km²',
          ),
          const QuizQuestion(
            id: 'g9',
            question: '世界で最も大きな海は？',
            options: ['太平洋', '大西洋', 'インド洋', '北極海'],
            correctAnswer: '太平洋',
          ),
          const QuizQuestion(
            id: 'g10',
            question: '日本の最高気温記録は？',
            options: ['40.0℃', '41.1℃', '42.0℃', '43.0℃'],
            correctAnswer: '41.1℃',
          ),
        ];
      case 'science':
        return [
          const QuizQuestion(
            id: 's1',
            question: '水の化学式は？',
            options: ['H2O', 'CO2', 'O2', 'H2'],
            correctAnswer: 'H2O',
          ),
          const QuizQuestion(
            id: 's2',
            question: '光の速度は？',
            options: [
              '299,792,458 m/s',
              '299,792,458 km/s',
              '299,792,458 m/h',
              '299,792,458 km/h'
            ],
            correctAnswer: '299,792,458 m/s',
          ),
          const QuizQuestion(
            id: 's3',
            question: '地球の衛星は？',
            options: ['月', '火星', '金星', '木星'],
            correctAnswer: '月',
          ),
          const QuizQuestion(
            id: 's4',
            question: '元素記号「Fe」は何？',
            options: ['鉄', '銅', '金', '銀'],
            correctAnswer: '鉄',
          ),
          const QuizQuestion(
            id: 's5',
            question: '太陽系で最も大きな惑星は？',
            options: ['木星', '土星', '天王星', '海王星'],
            correctAnswer: '木星',
          ),
          const QuizQuestion(
            id: 's6',
            question: 'DNAの二重らせん構造を発見したのは？',
            options: ['ワトソンとクリック', 'アインシュタイン', 'ニュートン', 'ダーウィン'],
            correctAnswer: 'ワトソンとクリック',
          ),
          const QuizQuestion(
            id: 's7',
            question: '元素の周期表で最も軽い元素は？',
            options: ['水素', 'ヘリウム', 'リチウム', 'ベリリウム'],
            correctAnswer: '水素',
          ),
          const QuizQuestion(
            id: 's8',
            question: '光合成に必要な色素は？',
            options: ['クロロフィル', 'ヘモグロビン', 'メラニン', 'カロテン'],
            correctAnswer: 'クロロフィル',
          ),
          const QuizQuestion(
            id: 's9',
            question: '地球の中心部の温度は約何度？',
            options: ['4,000℃', '5,000℃', '6,000℃', '7,000℃'],
            correctAnswer: '6,000℃',
          ),
          const QuizQuestion(
            id: 's10',
            question: '原子の中心にあるのは？',
            options: ['原子核', '電子', '中性子', '陽子'],
            correctAnswer: '原子核',
          ),
        ];
      case 'history':
        return [
          const QuizQuestion(
            id: 'h1',
            question: '織田信長が活躍した時代は？',
            options: ['戦国時代', '江戸時代', '明治時代', '大正時代'],
            correctAnswer: '戦国時代',
          ),
          const QuizQuestion(
            id: 'h2',
            question: '日本が第二次世界大戦に参戦した年は？',
            options: ['1941年', '1942年', '1943年', '1944年'],
            correctAnswer: '1941年',
          ),
          const QuizQuestion(
            id: 'h3',
            question: '日本で最初の元号は？',
            options: ['大化', '明治', '大正', '昭和'],
            correctAnswer: '大化',
          ),
          const QuizQuestion(
            id: 'h4',
            question: '徳川家康が江戸幕府を開いた年は？',
            options: ['1600年', '1603年', '1605年', '1615年'],
            correctAnswer: '1603年',
          ),
          const QuizQuestion(
            id: 'h5',
            question: '明治維新が始まった年は？',
            options: ['1867年', '1868年', '1869年', '1870年'],
            correctAnswer: '1868年',
          ),
          const QuizQuestion(
            id: 'h6',
            question: '日本で最初の憲法が制定された年は？',
            options: ['1889年', '1890年', '1891年', '1892年'],
            correctAnswer: '1889年',
          ),
          const QuizQuestion(
            id: 'h7',
            question: '関ヶ原の戦いが行われた年は？',
            options: ['1600年', '1603年', '1615年', '1616年'],
            correctAnswer: '1600年',
          ),
          const QuizQuestion(
            id: 'h8',
            question: '日本で最初の内閣総理大臣は？',
            options: ['伊藤博文', '大隈重信', '山県有朋', '桂太郎'],
            correctAnswer: '伊藤博文',
          ),
          const QuizQuestion(
            id: 'h9',
            question: '日本が日露戦争に勝利した年は？',
            options: ['1904年', '1905年', '1906年', '1907年'],
            correctAnswer: '1905年',
          ),
          const QuizQuestion(
            id: 'h10',
            question: '日本国憲法が施行された年は？',
            options: ['1946年', '1947年', '1948年', '1949年'],
            correctAnswer: '1947年',
          ),
        ];
      case 'okinawa':
        return [
          const QuizQuestion(
            id: 'ok1',
            question: '沖縄の方言で「めんそーれ」の意味として最も一般的なのは？',
            options: [
              'こんにちは',
              'いらっしゃい',
              'さようなら',
              'ありがとう',
            ],
            correctAnswer: 'いらっしゃい',
          ),
          const QuizQuestion(
            id: 'ok2',
            question: '沖縄の伝統的な踊り「エイサー」で最も特徴的に使われる小型太鼓は？',
            options: [
              '三線',
              'パーランクー',
              '大太鼓',
              '笛',
            ],
            correctAnswer: 'パーランクー',
          ),
          const QuizQuestion(
            id: 'ok3',
            question: '沖縄の伝統的な家屋に置かれる「シーサー」は何から家を守る目的で設置される？',
            options: [
              '火災',
              '泥棒',
              '悪霊',
              '台風',
            ],
            correctAnswer: '悪霊',
          ),
          const QuizQuestion(
            id: 'ok4',
            question: '沖縄料理「ゴーヤーチャンプルー」で最も基本的で代表的な材料の組み合わせは？',
            options: [
              'ゴーヤーと豆腐',
              'ゴーヤーと豚肉',
              'ゴーヤーと卵',
              'ゴーヤーと野菜',
            ],
            correctAnswer: 'ゴーヤーと豆腐',
          ),
          const QuizQuestion(
            id: 'ok5',
            question: '沖縄の伝統酒「泡盛」の主な原料は？',
            options: [
              '米',
              '麦',
              '芋',
              'とうもろこし',
            ],
            correctAnswer: '米',
          ),
          const QuizQuestion(
            id: 'ok6',
            question: '琉球の伝統織物「琉球絣（かすり）」の代表的な染色技法は？',
            options: [
              '藍染め',
              '紅型',
              '芭蕉布',
              '首里織',
            ],
            correctAnswer: '藍染め',
          ),
          const QuizQuestion(
            id: 'ok7',
            question: '沖縄の伝統行事「ハーリー」は何の安全と繁栄を祈る祭り？',
            options: [
              '豊作',
              '大漁',
              '商売繁盛',
              '家内安全',
            ],
            correctAnswer: '大漁',
          ),
          const QuizQuestion(
            id: 'ok8',
            question: '沖縄伝統菓子「ちんすこう」の最も基本的な材料は？',
            options: [
              '小麦粉と砂糖',
              '米粉と砂糖',
              '芋と砂糖',
              '豆と砂糖',
            ],
            correctAnswer: '小麦粉と砂糖',
          ),
          const QuizQuestion(
            id: 'ok9',
            question: '沖縄の伝統楽器「三線」の弦の本数は？',
            options: [
              '2本',
              '3本',
              '4本',
              '5本',
            ],
            correctAnswer: '3本',
          ),
          const QuizQuestion(
            id: 'ok10',
            question: '沖縄の踊り「カチャーシー」の最も特徴的な動きは？',
            options: [
              '手を回す',
              '足を踏む',
              '腰を振る',
              '首を振る',
            ],
            correctAnswer: '手を回す',
          ),
        ];
      default:
        return [];
    }
  }
}
