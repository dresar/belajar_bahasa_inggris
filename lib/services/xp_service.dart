import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'neon_db_service.dart';

class XpService {
  static final XpService instance = XpService._internal();
  XpService._internal();

  int _totalXp = 0;
  int get totalXp => _totalXp;

  int get level => (_totalXp / 100).floor() + 1;

  final Set<String> _completedChapterIds = {};
  Set<String> get completedChapterIds => _completedChapterIds;

  final Map<String, int> _chapterExpMap = {};

  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    _totalXp = prefs.getInt('user_total_xp') ?? 0;
    final savedChapters = prefs.getStringList('user_completed_chapters') ?? [];
    _completedChapterIds.addAll(savedChapters);

    for (final chapterId in _completedChapterIds) {
      _chapterExpMap[chapterId] = prefs.getInt('chapter_exp_$chapterId') ?? 150;
    }

    _isInitialized = true;
  }

  Future<int> addXp(int points) async {
    await init();
    _totalXp += points;
    if (_totalXp < 0) _totalXp = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_total_xp', _totalXp);
    debugPrint('Added $points XP. Total XP: $_totalXp (Level $level)');
    progressNotifier.value++;
    return _totalXp;
  }

  Future<void> saveChapterCompleted({
    required int grade,
    required String chapterId,
    required String chapterTitle,
    required int score,
  }) async {
    await init();

    final earnedExp = score > 0 ? score + 50 : 150; // Base score + 50 completion bonus
    final isReplay = _completedChapterIds.contains(chapterId);
    final previousExp = _chapterExpMap[chapterId] ?? 0;

    _completedChapterIds.add(chapterId);
    _chapterExpMap[chapterId] = earnedExp;

    // Save locally for Guest / All users
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'user_completed_chapters', _completedChapterIds.toList());
    await prefs.setInt('chapter_exp_$chapterId', earnedExp);

    if (isReplay) {
      // Replay: Adjust total XP by net difference
      final diff = earnedExp - previousExp;
      if (diff != 0) {
        await addXp(diff);
      }
    } else {
      // First completion
      await addXp(earnedExp);
    }

    progressNotifier.value++;

    // Sync to Neon PostgreSQL DB if logged in
    final currentUser = NeonDbService.instance.currentUser;
    if (currentUser != null) {
      await NeonDbService.instance.saveProgress(
        userId: currentUser.id,
        grade: grade,
        chapterId: chapterId,
        chapterTitle: chapterTitle,
        score: earnedExp,
      );
    }
  }

  bool isChapterCompleted(String chapterId) {
    return _completedChapterIds.contains(chapterId);
  }

  int getChapterExp(String chapterId) {
    return _chapterExpMap[chapterId] ?? 150;
  }
}
