import 'package:flutter/material.dart';
import '../data/content_repository.dart';

class GameQuestion {
  final String id;
  final String type; // 'quiz', 'phrase', 'pair', 'listening', 'unscramble', 'guess_picture', 'memory', 'boss_battle', 'fill_blank', 'typing', 'true_false'
  final String prompt;
  final String targetAnswer;
  final List<String> options;
  final List<String> wordBank;
  final List<String> leftWords;
  final List<String> rightWords;
  final Map<String, String> correctPairs;
  final String imageEmoji;
  final List<String> shuffledLetters;
  final String bossName;
  final String bossEmoji;
  final int bossHp;

  const GameQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    this.targetAnswer = '',
    this.options = const [],
    this.wordBank = const [],
    this.leftWords = const [],
    this.rightWords = const [],
    this.correctPairs = const {},
    this.imageEmoji = '⭐',
    this.shuffledLetters = const [],
    this.bossName = 'Raja Kuis',
    this.bossEmoji = '👾',
    this.bossHp = 100,
  });
}

class ChapterGameData {
  final String chapterId;
  final String chapterTitle;
  final String chapterDescription;
  final List<GameQuestion> questions;

  const ChapterGameData({
    required this.chapterId,
    required this.chapterTitle,
    required this.chapterDescription,
    required this.questions,
  });
}

class VocabItem {
  final String id;
  final String english;
  final String indonesian;
  final String category;
  final String exampleSentence;
  final String _explicitPronunciation;

  const VocabItem({
    required this.id,
    required this.english,
    required this.indonesian,
    required this.category,
    this.exampleSentence = '',
    String pronunciation = '',
  }) : _explicitPronunciation = pronunciation;

  String get pronunciation {
    if (_explicitPronunciation.isNotEmpty) return _explicitPronunciation;
    return generatePhoneticReading(english);
  }

