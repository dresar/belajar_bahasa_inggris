import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/scale_animation.dart';
import '../animations/slide_animation.dart';

class MemoryCardItem {
  final int id;
  final String text;
  final String pairId; // Same pair ID for matching cards
  bool isFlipped;
  bool isMatched;

  MemoryCardItem({
    required this.id,
    required this.text,
    required this.pairId,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameWidget extends StatefulWidget {
  final String prompt;
  final List<String> leftWords;
  final List<String> rightWords;
  final Map<String, String> correctPairs;
  final Function(bool isCorrect) onAnswerSubmitted;

  const MemoryGameWidget({
    super.key,
    required this.prompt,
    required this.leftWords,
    required this.rightWords,
    required this.correctPairs,
    required this.onAnswerSubmitted,
  });

  @override
  State<MemoryGameWidget> createState() => _MemoryGameWidgetState();
}

class _MemoryGameWidgetState extends State<MemoryGameWidget> {
  late List<MemoryCardItem> _cards;
  int? _firstSelectedIndex;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _initCards() {
    _cards = [];
    int idCounter = 0;

    for (int i = 0; i < widget.leftWords.length; i++) {
      final left = widget.leftWords[i];
      final right = widget.correctPairs[left] ??
          (i < widget.rightWords.length ? widget.rightWords[i] : '');

      _cards.add(MemoryCardItem(
          id: idCounter++, text: left, pairId: 'pair-$i'));
      _cards.add(MemoryCardItem(
          id: idCounter++, text: right, pairId: 'pair-$i'));
    }

    _cards.shuffle();
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched) {
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      final firstIdx = _firstSelectedIndex!;
      _firstSelectedIndex = null;
      _isProcessing = true;

      final card1 = _cards[firstIdx];
      final card2 = _cards[index];

      if (card1.pairId == card2.pairId) {
        HapticFeedback.mediumImpact();
        setState(() {
          card1.isMatched = true;
          card2.isMatched = true;
          _isProcessing = false;
        });

        if (_cards.every((c) => c.isMatched)) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) widget.onAnswerSubmitted(true);
          });
        }
      } else {
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              card1.isFlipped = false;
              card2.isFlipped = false;
              _isProcessing = false;
            });
          }
        });
      }
    }
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE65100), Color(0xFFFB8C00)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.style_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  widget.prompt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cards Grid
          Expanded(
            child: GridView.builder(
              itemCount: _cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final card = _cards[index];
                return ScaleAnimation(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: card.isMatched
                          ? const Color(0xFFC8E6C9)
                          : card.isFlipped
                              ? Colors.white
                              : const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(18),
                      border: card.isMatched
                          ? Border.all(color: const Color(0xFF4CAF50), width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: card.isFlipped || card.isMatched
                          ? Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                card.text,
                                style: TextStyle(
                                  color: card.isMatched
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFF1565C0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const Icon(
                              Icons.question_mark_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
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
