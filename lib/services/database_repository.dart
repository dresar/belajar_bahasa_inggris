import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'xp_service.dart';

class DatabaseRepository {
  static final DatabaseRepository instance = DatabaseRepository._internal();
  DatabaseRepository._internal();

  static const String _dbLeaderboardKey = 'db_table_leaderboard';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_dbLeaderboardKey);
    if (jsonStr == null || jsonStr.isEmpty) {
      await _seedDummyDatabase(prefs);
    }
  }

  Future<void> _seedDummyDatabase(SharedPreferences prefs) async {
    final initialDbData = [
      {'id': 'u1', 'name': 'Budi Santoso 🚀', 'avatar': '👦', 'xp': 1250, 'level': 13},
      {'id': 'u2', 'name': 'Siti Rahma 🌟', 'avatar': '👧', 'xp': 980, 'level': 10},
      {'id': 'u3', 'name': 'Andi Pratama ⚡', 'avatar': '🧑', 'xp': 850, 'level': 9},
      {'id': 'u4', 'name': 'Dewi Lestari 🎨', 'avatar': '👩', 'xp': 420, 'level': 5},
      {'id': 'u5', 'name': 'Rizky Febian 🐱', 'avatar': '👦', 'xp': 390, 'level': 4},
      {'id': 'u6', 'name': 'Nabila Putri 🌸', 'avatar': '👧', 'xp': 310, 'level': 4},
      {'id': 'u7', 'name': 'Fajar Siddiq ⚽', 'avatar': '👦', 'xp': 280, 'level': 3},
      {'id': 'u8', 'name': 'Ayu Tingting 🎵', 'avatar': '👧', 'xp': 210, 'level': 3},
      {'id': 'u9', 'name': 'Doni Monardo 🛡️', 'avatar': '👦', 'xp': 150, 'level': 2},
    ];

    await prefs.setString(_dbLeaderboardKey, jsonEncode(initialDbData));
    debugPrint('DatabaseRepository: Seeded initial dummy leaderboard records into Database.');
  }

  Future<List<Map<String, dynamic>>> getLeaderboardEntries() async {
    await init();
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_dbLeaderboardKey) ?? '[]';

    List<dynamic> rawList = [];
    try {
      rawList = jsonDecode(jsonStr);
    } catch (_) {}

    final List<Map<String, dynamic>> dbEntries =
        rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    // Dynamically insert current user's live DB record
    final currentUserXp = XpService.instance.totalXp;
    final currentUserLevel = XpService.instance.level;

    dbEntries.removeWhere((e) => e['id'] == 'current_user');
    dbEntries.add({
      'id': 'current_user',
      'name': 'Kamu (Siswa SD) ⭐',
      'avatar': '🦸‍♂️',
      'xp': currentUserXp > 0 ? currentUserXp : 450,
      'level': currentUserLevel,
    });

    // Dynamic Database Query Sorting by XP descending
    dbEntries.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    // Assign dynamic ranks
    for (int i = 0; i < dbEntries.length; i++) {
      dbEntries[i]['rank'] = i + 1;
    }

    return dbEntries;
  }

  Future<void> updateLeaderboardUser({
    required String userId,
    required String name,
    required int xp,
    required int level,
  }) async {
    await init();
    final prefs = await SharedPreferences.getInstance();
    final entries = await getLeaderboardEntries();

    final index = entries.indexWhere((e) => e['id'] == userId);
    if (index != -1) {
      entries[index]['xp'] = xp;
      entries[index]['level'] = level;
      entries[index]['name'] = name;
    } else {
      entries.add({
        'id': userId,
        'name': name,
        'avatar': '👦',
        'xp': xp,
        'level': level,
      });
    }

    await prefs.setString(_dbLeaderboardKey, jsonEncode(entries));
  }
}
