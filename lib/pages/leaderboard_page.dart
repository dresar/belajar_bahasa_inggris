import 'package:flutter/material.dart';
import '../services/database_repository.dart';
import '../services/theme_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> _leaderboardList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    final list = await DatabaseRepository.instance.getLeaderboardEntries();
    if (mounted) {
      setState(() {
        _leaderboardList = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemeService.instance.currentPalette;

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏆 ', style: TextStyle(fontSize: 26)),
                      const Text(
                        'PAPAN PERINGKAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Peringkat Siswa SD Terhebat Dalam Belajar Bahasa Inggris!',
                    style: TextStyle(
                      color: Color(0xFFE1BEE7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Main Leaderboard List Area
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadLeaderboard,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _leaderboardList.length,
                        itemBuilder: (context, index) {
                          final item = _leaderboardList[index];
                          final rank = item['rank'] as int;
                          final isUser = (item['name'] as String).contains('Kamu');

                          String medalEmoji = '#$rank';
                          Color rankColor = const Color(0xFF757575);

                          if (rank == 1) {
                            medalEmoji = '🥇';
                            rankColor = const Color(0xFFFFD54F);
                          } else if (rank == 2) {
                            medalEmoji = '🥈';
                            rankColor = const Color(0xFFCFD8DC);
                          } else if (rank == 3) {
                            medalEmoji = '🥉';
                            rankColor = const Color(0xFFFF8A65);
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isUser ? const Color(0xFFFFF8E1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isUser ? const Color(0xFFFFB300) : Colors.grey.withValues(alpha: 0.2),
                                width: isUser ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Rank Medal / Number
                                SizedBox(
                                  width: 36,
                                  child: rank <= 3
                                      ? Text(medalEmoji, style: const TextStyle(fontSize: 24))
                                      : Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: rankColor.withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$rank',
                                            style: TextStyle(
                                              color: rankColor,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 10),

                                // Avatar Emoji
                                Text(item['avatar'] ?? '👦', style: const TextStyle(fontSize: 26)),
                                const SizedBox(width: 12),

                                // User Name & Level
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] ?? 'Siswa',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14.5,
                                          color: isUser ? const Color(0xFFE65100) : const Color(0xFF222222),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Level ${item['level'] ?? 1}',
                                        style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // XP Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${item['xp']} XP',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
