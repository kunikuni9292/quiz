import 'package:quiz/models/category_model.dart';
import 'package:quiz/models/quiz_model.dart';

class QuizData {
  static final List<Category> categories = [
    Category(
      id: 'general',
      name: '一般常識',
      description: '日常生活で役立つ知識を学びましょう',
      questionCount: 10,
    ),
    Category(
      id: 'science',
      name: '科学',
      description: '科学の基礎知識を学びましょう',
      questionCount: 10,
    ),
    Category(
      id: 'history',
      name: '歴史',
      description: '日本の歴史について学びましょう',
      questionCount: 10,
    ),
  ];

  static List<QuizQuestion> getQuestionsByCategory(String categoryId) {
    switch (categoryId) {
      case 'general':
        return [
          QuizQuestion(
            id: 'g1',
            question: '日本の首都は？',
            options: ['東京', '大阪', '名古屋', '福岡'],
            correctAnswer: '東京',
          ),
          QuizQuestion(
            id: 'g2',
            question: '1+1は？',
            options: ['1', '2', '3', '4'],
            correctAnswer: '2',
          ),
          QuizQuestion(
            id: 'g3',
            question: '日本の国花は？',
            options: ['桜', '菊', '梅', '牡丹'],
            correctAnswer: '桜',
          ),
          QuizQuestion(
            id: 'g4',
            question: '世界で最も大きな大陸は？',
            options: ['アジア', 'アフリカ', '北アメリカ', '南アメリカ'],
            correctAnswer: 'アジア',
          ),
          QuizQuestion(
            id: 'g5',
            question: '世界で最も高い山は？',
            options: ['エベレスト', 'K2', 'マッターホルン', '富士山'],
            correctAnswer: 'エベレスト',
          ),
          QuizQuestion(
            id: 'g6',
            question: '日本の人口は約何人？',
            options: ['1億人', '1億2千万人', '1億5千万人', '2億人'],
            correctAnswer: '1億2千万人',
          ),
          QuizQuestion(
            id: 'g7',
            question: '世界で最も長い川は？',
            options: ['ナイル川', 'アマゾン川', 'ミシシッピ川', '長江'],
            correctAnswer: 'ナイル川',
          ),
          QuizQuestion(
            id: 'g8',
            question: '日本の面積は約何平方キロメートル？',
            options: ['30万km²', '37万km²', '40万km²', '45万km²'],
            correctAnswer: '37万km²',
          ),
          QuizQuestion(
            id: 'g9',
            question: '世界で最も大きな海は？',
            options: ['太平洋', '大西洋', 'インド洋', '北極海'],
            correctAnswer: '太平洋',
          ),
          QuizQuestion(
            id: 'g10',
            question: '日本の最高気温記録は？',
            options: ['40.0℃', '41.1℃', '42.0℃', '43.0℃'],
            correctAnswer: '41.1℃',
          ),
        ];
      case 'science':
        return [
          QuizQuestion(
            id: 's1',
            question: '水の化学式は？',
            options: ['H2O', 'CO2', 'O2', 'H2'],
            correctAnswer: 'H2O',
          ),
          QuizQuestion(
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
          QuizQuestion(
            id: 's3',
            question: '地球の衛星は？',
            options: ['月', '火星', '金星', '木星'],
            correctAnswer: '月',
          ),
          QuizQuestion(
            id: 's4',
            question: '元素記号「Fe」は何？',
            options: ['鉄', '銅', '金', '銀'],
            correctAnswer: '鉄',
          ),
          QuizQuestion(
            id: 's5',
            question: '太陽系で最も大きな惑星は？',
            options: ['木星', '土星', '天王星', '海王星'],
            correctAnswer: '木星',
          ),
          QuizQuestion(
            id: 's6',
            question: 'DNAの二重らせん構造を発見したのは？',
            options: ['ワトソンとクリック', 'アインシュタイン', 'ニュートン', 'ダーウィン'],
            correctAnswer: 'ワトソンとクリック',
          ),
          QuizQuestion(
            id: 's7',
            question: '元素の周期表で最も軽い元素は？',
            options: ['水素', 'ヘリウム', 'リチウム', 'ベリリウム'],
            correctAnswer: '水素',
          ),
          QuizQuestion(
            id: 's8',
            question: '光合成に必要な色素は？',
            options: ['クロロフィル', 'ヘモグロビン', 'メラニン', 'カロテン'],
            correctAnswer: 'クロロフィル',
          ),
          QuizQuestion(
            id: 's9',
            question: '地球の中心部の温度は約何度？',
            options: ['4,000℃', '5,000℃', '6,000℃', '7,000℃'],
            correctAnswer: '6,000℃',
          ),
          QuizQuestion(
            id: 's10',
            question: '原子の中心にあるのは？',
            options: ['原子核', '電子', '中性子', '陽子'],
            correctAnswer: '原子核',
          ),
        ];
      case 'history':
        return [
          QuizQuestion(
            id: 'h1',
            question: '織田信長が活躍した時代は？',
            options: ['戦国時代', '江戸時代', '明治時代', '大正時代'],
            correctAnswer: '戦国時代',
          ),
          QuizQuestion(
            id: 'h2',
            question: '日本が第二次世界大戦に参戦した年は？',
            options: ['1941年', '1942年', '1943年', '1944年'],
            correctAnswer: '1941年',
          ),
          QuizQuestion(
            id: 'h3',
            question: '日本で最初の元号は？',
            options: ['大化', '明治', '大正', '昭和'],
            correctAnswer: '大化',
          ),
          QuizQuestion(
            id: 'h4',
            question: '徳川家康が江戸幕府を開いた年は？',
            options: ['1600年', '1603年', '1605年', '1615年'],
            correctAnswer: '1603年',
          ),
          QuizQuestion(
            id: 'h5',
            question: '明治維新が始まった年は？',
            options: ['1867年', '1868年', '1869年', '1870年'],
            correctAnswer: '1868年',
          ),
          QuizQuestion(
            id: 'h6',
            question: '日本で最初の憲法が制定された年は？',
            options: ['1889年', '1890年', '1891年', '1892年'],
            correctAnswer: '1889年',
          ),
          QuizQuestion(
            id: 'h7',
            question: '関ヶ原の戦いが行われた年は？',
            options: ['1600年', '1603年', '1615年', '1616年'],
            correctAnswer: '1600年',
          ),
          QuizQuestion(
            id: 'h8',
            question: '日本で最初の内閣総理大臣は？',
            options: ['伊藤博文', '大隈重信', '山県有朋', '桂太郎'],
            correctAnswer: '伊藤博文',
          ),
          QuizQuestion(
            id: 'h9',
            question: '日本が日露戦争に勝利した年は？',
            options: ['1904年', '1905年', '1906年', '1907年'],
            correctAnswer: '1905年',
          ),
          QuizQuestion(
            id: 'h10',
            question: '日本国憲法が施行された年は？',
            options: ['1946年', '1947年', '1948年', '1949年'],
            correctAnswer: '1947年',
          ),
        ];
      default:
        return [];
    }
  }
}
