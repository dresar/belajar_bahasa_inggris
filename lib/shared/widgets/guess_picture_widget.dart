import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/scale_animation.dart';
import '../animations/slide_animation.dart';

class GuessPictureWidget extends StatefulWidget {
  final String prompt;
  final String imageEmoji;
  final String targetAnswer;
  final List<String> options;
  final Function(bool isCorrect) onAnswerSubmitted;

  const GuessPictureWidget({
    super.key,
    required this.prompt,
    required this.imageEmoji,
    required this.targetAnswer,
    required this.options,
    required this.onAnswerSubmitted,
  });

  @override
  State<GuessPictureWidget> createState() => _GuessPictureWidgetState();
}

class _GuessPictureWidgetState extends State<GuessPictureWidget> {
  int? _selectedOption;

  void _onSelect(int index) {
    HapticFeedback.lightImpact();
    setState(() => _selectedOption = index);

    final isCorrect =
        widget.options[index].trim().toLowerCase() ==
            widget.targetAnswer.trim().toLowerCase();

    if (isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) widget.onAnswerSubmitted(isCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          // Super Compact Header with Inline Emoji & Prompt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFB300), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      widget.imageEmoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.prompt,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2-Column Side-by-Side Options Grid (No Scrolling Needed!)
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              itemBuilder: (context, index) {
                final isSelected = _selectedOption == index;
                final text = widget.options[index];

                return ScaleAnimation(
                  onTap: () => _onSelect(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : const Color(0xFFFFB300),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      text,
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
