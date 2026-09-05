import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/scale_animation.dart';
import '../animations/slide_animation.dart';

class UnscrambleGameWidget extends StatefulWidget {
  final String prompt;
  final String targetAnswer;
  final List<String> shuffledLetters;
  final Function(bool isCorrect) onAnswerSubmitted;

  const UnscrambleGameWidget({
    super.key,
    required this.prompt,
    required this.targetAnswer,
    required this.shuffledLetters,
    required this.onAnswerSubmitted,
  });

  @override
  State<UnscrambleGameWidget> createState() => _UnscrambleGameWidgetState();
}

class _UnscrambleGameWidgetState extends State<UnscrambleGameWidget> {
  final List<int> _selectedIndices = [];

  String get _formedWord =>
      _selectedIndices.map((idx) => widget.shuffledLetters[idx]).join();

  void _onLetterTap(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _checkAnswer() {
    final cleanFormed = _formedWord.trim().toLowerCase();
    final cleanTarget = widget.targetAnswer.trim().toLowerCase();
    final isCorrect = cleanFormed == cleanTarget;

    if (isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    widget.onAnswerSubmitted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Title Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E24AA).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sort_by_alpha_rounded,
                        color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Unscramble Word (Susun Huruf)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.prompt,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Answer Display Box
          Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFAB47BC), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: _selectedIndices.isEmpty
                  ? const Text(
                      'Ketuk huruf di bawah untuk menyusun...',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _selectedIndices.map((idx) {
                          final char = widget.shuffledLetters[idx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ScaleAnimation(
                              onTap: () => _onLetterTap(idx),
                              child: Container(
                                width: 44,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFF8E24AA), width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    char.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF8E24AA),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Shuffled Letter Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(widget.shuffledLetters.length, (index) {
              final isUsed = _selectedIndices.contains(index);
              final char = widget.shuffledLetters[index];

              return ScaleAnimation(
                onTap: () => _onLetterTap(index),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isUsed ? 0.3 : 1.0,
                  child: Container(
                    width: 52,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        char.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Spacer(),

          // Submit Answer Button
          if (_selectedIndices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _checkAnswer,
                  child: const Text(
                    'Periksa Jawaban',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
