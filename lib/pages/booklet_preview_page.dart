import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_content.dart';
import '../services/gemini_audio_service.dart';
import '../shared/animations/scale_animation.dart';
import '../shared/animations/slide_animation.dart';
import 'game_play_page.dart';

class BookletPreviewPage extends StatelessWidget {
  final int grade;
  final int chapterIndex;
  final int totalChapters;
  final ChapterGameData chapterData;

  const BookletPreviewPage({
    super.key,
    required this.grade,
    required this.chapterIndex,
    required this.totalChapters,
    required this.chapterData,
  });

  void _onStartGame(BuildContext context) {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GamePlayPage(
          grade: grade,
          chapterData: chapterData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0BEC5),
      body: Stack(
        children: [
          // Main Content Area (Edge-to-Edge with floating overlay)
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 10, right: 10, bottom: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isPortrait = constraints.maxHeight > constraints.maxWidth;

                    Widget descriptionBox = Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EAF6),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'BAB $chapterIndex: ${chapterData.chapterTitle}',
                                  style: const TextStyle(
                                    color: Color(0xFF1E88E5), // Explicit High Contrast Dark Blue Title
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF1E88E5), width: 1),
                                ),
                                child: Text(
                                  '${chapterData.questions.length} SOAL',
                                  style: const TextStyle(
                                    color: Color(0xFF1E88E5),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            chapterData.chapterDescription.isNotEmpty
                                ? '${chapterData.chapterDescription}. Materi ini dirancang interaktif untuk melatih pemahaman Bahasa Inggris SD!'
                                : 'Materi pembelajaran Bahasa Inggris interaktif untuk anak SD.',
                            style: const TextStyle(
                              color: Color(0xFF222222), // Explicit Sharp Dark Body Text
                              fontSize: 13,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );

                    Widget questionsBox = Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Soal & Tantangan',
                              style: TextStyle(
                                color: Color(0xFFD81B60), // High Contrast Dark Pink Header
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: ListView.separated(
                                itemCount: chapterData.questions.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 6),
                                itemBuilder: (context, index) {
                                  final item = chapterData.questions[index];
                                  return _buildQuestionChip(item, index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: SlideAnimation(
                            direction: SlideDirection.fromBottom,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                    color: const Color(0xFF1E88E5), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: isPortrait
                                  ? Column(
                                      children: [
                                        descriptionBox,
                                        questionsBox,
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(flex: 2, child: descriptionBox),
                                        Container(
                                          width: 1,
                                          color: const Color(0xFFE0E0E0),
                                        ),
                                        Expanded(flex: 3, child: questionsBox),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
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
                            color: Colors.black.withValues(alpha: 0.2),
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
                      border: Border.all(color: const Color(0xFF1E88E5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Detail Bab $chapterIndex',
                      style: const TextStyle(
                        color: Color(0xFF1E88E5),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom-Right Floating Action Button ("Mulai Game")
          Positioned(
            bottom: 16,
            right: 16,
            child: SafeArea(
              child: ScaleAnimation(
                onTap: () => _onStartGame(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE24379), Color(0xFFFF5252)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE24379).withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Mulai Game',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionChip(GameQuestion q, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ${q.prompt.isNotEmpty ? q.prompt : q.targetAnswer}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF1E88E5), // Sharp contrast blue
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Tipe: ${q.type.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (q.targetAnswer.isNotEmpty)
            ScaleAnimation(
              onTap: () {
                HapticFeedback.selectionClick();
                GeminiAudioService.instance.speak(q.targetAnswer);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E88E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
