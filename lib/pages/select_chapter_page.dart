import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_content.dart';
import '../services/background_music_service.dart';
import '../services/theme_service.dart';
import '../services/xp_service.dart';
import '../shared/animations/scale_animation.dart';
import '../shared/animations/slide_animation.dart';
import 'game_play_page.dart';
import 'vocabulary_page.dart';

class SelectChapterPage extends StatelessWidget {
  final int grade;

  const SelectChapterPage({
    super.key,
    required this.grade,
  });

  static const List<String> _chapterEmojis = [
    '💬',
    '🔢',
    '🎨',
    '🐱',
    '👨‍👩‍👧',
    '🍎',
    '✏️',
    '🏆',
  ];

  @override
  Widget build(BuildContext context) {
    final chapters = GameRepository.getGradeChapters(grade);
    final palette = ThemeService.instance.currentPalette;

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: ValueListenableBuilder<int>(
        valueListenable: XpService.instance.progressNotifier,
        builder: (context, _, child) {
          int completedCount = 0;
          int totalExpEarned = 0;

          for (int i = 0; i < chapters.length; i++) {
            final chapterData = GameRepository.getChapterData(grade, i);
            if (XpService.instance.isChapterCompleted(chapterData.chapterId)) {
              completedCount++;
              totalExpEarned += XpService.instance.getChapterExp(chapterData.chapterId);
            }
          }

          final progressRatio = chapters.isEmpty ? 0.0 : (completedCount / chapters.length);

          return Stack(
            children: [
              // Chapter List Cards Area (Edge-to-Edge with floating overlay)
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48, left: 12, right: 12, bottom: 6),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isPortrait = constraints.maxHeight > constraints.maxWidth;

                        return ListView.separated(
                          scrollDirection:
                              isPortrait ? Axis.vertical : Axis.horizontal,
                          itemCount: chapters.length + 2, // 0: Progress Header, 1: Vocabulary, 2+: Chapters
                          separatorBuilder: (_, _) => SizedBox(
                            width: isPortrait ? 0 : 12,
                            height: isPortrait ? 12 : 0,
                          ),
                          itemBuilder: (context, index) {
                            // Index 0: Progress & EXP Summary Card
                            if (index == 0) {
                              return Container(
                                width: isPortrait ? double.infinity : 220,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text('📊 ', style: TextStyle(fontSize: 18)),
                                            Text(
                                              'PROGRES KELAS $grade',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 13,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '🏆 +$totalExpEarned EXP',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: progressRatio,
                                        minHeight: 10,
                                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD54F)),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$completedCount dari ${chapters.length} Bab Selesai',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                        Text(
                                          '${(progressRatio * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Color(0xFFFFD54F),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Index 1: Bank Kosakata (Materi Paling Awal!)
                            if (index == 1) {
                              return SlideAnimation(
                                direction: isPortrait
                                    ? SlideDirection.fromBottom
                                    : SlideDirection.fromRight,
                                child: ScaleAnimation(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => VocabularyPage(grade: grade),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: isPortrait ? double.infinity : 220,
                                    height: isPortrait ? 145 : null,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Color(0xFFF3E5F5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(0xFF8E24AA),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.purple.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // Card Top Header
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)],
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Text(
                                                  'MATERI AWAL',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 11,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                              const Text('📖', style: TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ),

                                        // Card Body Content
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        '📚 Bank Kosakata & Cara Membaca',
                                                        style: TextStyle(
                                                          color: Color(0xFF8E24AA),
                                                          fontWeight: FontWeight.w900,
                                                          fontSize: 15,
                                                          height: 1.2,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 3),
                                                      const Text(
                                                        'Pelajari ejaan, audio pengucapan & ejaan Bahasa Indonesia',
                                                        style: TextStyle(
                                                          color: Color(0xFF555555),
                                                          fontSize: 11,
                                                          height: 1.2,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Wrap(
                                                        spacing: 4,
                                                        runSpacing: 4,
                                                        children: [
                                                          _buildBadge(
                                                              '🔊 AUDIO AI', const Color(0xFF8E24AA)),
                                                          _buildBadge('🇮🇩 CARA BACA',
                                                              const Color(0xFF1E88E5)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 12, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [
                                                        Color(0xFF8E24AA),
                                                        Color(0xFFAB47BC),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.menu_book_rounded,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Buka',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w900,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Chapter index offset by 2
                            final chapterIndex = index - 2;
                            final item = chapters[chapterIndex];
                            final emoji = _chapterEmojis[chapterIndex % _chapterEmojis.length];
                            final chapterData = GameRepository.getChapterData(grade, chapterIndex);
                            final isCompleted = XpService.instance.isChapterCompleted(chapterData.chapterId);
                            final earnedExp = XpService.instance.getChapterExp(chapterData.chapterId);

                            return SlideAnimation(
                              direction: isPortrait
                                  ? SlideDirection.fromBottom
                                  : SlideDirection.fromRight,
                              child: ScaleAnimation(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  if (isCompleted) {
                                    _showReplayDialog(context, grade, chapterData, earnedExp);
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => GamePlayPage(
                                          grade: grade,
                                          chapterData: chapterData,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: isPortrait ? double.infinity : 220,
                                  height: isPortrait ? 145 : null,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white,
                                        isCompleted
                                            ? const Color(0xFFE8F5E9)
                                            : item.topColor.withValues(alpha: 0.12),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: isCompleted
                                          ? const Color(0xFF43A047)
                                          : item.topColor.withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isCompleted
                                            ? Colors.green.withValues(alpha: 0.2)
                                            : item.topColor.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Card Top Header
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isCompleted
                                                ? [const Color(0xFF2E7D32), const Color(0xFF43A047)]
                                                : [item.topColor, item.topColor.withValues(alpha: 0.85)],
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'BAB ${chapterIndex + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 11,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              emoji,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Card Main Content
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      item.title,
                                                      style: TextStyle(
                                                        color: isCompleted
                                                            ? const Color(0xFF1B5E20)
                                                            : item.topColor,
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 16,
                                                        height: 1.2,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      item.description,
                                                      style: const TextStyle(
                                                        color: Color(0xFF555555),
                                                        fontSize: 11,
                                                        height: 1.2,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      spacing: 4,
                                                      runSpacing: 4,
                                                      children: [
                                                        if (isCompleted)
                                                          _buildBadge(
                                                              '✅ SELESAI (+$earnedExp EXP)',
                                                              const Color(0xFF2E7D32))
                                                        else
                                                          _buildBadge(
                                                              '🏆 REWARD +150 EXP',
                                                              const Color(0xFFE65100)),
                                                        _buildBadge('🎮 11 GAME',
                                                            const Color(0xFF1565C0)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 8),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: isCompleted
                                                        ? [
                                                            const Color(0xFF2E7D32),
                                                            const Color(0xFF43A047),
                                                          ]
                                                        : [
                                                            palette.primaryColor,
                                                            palette.secondaryColor,
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      isCompleted
                                                          ? Icons.replay_rounded
                                                          : Icons.play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      isCompleted ? 'Ulangi' : 'Mulai',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Top Floating Back Button (Top Left) & Title Badge (Pure Overlay)
              Positioned(
                top: 10,
                left: 12,
                child: SafeArea(
                  child: Row(
                    children: [
                      ScaleAnimation(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE24379),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Materi Kelas $grade',
                          style: TextStyle(
                            color: palette.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Right Floating BGM Music Button (Compact & Out of the way!)
              const Positioned(
                bottom: 16,
                right: 16,
                child: SafeArea(
                  child: BgmToggleButton(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReplayDialog(
      BuildContext context, int grade, ChapterGameData chapterData, int currentExp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Text('🔄 ', style: TextStyle(fontSize: 24)),
              Expanded(
                child: Text(
                  'Ulangi Materi Ini?',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF43A047)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF2E7D32), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status: Selesai (Diselesaikan +$currentExp EXP)',
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Materi ini sudah kamu selesaikan sebelumnya.\n\n⚠️ CATATAN PENTING:\nJika kamu mengulang materi ini, nilai EXP kamu akan direset dan diperbarui sesuai skor kuis barumu!',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF333333),
                  height: 1.35,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GamePlayPage(
                      grade: grade,
                      chapterData: chapterData,
                    ),
                  ),
                );
              },
              child: const Text(
                '🚀 Ya, Ulangi!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 9.5,
        ),
      ),
    );
  }
}
