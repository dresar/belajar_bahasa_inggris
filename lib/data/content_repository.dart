import 'package:flutter/material.dart';
import '../models/game_content.dart';
import 'grades/grade_1_data.dart';
import 'grades/grade_2_data.dart';
import 'grades/grade_3_data.dart';
import 'grades/grade_4_data.dart';
import 'grades/grade_5_data.dart';
import 'grades/grade_6_data.dart';

class ContentRepository {
  static final ContentRepository instance = ContentRepository._internal();
  ContentRepository._internal();

  /// Peta Materi Per Kelas (1 - 6)
  static final Map<int, List<ChapterGameData>> _allGradeData = {
    1: grade1Chapters,
    2: grade2Chapters,
    3: grade3Chapters,
    4: grade4Chapters,
    5: grade5Chapters,
    6: grade6Chapters,
  };

  /// Mengambil semua daftar bab/materi untuk Kelas tertentu (1..6)
  List<ChapterGameData> getChaptersForGrade(int grade) {
    return _allGradeData[grade] ?? grade1Chapters;
  }

  /// Mengambil metadata bab untuk halaman SelectChapterPage
  List<({String id, String title, String description, Color topColor})>
      getChapterMetadataList(int grade) {
    final chapters = getChaptersForGrade(grade);
    final colors = [
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFE65100),
      const Color(0xFF8E24AA),
      const Color(0xFFD81B60),
      const Color(0xFF00897B),
      const Color(0xFF3949AB),
    ];

    return chapters.asMap().entries.map((entry) {
      final idx = entry.key;
      final c = entry.value;
      return (
        id: c.chapterId,
        title: c.chapterTitle,
        description: c.chapterDescription,
        topColor: colors[idx % colors.length],
      );
    }).toList();
  }

  /// Mengambil data detail bab dan soal berdasarkan grade & chapterIndex
  ChapterGameData getChapterData(int grade, int chapterIndex) {
    final chapters = getChaptersForGrade(grade);
    if (chapterIndex >= 0 && chapterIndex < chapters.length) {
      return chapters[chapterIndex];
    }
    return chapters.first;
  }
}
