import '../../models/game_content.dart';
import 'grade_1_vocab.dart';
import 'grade_2_vocab.dart';
import 'grade_3_vocab.dart';
import 'grade_4_vocab.dart';
import 'grade_5_vocab.dart';
import 'grade_6_vocab.dart';

class VocabRepository {
  static List<VocabItem> getVocabForGrade(int grade) {
    switch (grade) {
      case 1:
        return grade1VocabList;
      case 2:
        return grade2VocabList;
      case 3:
        return grade3VocabList;
      case 4:
        return grade4VocabList;
      case 5:
        return grade5VocabList;
      case 6:
        return grade6VocabList;
      default:
        return grade1VocabList;
    }
  }

  static int getTotalVocabCount() {
    return grade1VocabList.length +
        grade2VocabList.length +
        grade3VocabList.length +
        grade4VocabList.length +
        grade5VocabList.length +
        grade6VocabList.length;
  }
}
