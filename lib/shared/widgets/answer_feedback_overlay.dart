import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AnswerFeedbackOverlay extends StatefulWidget {
  final bool isCorrect;
  final String title;
  final String subtitle;
  final int xpAmount;
  final VoidCallback onContinue;

  const AnswerFeedbackOverlay({
    super.key,
    required this.isCorrect,
    required this.title,
    required this.subtitle,
    required this.xpAmount,
    required this.onContinue,
  });

  static Future<void> show({
    required BuildContext context,
    required bool isCorrect,
    required String title,
    required String subtitle,
    required int xpAmount,
    required VoidCallback onContinue,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AnswerFeedbackOverlay(
        isCorrect: isCorrect,
        title: title,
        subtitle: subtitle,
        xpAmount: xpAmount,
        onContinue: () {
          Navigator.of(ctx).pop();
          onContinue();
        },
      ),
    );
  }

  @override
  State<AnswerFeedbackOverlay> createState() => _AnswerFeedbackOverlayState();
}

class _AnswerFeedbackOverlayState extends State<AnswerFeedbackOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: -12, end: 12)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleController.forward();

    if (widget.isCorrect) {
      HapticFeedback.mediumImpact();
      _playAudio('assets/audio/correct.mp3');
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.forward();
      _playAudio('assets/audio/wrong.mp3');
    }
  }

  void _playAudio(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(assetPath);
      await player.play();
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.isCorrect
        ? const Color(0xFF2E7D32)
        : const Color(0xFFD84315);

    final bgGradient = widget.isCorrect
        ? const [Color(0xFF4CAF50), Color(0xFF2E7D32)]
        : const [Color(0xFFFF7043), Color(0xFFD84315)];

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Stack(
        children: [
          // Particle burst background for correct answers
          if (widget.isCorrect)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticleBurstPainter(_particleController.value),
                  );
                },
              ),
            ),

          Center(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(widget.isCorrect ? 0 : _shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge Icon with Glowing Circle
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: bgGradient),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            widget.isCorrect
                                ? Icons.stars_rounded
                                : Icons.sentiment_dissatisfied_rounded,
                            color: Colors.white,
                            size: 54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // XP Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.isCorrect
                              ? const Color(0xFFFFF8E1)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isCorrect
                                  ? Icons.star_rounded
                                  : Icons.favorite_rounded,
                              color: widget.isCorrect
                                  ? const Color(0xFFFF8F00)
                                  : const Color(0xFFE53935),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '+${widget.xpAmount} XP',
                              style: TextStyle(
                                color: widget.isCorrect
                                    ? const Color(0xFFFF8F00)
                                    : const Color(0xFFE53935),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: widget.onContinue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isCorrect ? 'Lanjut' : 'Coba Lagi / Lanjut',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 24),
                            ],
                          ),
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
}

class ParticleBurstPainter extends CustomPainter {
  final double progress;
  final List<Particle> particles = List.generate(24, (i) => Particle());

  ParticleBurstPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rand = Random(42);

    for (int i = 0; i < particles.length; i++) {
      final angle = (i / particles.length) * 2 * pi;
      final dist = (progress * 220) + (rand.nextDouble() * 40);
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist - (progress * 50);

      final paint = Paint()
        ..color = Color.lerp(
          Colors.amber,
          Colors.lightGreenAccent,
          rand.nextDouble(),
        )!.withValues(alpha: (1.0 - progress).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 5 + (rand.nextDouble() * 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBurstPainter oldDelegate) => true;
}

class Particle {
  final double x = 0;
  final double y = 0;
}
