import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_repository.dart';

class NeonUser {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String role;

  NeonUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'fullName': fullName,
        'role': role,
      };

  factory NeonUser.fromJson(Map<String, dynamic> json) => NeonUser(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        username: json['username'] ?? '',
        fullName: json['fullName'] ?? '',
        role: json['role'] ?? 'user',
      );
}

class NeonUserProgress {
  final String id;
  final String userId;
  final int grade;
  final String chapterId;
  final String chapterTitle;
  final int score;
  final DateTime completedAt;

  NeonUserProgress({
    required this.id,
    required this.userId,
    required this.grade,
    required this.chapterId,
    required this.chapterTitle,
    required this.score,
    required this.completedAt,
  });
}

class NeonDbService {
  static final NeonDbService instance = NeonDbService._internal();
  NeonDbService._internal();

  static const String _dbHost =
      'ep-broad-hall-az5w0kvj-pooler.c-3.ap-southeast-1.aws.neon.tech';
  static const String _dbName = 'neondb';
  static const String _dbUser = 'neondb_owner';
  static const String _dbPass = 'npg_BRoAzMxHu9m2';
  static const int _dbPort = 5432;

  NeonUser? _currentUser;
  NeonUser? get currentUser => _currentUser;

  bool _isInitialized = false;

  // Fallback in-memory seed progress if DB connection is unavailable
  final List<NeonUserProgress> _fallbackDevProgress = [
    NeonUserProgress(
      id: 'p1',
      userId: 'dev-user-001',
      grade: 1,
      chapterId: 'greeting',
      chapterTitle: 'Greeting & Salam',
      score: 100,
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NeonUserProgress(
      id: 'p2',
      userId: 'dev-user-001',
      grade: 1,
      chapterId: 'animals',
      chapterTitle: 'Cute Animals',
      score: 90,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NeonUserProgress(
      id: 'p3',
      userId: 'dev-user-001',
      grade: 1,
      chapterId: 'colors',
      chapterTitle: 'Bright Colors',
      score: 85,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NeonUserProgress(
      id: 'p4',
      userId: 'dev-user-001',
      grade: 1,
      chapterId: 'numbers',
      chapterTitle: 'My Numbers 1-10',
      score: 100,
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NeonUserProgress(
      id: 'p5',
      userId: 'dev-user-001',
      grade: 1,
      chapterId: 'fruits',
      chapterTitle: 'Fresh Fruits',
      score: 95,
      completedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  Future<Connection?> _getConnection() async {
    try {
      final endpoint = Endpoint(
        host: _dbHost,
        database: _dbName,
        username: _dbUser,
        password: _dbPass,
        port: _dbPort,
      );
      final conn = await Connection.open(
        endpoint,
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
        ),
      );
      return conn;
    } catch (e) {
      debugPrint('Neon DB Connection Warning: $e');
      return null;
    }
  }

  Future<void> initDbAndSeed() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('logged_user_email');
    final savedName = prefs.getString('logged_user_name');
    final savedRole = prefs.getString('logged_user_role');
    final savedId = prefs.getString('logged_user_id');

    if (savedEmail != null && savedId != null) {
      _currentUser = NeonUser(
        id: savedId,
        email: savedEmail,
        username: prefs.getString('logged_user_username') ?? 'dev',
        fullName: savedName ?? 'Developer (Dev)',
        role: savedRole ?? 'developer',
      );
    }

    Connection? conn;
    try {
      conn = await _getConnection();
      if (conn != null) {
        // Create users table
        await conn.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            full_name TEXT NOT NULL,
            role TEXT NOT NULL DEFAULT 'user',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );
        ''');

        // Create user_progress table
        await conn.execute('''
          CREATE TABLE IF NOT EXISTS user_progress (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            grade INT NOT NULL,
            chapter_id TEXT NOT NULL,
            chapter_title TEXT NOT NULL,
            score INT NOT NULL,
            completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );
        ''');

        // Seed dev user if not exists
        final devCheck = await conn.execute(
          Sql.named('SELECT id FROM users WHERE email = @email'),
          parameters: {'email': 'dev@example.com'},
        );

        if (devCheck.isEmpty) {
          await conn.execute(
            Sql.named('''
              INSERT INTO users (id, email, username, password, full_name, role)
              VALUES (@id, @email, @username, @password, @fullName, @role)
            '''),
            parameters: {
              'id': 'dev-user-001',
              'email': 'dev@example.com',
              'username': 'dev',
              'password': 'dev123',
              'fullName': 'Developer (Dev)',
              'role': 'developer',
            },
          );

          // Seed progress records for dev user
          final seedItems = [
            (id: 'prog-001', grade: 1, cId: 'greeting', cTitle: 'Greeting & Salam', score: 100),
            (id: 'prog-002', grade: 1, cId: 'animals', cTitle: 'Cute Animals', score: 90),
            (id: 'prog-003', grade: 1, cId: 'colors', cTitle: 'Bright Colors', score: 85),
            (id: 'prog-004', grade: 1, cId: 'numbers', cTitle: 'My Numbers 1-10', score: 100),
            (id: 'prog-005', grade: 1, cId: 'fruits', cTitle: 'Fresh Fruits', score: 95),
          ];

          for (final item in seedItems) {
            await conn.execute(
              Sql.named('''
                INSERT INTO user_progress (id, user_id, grade, chapter_id, chapter_title, score)
                VALUES (@id, @userId, @grade, @chapterId, @chapterTitle, @score)
                ON CONFLICT (id) DO NOTHING
              '''),
              parameters: {
                'id': item.id,
                'userId': 'dev-user-001',
                'grade': item.grade,
                'chapterId': item.cId,
                'chapterTitle': item.cTitle,
                'score': item.score,
              },
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error initializing Neon DB: $e');
    } finally {
      await conn?.close();
      _isInitialized = true;
    }
  }

  Future<NeonUser?> login(String emailOrUsername, String password) async {
    await initDbAndSeed();

    final cleanInput = emailOrUsername.trim().toLowerCase();

    // Dev shortcut check
    if (cleanInput == 'dev' || cleanInput == 'dev@example.com') {
      if (password.trim() == 'dev123' || password.isEmpty) {
        final devUser = NeonUser(
          id: 'dev-user-001',
          email: 'dev@example.com',
          username: 'dev',
          fullName: 'Developer (Dev)',
          role: 'developer',
        );
        await _saveUserSession(devUser);
        _currentUser = devUser;
        return devUser;
      }
    }

    Connection? conn;
    try {
      conn = await _getConnection();
      if (conn != null) {
        final result = await conn.execute(
          Sql.named('''
            SELECT id, email, username, full_name, role
            FROM users
            WHERE (LOWER(email) = @input OR LOWER(username) = @input)
              AND password = @password
          '''),
          parameters: {
            'input': cleanInput,
            'password': password.trim(),
          },
        );

        if (result.isNotEmpty) {
          final row = result.first;
          final user = NeonUser(
            id: row[0] as String,
            email: row[1] as String,
            username: row[2] as String,
            fullName: row[3] as String,
            role: row[4] as String,
          );
          await _saveUserSession(user);
          _currentUser = user;
          return user;
        }
      }
    } catch (e) {
      debugPrint('DB Login error: $e');
    } finally {
      await conn?.close();
    }

    // Fallback if DB is offline but dev credentials matched
    if ((cleanInput == 'dev' || cleanInput == 'dev@example.com') &&
        (password.trim() == 'dev123' || password.isEmpty)) {
      final devUser = NeonUser(
        id: 'dev-user-001',
        email: 'dev@example.com',
        username: 'dev',
        fullName: 'Developer (Dev)',
        role: 'developer',
      );
      await _saveUserSession(devUser);
      _currentUser = devUser;
      return devUser;
    }

    return null;
  }

  Future<List<NeonUserProgress>> getUserProgress(String userId) async {
    await initDbAndSeed();
    Connection? conn;
    try {
      conn = await _getConnection();
      if (conn != null) {
        final result = await conn.execute(
          Sql.named('''
            SELECT id, user_id, grade, chapter_id, chapter_title, score, completed_at
            FROM user_progress
            WHERE user_id = @userId
            ORDER BY completed_at DESC
          '''),
          parameters: {'userId': userId},
        );

        if (result.isNotEmpty) {
          return result.map((row) {
            final rawDate = row[6];
            DateTime dateVal;
            if (rawDate is DateTime) {
              dateVal = rawDate;
            } else if (rawDate != null) {
              dateVal = DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
            } else {
              dateVal = DateTime.now();
            }

            return NeonUserProgress(
              id: row[0] as String,
              userId: row[1] as String,
              grade: (row[2] as num).toInt(),
              chapterId: row[3] as String,
              chapterTitle: row[4] as String,
              score: (row[5] as num).toInt(),
              completedAt: dateVal,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error getting progress from Neon DB: $e');
    } finally {
      await conn?.close();
    }

    // Fallback to local seed progress if DB query returns empty or failed
    if (userId == 'dev-user-001') {
      return _fallbackDevProgress;
    }
    return [];
  }

  Future<bool> saveProgress({
    required String userId,
    required int grade,
    required String chapterId,
    required String chapterTitle,
    required int score,
  }) async {
    final progId = 'prog-${DateTime.now().millisecondsSinceEpoch}';
    final newProgress = NeonUserProgress(
      id: progId,
      userId: userId,
      grade: grade,
      chapterId: chapterId,
      chapterTitle: chapterTitle,
      score: score,
      completedAt: DateTime.now(),
    );

    // Save to local fallback first
    if (userId == 'dev-user-001') {
      _fallbackDevProgress.removeWhere((p) => p.chapterId == chapterId);
      _fallbackDevProgress.insert(0, newProgress);
    }

    Connection? conn;
    try {
      conn = await _getConnection();
      if (conn != null) {
        await conn.execute(
          Sql.named('''
            INSERT INTO user_progress (id, user_id, grade, chapter_id, chapter_title, score)
            VALUES (@id, @userId, @grade, @chapterId, @chapterTitle, @score)
          '''),
          parameters: {
            'id': progId,
            'userId': userId,
            'grade': grade,
            'chapterId': chapterId,
            'chapterTitle': chapterTitle,
            'score': score,
          },
        );
        return true;
      }
    } catch (e) {
      debugPrint('Error saving progress to Neon DB: $e');
    } finally {
      await conn?.close();
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    Connection? conn;
    try {
      conn = await _getConnection();
      if (conn != null) {
        final result = await conn.execute('''
          SELECT u.username, u.full_name, COALESCE(SUM(p.score), 0) as total_xp
          FROM users u
          LEFT JOIN user_progress p ON u.id = p.user_id
          GROUP BY u.id, u.username, u.full_name
          ORDER BY total_xp DESC
          LIMIT 10
        ''');

        if (result.isNotEmpty) {
          final List<Map<String, dynamic>> remoteList = [];
          for (int i = 0; i < result.length; i++) {
            final row = result[i];
            final totalXp = (row[2] as num).toInt();
            remoteList.add({
              'rank': i + 1,
              'name': (row[1] ?? row[0] ?? 'Siswa').toString(),
              'avatar': '👦',
              'xp': totalXp,
              'level': (totalXp / 100).floor() + 1,
            });
          }
          return remoteList;
        }
      }
    } catch (e) {
      debugPrint('Error querying leaderboard from Neon DB: $e');
    } finally {
      await conn?.close();
    }

    return await DatabaseRepository.instance.getLeaderboardEntries();
  }

  Future<void> _saveUserSession(NeonUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_user_id', user.id);
    await prefs.setString('logged_user_email', user.email);
    await prefs.setString('logged_user_username', user.username);
    await prefs.setString('logged_user_name', user.fullName);
    await prefs.setString('logged_user_role', user.role);
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user_id');
    await prefs.remove('logged_user_email');
    await prefs.remove('logged_user_username');
    await prefs.remove('logged_user_name');
    await prefs.remove('logged_user_role');
  }
}
