import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/vocabularies/vocab_repository.dart';
import '../animations/scale_animation.dart';
import '../animations/slide_animation.dart';

class PuzzleDragMatchingWidget extends StatefulWidget {
  final int grade;
  final String prompt;
  final List<String> englishWords;
  final List<String> indonesianWords;
  final Map<String, String> correctPairs;
  final Function(bool isCorrect) onAnswerSubmitted;

  const PuzzleDragMatchingWidget({
    super.key,
    required this.grade,
    required this.prompt,
    required this.englishWords,
    required this.indonesianWords,
    required this.correctPairs,
    required this.onAnswerSubmitted,
  });

  @override
  State<PuzzleDragMatchingWidget> createState() =>
      _PuzzleDragMatchingWidgetState();
}

class _PuzzleDragMatchingWidgetState extends State<PuzzleDragMatchingWidget> {
  late List<String> _englishList;
  late Map<String, String> _mergedPairs;
  late List<String> _shuffledIndonesianList;
  
  final Map<String, String?> _matchedMap = {}; // english -> matched indonesian
  final Set<String> _matchedIndoSet = {}; // matched indonesian set

  String? _selectedEng;
  String? _selectedIndo;

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    _mergedPairs = {};

    // 1. FIRST PRIORITY: Always preserve correctPairs mapping (Ground Truth!)
    widget.correctPairs.forEach((eng, indo) {
      if (eng.isNotEmpty && indo.isNotEmpty) {
        _mergedPairs[eng] = indo;
      }
    });

    // 2. SECOND PRIORITY: Add englishWords if missing from correctPairs
    for (int i = 0; i < widget.englishWords.length; i++) {
      final eng = widget.englishWords[i];
      if (!_mergedPairs.containsKey(eng)) {
        if (i < widget.indonesianWords.length) {
          _mergedPairs[eng] = widget.indonesianWords[i];
        }
      }
    }

    // 3. THIRD PRIORITY: Guarantee AT LEAST 9 PAIRS using VocabRepository for grade
    if (_mergedPairs.length < 9) {
      final gradeVocabs = VocabRepository.getVocabForGrade(widget.grade);
      for (var vocab in gradeVocabs) {
        if (!_mergedPairs.containsKey(vocab.english) &&
            !_mergedPairs.containsValue(vocab.indonesian)) {
          _mergedPairs[vocab.english] = vocab.indonesian;
          if (_mergedPairs.length >= 9) break;
        }
      }
    }

    _englishList = _mergedPairs.keys.toList();
    _englishList.shuffle();

    _matchedMap.clear();
    _matchedIndoSet.clear();
    for (var eng in _englishList) {
      _matchedMap[eng] = null;
    }