  static String generatePhoneticReading(String text) {
    if (text.isEmpty) return '';

    final clean = text.trim().toLowerCase();

    // Comprehensive Indonesian Phonetic Dictionary
    final Map<String, String> exactMap = {
      'hello': 'he-lo',
      'hi': 'hai',
      'good morning': 'gud mor-ning',
      'good afternoon': 'gud af-ter-nun',
      'good evening': 'gud iv-ning',
      'good night': 'gud nait',
      'goodbye': 'gud-bai',
      'thank you': 'thenk yu',
      'please': 'plis',
      'sorry': 'so-ri',
      'welcome': 'wel-kam',
      'friend': 'frend',
      'one': 'wan',
      'two': 'tu',
      'three': 'thri',
      'four': 'for',
      'five': 'faiv',
      'six': 'siks',
      'seven': 'se-ven',
      'eight': 'eit',
      'nine': 'nain',
      'ten': 'ten',
      'eleven': 'i-le-ven',
      'twelve': 'twelf',
      'thirteen': 'ther-tin',
      'fourteen': 'for-tin',
      'fifteen': 'fif-tin',
      'sixteen': 'siks-tin',
      'seventeen': 'se-ven-tin',
      'eighteen': 'ei-tin',
      'nineteen': 'nain-tin',
      'twenty': 'twen-ti',
      'red': 'red',
      'blue': 'blu',
      'yellow': 'ye-lo',
      'green': 'grin',
      'white': 'wait',
      'black': 'blek',
      'orange': 'o-rens',
      'purple': 'per-pel',
      'pink': 'pingk',
      'brown': 'braun',
      'gray': 'grei',
      'gold': 'gould',
      'circle': 'ser-kel',
      'square': 'skwer',
      'triangle': 'trai-eng-gel',
      'rectangle': 'rek-teng-gel',
      'star': 'star',
      'heart': 'hart',
      'oval': 'ou-vel',
      'diamond': 'dai-e-mond',
      'cat': 'ket',
      'dog': 'dog',
      'bird': 'berd',
      'fish': 'fisy',
      'duck': 'dak',
      'cow': 'kau',
      'goat': 'gout',
      'sheep': 'syip',
      'horse': 'hors',
      'pig': 'pig',
      'chicken': 'ci-ken',
      'rabbit': 're-bit',
      'lion': 'lai-en',
      'tiger': 'tai-ger',
      'elephant': 'e-le-fan',
      'monkey': 'mang-ki',
      'bear': 'ber',
      'zebra': 'zi-bra',
      'giraffe': 'ji-raf',
      'snake': 'snek',
      'frog': 'frog',
      'turtle': 'ter-tel',
      'butterfly': 'ba-ter-flai',
      'bee': 'bi',
      'ant': 'ent',
      'spider': 'spai-der',
      'owl': 'aul',
      'fox': 'foks',
      'deer': 'dir',
      'panda': 'pen-da',
      'koala': 'ko-a-la',
      'kangaroo': 'keng-ga-ru',
      'crab': 'kreb',
      'shark': 'syark',
      'whale': 'weil',
      'dolphin': 'dol-fin',
      'octopus': 'ok-to-pus',
      'starfish': 'star-fisy',
      'seahorse': 'si-hors',
      'penguin': 'peng-gwin',
      'eagle': 'i-gel',
      'parrot': 'pe-rot',
      'father': 'fa-der',
      'mother': 'ma-der',
      'brother': 'bra-der',
      'sister': 'sis-ter',
      'grandfather': 'grend-fa-der',
      'grandmother': 'grend-ma-der',
      'uncle': 'ang-kel',
      'aunt': 'ent',
      'baby': 'bei-bi',
      'son': 'san',
      'daughter': 'do-ter',
      'book': 'buk',
      'pencil': 'pen-sil',
      'pen': 'pen',
      'ruler': 'ru-ler',
      'eraser': 'i-rei-ser',
      'bag': 'beg',
      'desk': 'desk',
      'chair': 'ce-er',
      'table': 'tei-bel',
      'teacher': 'ti-cer',
      'student': 'stu-den',
      'school': 'skul',
      'class': 'klas',
      'classroom': 'klas-rum',
      'door': 'dor',
      'window': 'win-dou',
      'board': 'bord',
      'clock': 'klok',
      'map': 'mep',
      'head': 'hed',
      'hair': 'her',
      'eye': 'ai',
      'ear': 'ir',
      'nose': 'nous',
      'mouth': 'mauth',
      'face': 'feis',
      'hand': 'hend',
      'finger': 'fing-ger',
      'foot': 'fut',
      'leg': 'leg',
      'apple': 'e-pel',
      'banana': 'be-ne-ne',
      'mango': 'meng-gou',
      'grape': 'greip',
      'watermelon': 'wo-ter-me-lon',
      'melon': 'me-lon',
      'strawberry': 'stro-be-ri',
      'pineapple': 'pain-e-pel',
      'papaya': 'pe-pai-ya',
      'lemon': 'le-mon',
      'avocado': 'e-vo-ka-dou',
      'cherry': 'ce-ri',
    };

    if (exactMap.containsKey(clean)) {
      return exactMap[clean]!;
    }

    // Dynamic syllable phonetic formatter
    return clean
        .replaceAll('tion', 'syen')
        .replaceAll('sion', 'syen')
        .replaceAll('ight', 'ait')
        .replaceAll('oo', 'u')
        .replaceAll('ee', 'i')
        .replaceAll('ea', 'i')
        .replaceAll('ou', 'au')
        .replaceAll('ow', 'ou')
        .replaceAll('th', 'th')
        .replaceAll('sh', 'sy')
        .replaceAll('ch', 'c')
        .replaceAll('ph', 'f')
        .replaceAll('ck', 'k');
  }
}

class GameRepository {
  static List<({String id, String title, String description, Color topColor})>
      getGradeChapters(int grade) {
    return ContentRepository.instance.getChapterMetadataList(grade);
  }

  static ChapterGameData getChapterData(int grade, int chapterIndex) {
    return ContentRepository.instance.getChapterData(grade, chapterIndex);
  }

  static ChapterGameData getChapterDataById(String chapterId) {
    return ContentRepository.instance.getChapterData(1, 0);
  }
}
