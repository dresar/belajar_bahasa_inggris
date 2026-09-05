import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/scale_animation.dart';
import '../animations/slide_animation.dart';

class BossBattleWidget extends StatefulWidget {
  final String prompt;
  final String bossName;
  final int bossHp;
  final String targetAnswer;
  final List<String> options;
  final Function(bool isCorrect) onAnswerSubmitted;

  const BossBattleWidget({
    super.key,
    required this.prompt,
    required this.bossName,
    required this.bossHp,
    required this.targetAnswer,
    required this.options,
    required this.onAnswerSubmitted,
  });

  @override
  State<BossBattleWidget> createState() => _BossBattleWidgetState();
}

class _BossBattleWidgetState extends State<BossBattleWidget>
    with SingleTickerProviderStateMixin {
  late int _currentHp;
  int? _selectedOption;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _currentHp = widget.bossHp;
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: -8, end: 8)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onAttack(int index) {
    HapticFeedback.heavyImpact();
    setState(() => _selectedOption = index);

    final isCorrect =
        widget.options[index].trim().toLowerCase() ==
            widget.targetAnswer.trim().toLowerCase();

    if (isCorrect) {
      _shakeController.forward(from: 0.0);
      setState(() {
        _currentHp = (_currentHp - 50).clamp(0, widget.bossHp);
      });
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) widget.onAnswerSubmitted(isCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hpPercent = (_currentHp / widget.bossHp).clamp(0.0, 1.0);

    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          // Compact Boss HP Bar (No giant banner!)
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB71C1C),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text('🐉', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.bossName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'HP $_currentHp / ${widget.bossHp}',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: hpPercent,
                                minHeight: 10,
                                backgroundColor: Colors.black45,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFD54F)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Question Text Box Prominently Near Top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB71C1C), width: 2),
            ),
            child: Text(
              widget.prompt,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14),

          // Answer Options Laid Out Horizontally / Grid 2x2 (Kekanan Panjang)
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final isSelected = _selectedOption == index;
                final opt = widget.options[index];

                return ScaleAnimation(
                  onTap: () => _onAttack(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD32F2F)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFB71C1C),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF333333),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