    // 4. Build 100% Shuffled Indonesian List from exact _mergedPairs values!
    _shuffledIndonesianList = _englishList
        .map((eng) => _mergedPairs[eng]!)
        .where((indo) => indo.isNotEmpty)
        .toList();
    _shuffledIndonesianList.shuffle();
  }

  void _onEngSelected(String eng) {
    if (_matchedMap[eng] != null) return; // Already solved

    HapticFeedback.selectionClick();
    setState(() {
      _selectedEng = (_selectedEng == eng) ? null : eng;
    });

    _checkMatchIfBothSelected();
  }

  void _onIndoSelected(String indo) {
    if (_matchedIndoSet.contains(indo)) return; // Already solved

    HapticFeedback.selectionClick();
    setState(() {
      _selectedIndo = (_selectedIndo == indo) ? null : indo;
    });

    _checkMatchIfBothSelected();
  }

  void _checkMatchIfBothSelected() {
    if (_selectedEng != null && _selectedIndo != null) {
      final eng = _selectedEng!;
      final indo = _selectedIndo!;
      final expectedIndo = _mergedPairs[eng];

      final isCorrect = (expectedIndo != null &&
              expectedIndo.trim().toLowerCase() == indo.trim().toLowerCase()) ||
          eng.trim().toLowerCase() == indo.trim().toLowerCase();

      if (isCorrect) {
        HapticFeedback.mediumImpact();
        setState(() {
          _matchedMap[eng] = indo;
          _matchedIndoSet.add(indo);
          _selectedEng = null;
          _selectedIndo = null;
        });

        // Check if all pairs solved
        if (_matchedMap.values.every((v) => v != null)) {
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) widget.onAnswerSubmitted(true);
          });
        }
      } else {
        // Quiet non-intrusive deselect without harsh red error popups!
        HapticFeedback.lightImpact();
        setState(() {
          _selectedEng = null;
          _selectedIndo = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final solvedCount = _matchedMap.values.where((v) => v != null).length;
    final totalCount = _englishList.length;

    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            // Minimalist Premium Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🧩', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Teka-Teki Pasangan Kata ($totalCount)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$solvedCount / $totalCount',
                      style: const TextStyle(
                        color: Color(0xFF8E24AA),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Main 2-Column Grid (Left: English, Right: Indonesian) - Fills Full Portrait Height!
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Column: English Words Grid List
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF1E88E5), width: 1.5),
                          ),
                          child: const Text(
                            '🇬🇧 Bahasa Inggris',
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _englishList.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final eng = _englishList[index];
                              final matchedIndo = _matchedMap[eng];
                              final isSolved = matchedIndo != null;
                              final isSelected = _selectedEng == eng;

                              return ScaleAnimation(
                                onTap: () => _onEngSelected(eng),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: isSolved
                                        ? const Color(0xFFE8F5E9)
                                        : (isSelected
                                            ? const Color(0xFF8E24AA)
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSolved
                                          ? const Color(0xFF43A047)
                                          : (isSelected
                                              ? const Color(0xFF8E24AA)
                                              : const Color(0xFF1E88E5)
                                                  .withValues(alpha: 0.35)),
                                      width: isSelected || isSolved ? 2.5 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? Colors.purple.withValues(alpha: 0.3)
                                            : Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        isSolved ? '✅' : '🧩',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eng,
                                              style: TextStyle(
                                                color: isSolved
                                                    ? const Color(0xFF2E7D32)
                                                    : (isSelected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF1E88E5)),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (isSolved)
                                              Text(
                                                '= $matchedIndo',
                                                style: const TextStyle(
                                                  color: Color(0xFF43A047),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Right Column: Indonesian Words Grid List (100% Shuffled)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E5F5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF8E24AA), width: 1.5),
                          ),
                          child: const Text(
                            '🇮🇩 Bahasa Indonesia',
                            style: TextStyle(
                              color: Color(0xFF8E24AA),
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _shuffledIndonesianList.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final indo = _shuffledIndonesianList[index];
                              final isSolved = _matchedIndoSet.contains(indo);
                              final isSelected = _selectedIndo == indo;

                              return ScaleAnimation(
                                onTap: () => _onIndoSelected(indo),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: isSolved
                                        ? const Color(0xFFE8F5E9)
                                        : (isSelected
                                            ? const Color(0xFFE24379)
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSolved
                                          ? const Color(0xFF43A047)
                                          : (isSelected
                                              ? const Color(0xFFE24379)
                                              : const Color(0xFF8E24AA)
                                                  .withValues(alpha: 0.35)),
                                      width: isSelected || isSolved ? 2.5 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? Colors.pink.withValues(alpha: 0.3)
                                            : Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSolved
                                            ? Icons.check_circle_rounded
                                            : Icons.touch_app_rounded,
                                        color: isSolved
                                            ? const Color(0xFF43A047)
                                            : (isSelected
                                                ? Colors.white
                                                : const Color(0xFF8E24AA)),
                                        size: 17,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          indo,
                                          style: TextStyle(
                                            color: isSolved
                                                ? const Color(0xFF2E7D32)
                                                : (isSelected
                                                    ? Colors.white
                                                    : const Color(0xFF8E24AA)),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
