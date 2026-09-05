import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/background_music_service.dart';
import '../services/theme_service.dart';
import '../services/xp_service.dart';
import '../shared/animations/scale_animation.dart';
import '../shared/animations/slide_animation.dart';
import '../shared/widgets/exp_details_dialog.dart';
import 'select_chapter_page.dart';
import 'settings_page.dart';

class SelectGradePage extends StatefulWidget {
  const SelectGradePage({super.key});

  @override
  State<SelectGradePage> createState() => _SelectGradePageState();
}

class _SelectGradePageState extends State<SelectGradePage> {
  @override
  void initState() {
    super.initState();
    XpService.instance.init().then((_) {
      if (mounted) setState(() {});
    });
  }

  static final List<({
    int grade,
    String title,
    Color color,
    Color color2,
    IconData icon,
    String emoji,
    String? imageAsset,
  })> _grades = [
    (
      grade: 1,
      title: 'KELAS 1',
      color: const Color(0xFF1E88E5),
      color2: const Color(0xFF1565C0),
      icon: Icons.toys_rounded,
      emoji: '🧸',
      imageAsset: 'assets/images/grades/grade_1.png',
    ),
    (
      grade: 2,
      title: 'KELAS 2',
      color: const Color(0xFFFB8C00),
      color2: const Color(0xFFEF6C00),
      icon: Icons.menu_book_rounded,
      emoji: '🎒',
      imageAsset: 'assets/images/grades/grade_2.png',
    ),
    (
      grade: 3,
      title: 'KELAS 3',
      color: const Color(0xFF43A047),
      color2: const Color(0xFF2E7D32),
      icon: Icons.headphones_rounded,
      emoji: '🎧',
      imageAsset: 'assets/images/grades/grade_3.png',
    ),
    (
      grade: 4,
      title: 'KELAS 4',
      color: const Color(0xFF8E24AA),
      color2: const Color(0xFF6A1B9A),
      icon: Icons.record_voice_over_rounded,
      emoji: '🚀',
      imageAsset: 'assets/images/grades/grade_4.png',
    ),
    (
      grade: 5,
      title: 'KELAS 5',
      color: const Color(0xFF00ACC1),
      color2: const Color(0xFF00838F),
      icon: Icons.school_rounded,
      emoji: '🗺️',
      imageAsset: 'assets/images/grades/grade_5.png',
    ),
    (
      grade: 6,
      title: 'KELAS 6',
      color: const Color(0xFFE53935),
      color2: const Color(0xFFC62828),
      icon: Icons.create_rounded,
      emoji: '👑',
      imageAsset: 'assets/images/grades/grade_6.png',
    ),
  ];

  void _onSelectGrade(BuildContext context, int grade) {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SelectChapterPage(grade: grade),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemeService.instance.currentPalette;
    final xp = XpService.instance.totalXp;
    final lvl = XpService.instance.level;

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: Stack(
        children: [
          // Main Cards Grid Area (Edge-to-Edge)
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 12, right: 12, bottom: 6),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape =
                        constraints.maxWidth > constraints.maxHeight;
                    final crossAxisCount = isLandscape ? 3 : 2;

                    return GridView.builder(
                      physics: isLandscape
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      itemCount: _grades.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: isLandscape ? 1.75 : 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final item = _grades[index];
                        final hasImage = item.imageAsset != null;

                        return SlideAnimation(
                          direction: SlideDirection.fromBottom,
                          delay: Duration(milliseconds: index * 60),
                          child: ScaleAnimation(
                            onTap: () => _onSelectGrade(context, item.grade),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [item.color, item.color2],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    if (hasImage) ...[
                                      Positioned.fill(
                                        child: Image.asset(
                                          item.imageAsset!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        height: 60,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.black.withValues(alpha: 0.5),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Positioned(
                                        left: -10,
                                        bottom: -10,
                                        child: Icon(
                                          item.icon,
                                          size: 64,
                                          color: Colors.white.withValues(alpha: 0.18),
                                        ),
                                      ),
                                    ],

                                    // Top Left Emoji
                                    Positioned(
                                      left: 12,
                                      top: 10,
                                      child: Text(
                                        item.emoji,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Top Right Animated Grade Badge
                                    Positioned(
                                      right: 12,
                                      top: 10,
                                      child: AnimatedGradeBadge(
                                        grade: item.grade,
                                        emoji: item.emoji,
                                      ),
                                    ),
                                  ],
                                ),
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

            // Top Floating XP Badge (Top Left - Clickable EXP Details Modal!)
            Positioned(
              top: 10,
              left: 12,
              child: SafeArea(
                child: ScaleAnimation(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ExpDetailsDialog.show(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Color(0xFFFFB300),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$xp XP',
                          style: const TextStyle(
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Lv.$lvl',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top Floating Action Buttons (Top Right: Settings)
            Positioned(
              top: 10,
              right: 12,
              child: SafeArea(
                child: Row(
                  children: [
                    ScaleAnimation(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.settings_rounded,
                          color: Color(0xFF555555),
                          size: 18,
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
        ),
      );
  }
}

class AnimatedGradeBadge extends StatefulWidget {
  final int grade;
  final String emoji;

  const AnimatedGradeBadge({
    super.key,
    required this.grade,
    required this.emoji,
  });

  @override
  State<AnimatedGradeBadge> createState() => _AnimatedGradeBadgeState();
}

class _AnimatedGradeBadgeState extends State<AnimatedGradeBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        ),
        child: Text(
          'KELAS ${widget.grade}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
