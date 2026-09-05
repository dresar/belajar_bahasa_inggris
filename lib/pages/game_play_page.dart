import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_content.dart';
import '../services/gemini_audio_service.dart';
import '../services/xp_service.dart';
import '../shared/animations/scale_animation.dart';
import '../shared/animations/slide_animation.dart';
import '../shared/widgets/answer_feedback_overlay.dart';
import '../shared/widgets/boss_battle_widget.dart';
import '../shared/widgets/guess_picture_widget.dart';
import '../shared/widgets/memory_game_widget.dart';
import '../shared/widgets/puzzle_drag_matching_widget.dart';
import '../shared/widgets/unscramble_game_widget.dart';

class GamePlayPage extends StatefulWidget {
  final int grade;
  final ChapterGameData chapterData;

  const GamePlayPage({
    super.key,
    required this.grade,
    required this.chapterData,
  });

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isFinished = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<String> _phraseSelectedWords = [];
  int? _selectedMultipleChoice;
  final Set<String> _matchedPairs = {};
  int? _selectedAudioChoice;
  final TextEditingController _typingController = TextEditingController();

  late final List<GameQuestion> _questions;

  double get _progress {
    if (_questions.isEmpty) return 1.0;
    return (_currentStep / _questions.length).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _questions = widget.chapterData.questions.toList()..shuffle();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  GameQuestion get _currentQuestion {
    if (_questions.isEmpty) {
      return widget.chapterData.questions.last;
    }
    if (_currentStep >= _questions.length) {
      return _questions.last;
    }
    return _questions[_currentStep];
  }

  void _onWordChipTap(String word) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_phraseSelectedWords.contains(word)) {
        _phraseSelectedWords.remove(word);
      } else {
        _phraseSelectedWords.add(word);
      }
    });
  }

  void _showXpFeedback(int amount, bool isCorrect, {String? customSubtitle, VoidCallback? onNext}) {
    XpService.instance.addXp(amount);
    if (!mounted) return;

    AnswerFeedbackOverlay.show(
      context: context,
      isCorrect: isCorrect,
      title: isCorrect ? 'JAWABAN BENAR! 🌟' : 'BELUM TEPAT! 💪',
      subtitle: customSubtitle ??
          (isCorrect
              ? 'Luar biasa! Kamu mendapatkan +$amount XP!'
              : 'Tetap semangat! Jawaban belum tepat, tetapi kamu tetap dapat +$amount XP!'),
      xpAmount: amount,
      onContinue: () {
        if (onNext != null) {
          onNext();
        }
      },
    );
  }

  void _checkPhraseAnswer() {
    final result = _phraseSelectedWords.join(' ').trim().toLowerCase();
    final expected = _currentQuestion.targetAnswer.trim().toLowerCase();
    if (result == expected) {
      HapticFeedback.mediumImpact();
      _showXpFeedback(10, true, onNext: _nextStep);
    } else {
      HapticFeedback.heavyImpact();
      _showXpFeedback(3, false);
    }
  }

  void _onSelectMC(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedMultipleChoice = index;
    });

    final isCorrect =
        _currentQuestion.options[index].trim().toLowerCase() ==
            _currentQuestion.targetAnswer.trim().toLowerCase();
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      _showXpFeedback(10, true, onNext: _nextStep);
    } else {
      HapticFeedback.heavyImpact();
      _showXpFeedback(3, false, onNext: _nextStep);
    }
  }

  void _onSelectAudio(int index) {
    HapticFeedback.lightImpact();
    setState(() => _selectedAudioChoice = index);

    final word = _currentQuestion.options[index];
    GeminiAudioService.instance.speak(word);

    final isCorrect =
        word.trim().toLowerCase() == _currentQuestion.targetAnswer.trim().toLowerCase();
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      _showXpFeedback(10, true, onNext: _nextStep);
    } else {
      HapticFeedback.heavyImpact();
      _showXpFeedback(3, false, onNext: _nextStep);
    }
  }

  void _nextStep() {
    setState(() {
      _phraseSelectedWords.clear();
      _selectedMultipleChoice = null;
      _matchedPairs.clear();
      _selectedAudioChoice = null;
      _typingController.clear();

      if (_currentStep < _questions.length - 1) {
        _currentStep++;
      } else {
        _isFinished = true;
        _saveProgressToCloud();
      }
    });
  }

  Future<void> _saveProgressToCloud() async {
    await XpService.instance.saveChapterCompleted(
      grade: widget.grade,
      chapterId: widget.chapterData.chapterId,
      chapterTitle: widget.chapterData.chapterTitle,
      score: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      body: Stack(
        children: [
          // Edge-to-Edge Full Height Body Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 10, right: 10, bottom: 6),
                child: _isFinished
                    ? _buildFinishedView(context)
                    : _buildCurrentQuestionWidget(context, isPortrait),
              ),
            ),
          ),

          // Top Floating Back Button (Pure Overlay)
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: ScaleAnimation(
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
            ),
          ),

          // Top Floating XP Progress Badge (Pure Overlay)
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB300),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentQuestionWidget(BuildContext context, bool isPortrait) {
    final q = _currentQuestion;
    return switch (q.type) {
      'phrase' => _buildPhraseStep(context, q, isPortrait),
      'quiz' => _buildQuizStep(context, q, isPortrait),
      'pair' || 'puzzle' => PuzzleDragMatchingWidget(
          grade: widget.grade,
          prompt: q.prompt,
          englishWords: q.leftWords,
          indonesianWords: q.rightWords,
          correctPairs: q.correctPairs,
          onAnswerSubmitted: (isCorrect) {
            _showXpFeedback(20, true, onNext: _nextStep);
          },
        ),
      'listening' => _buildListeningStep(context, q, isPortrait),
      'unscramble' => UnscrambleGameWidget(
          prompt: q.prompt,
          targetAnswer: q.targetAnswer,
          shuffledLetters: q.shuffledLetters,
          onAnswerSubmitted: (isCorrect) {
            if (isCorrect) {
              _showXpFeedback(10, true, onNext: _nextStep);
            } else {
              _showXpFeedback(3, false, onNext: _nextStep);
            }
          },
        ),
      'guess_picture' => GuessPictureWidget(
          prompt: q.prompt,
          imageEmoji: q.imageEmoji,
          targetAnswer: q.targetAnswer,
          options: q.options,
          onAnswerSubmitted: (isCorrect) {
            if (isCorrect) {
              _showXpFeedback(10, true, onNext: _nextStep);
            } else {
              _showXpFeedback(3, false, onNext: _nextStep);
            }
          },
        ),
      'memory' => MemoryGameWidget(
          prompt: q.prompt,
          leftWords: q.leftWords,
          rightWords: q.rightWords,
          correctPairs: q.correctPairs,
          onAnswerSubmitted: (isCorrect) {
            _showXpFeedback(15, true, onNext: _nextStep);
          },
        ),
      'boss_battle' => BossBattleWidget(
          prompt: q.prompt,
          bossName: q.bossName,
          bossHp: q.bossHp,
          targetAnswer: q.targetAnswer,
          options: q.options,
          onAnswerSubmitted: (isCorrect) {
            if (isCorrect) {
              _showXpFeedback(25, true,
                  customSubtitle:
                      'BOOM! Boss Terkalahkan! Kamu dapat Double XP (+25 XP)! 👑',
                  onNext: _nextStep);
            } else {
              _showXpFeedback(5, false,
                  customSubtitle:
                      'Serangan Boss mengenai kamu! Tetap dapat +5 XP! 💪',
                  onNext: _nextStep);
            }
          },
        ),
      'typing' => _buildTypingStep(context, q, isPortrait),
      'fill_blank' => _buildFillBlankStep(context, q, isPortrait),
      'true_false' => _buildTrueFalseStep(context, q, isPortrait),
      _ => _buildQuizStep(context, q, isPortrait),
    };
  }

  Widget _buildPhraseStep(BuildContext context, GameQuestion q, bool isPortrait) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          // Compact Prompt Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF00BCD4), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'Artikan ke Bahasa Inggris',
                  style: TextStyle(
                    color: Color(0xFF00BCD4),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  q.prompt,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Answer Line Container
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF0288D1)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _phraseSelectedWords
                    .map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ScaleAnimation(
                          onTap: () => _onWordChipTap(w),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              w,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Word Bank (Side-by-side chips)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: q.wordBank.map((word) {
              final isUsed = _phraseSelectedWords.contains(word);
              return ScaleAnimation(
                onTap: () => _onWordChipTap(word),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isUsed ? 0.3 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF0288D1), width: 1.5),
                    ),
                    child: Text(
                      word,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          if (_phraseSelectedWords.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _checkPhraseAnswer,
                  child: const Text(
                    'Periksa Jawaban',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizStep(BuildContext context, GameQuestion q, bool isPortrait) {
    Widget promptWidget = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7C4DFF), width: 2),
      ),
      child: Text(
        q.prompt,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );

    Widget optionsWidget = GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: q.options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: isPortrait ? 2.4 : 3.2,
      ),
      itemBuilder: (context, index) {
        final isSelected = _selectedMultipleChoice == index;
        return ScaleAnimation(
          onTap: () => _onSelectMC(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF7C4DFF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7C4DFF),
                width: 2,
              ),
            ),
            child: Text(
              q.options[index],
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
    );

    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: isPortrait
          ? Column(
              children: [
                promptWidget,
                const SizedBox(height: 12),
                Expanded(child: optionsWidget),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 2, child: promptWidget),
                const SizedBox(width: 14),
                Expanded(flex: 3, child: optionsWidget),
              ],
            ),
    );
  }

  Widget _buildListeningStep(BuildContext context, GameQuestion q, bool isPortrait) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          // 🔊 Giant Animated Glowing Speaker Listening Card at Top
          ScaleAnimation(
            onTap: () {
              HapticFeedback.lightImpact();
              GeminiAudioService.instance.speak(q.targetAnswer);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00C853)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00C853).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Color(0xFF00C853),
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '🔊 Tekan & Dengarkan Suaranya!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    q.prompt.isNotEmpty ? q.prompt : 'Tebak kata apa yang diucapkan di atas!',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 4 Colorful Choice Cards Below!
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: q.options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 2 : 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isPortrait ? 1.8 : 2.4,
              ),
              itemBuilder: (context, index) {
                final isSelected = _selectedAudioChoice == index;
                final optionText = q.options[index];

                return ScaleAnimation(
                  onTap: () => _onSelectAudio(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00C853) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF00C853),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFF00C853).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      optionText,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF222222),
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
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

  Widget _buildTypingStep(BuildContext context, GameQuestion q, bool isPortrait) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1E88E5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⌨️ Mengetik Jawaban',
                style: TextStyle(
                  color: Color(0xFF1E88E5),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                q.prompt,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _typingController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
                decoration: InputDecoration(
                  hintText: 'Ketik jawaban Bahasa Inggris...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  fillColor: const Color(0xFFE3F2FD),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                  ),
                ),
                onSubmitted: (_) => _submitTypingAnswer(q),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _submitTypingAnswer(q),
                  child: const Text(
                    'Kirim Jawaban',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitTypingAnswer(GameQuestion q) {
    final input = _typingController.text.trim().toLowerCase();
    final target = q.targetAnswer.trim().toLowerCase();
    if (input == target) {
      HapticFeedback.mediumImpact();
      _showXpFeedback(10, true, onNext: _nextStep);
    } else {
      HapticFeedback.heavyImpact();
      _showXpFeedback(3, false,
          customSubtitle: 'Jawaban yang tepat adalah: "$target"',
          onNext: _nextStep);
    }
  }

  Widget _buildFillBlankStep(BuildContext context, GameQuestion q, bool isPortrait) {
    final optionsList = q.options.isNotEmpty ? q.options : q.wordBank;
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFB8C00), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'Isi Kata Yang Hilang',
                  style: TextStyle(
                    color: Color(0xFFFB8C00),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  q.prompt,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: optionsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isPortrait ? 2.5 : 3.2,
              ),
              itemBuilder: (context, index) {
                final text = optionsList[index];
                return ScaleAnimation(
                  onTap: () {
                    final isCorrect =
                        text.trim().toLowerCase() == q.targetAnswer.trim().toLowerCase();
                    if (isCorrect) {
                      HapticFeedback.mediumImpact();
                      _showXpFeedback(10, true, onNext: _nextStep);
                    } else {
                      HapticFeedback.heavyImpact();
                      _showXpFeedback(3, false,
                          customSubtitle: 'Kata yang benar: "${q.targetAnswer}"',
                          onNext: _nextStep);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFB8C00), width: 2),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFFE65100),
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

  Widget _buildTrueFalseStep(BuildContext context, GameQuestion q, bool isPortrait) {
    return SlideAnimation(
      direction: SlideDirection.fromRight,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF8E24AA), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'Benar atau Salah?',
                  style: TextStyle(
                    color: Color(0xFF8E24AA),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  q.prompt,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ScaleAnimation(
                  onTap: () => _submitTrueFalse('True', q),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'BENAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ScaleAnimation(
                  onTap: () => _submitTrueFalse('False', q),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'SALAH',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitTrueFalse(String choice, GameQuestion q) {
    final isCorrect =
        choice.trim().toLowerCase() == q.targetAnswer.trim().toLowerCase();
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      _showXpFeedback(10, true, onNext: _nextStep);
    } else {
      HapticFeedback.heavyImpact();
      _showXpFeedback(3, false,
          customSubtitle: 'Jawaban yang tepat: "${q.targetAnswer}"',
          onNext: _nextStep);
    }
  }

  Widget _buildFinishedView(BuildContext context) {
    return Center(
      child: SlideAnimation(
        direction: SlideDirection.fromBottom,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD54F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFFF8F00),
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Luar Biasa!',
                style: TextStyle(
                  color: Color(0xFFE24379),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Kamu berhasil menyelesaikan ${widget.chapterData.chapterTitle}!',
                style: const TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              ScaleAnimation(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE24379),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Kembali ke Topik',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PuzzleNotchCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isMatched;

  const PuzzleNotchCard({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isMatched
        ? const Color(0xFF4CAF50)
        : isSelected
            ? const Color(0xFF2E7D32)
            : const Color(0xFF4CAF50);

    final fillColor = isMatched
        ? const Color(0xFFE8F5E9)
        : isSelected
            ? const Color(0xFFF1F8E9)
            : Colors.white;

    return CustomPaint(
      painter: _PuzzleNotchBorderPainter(
        color: borderColor,
        fillColor: fillColor,
        strokeWidth: isSelected ? 4.0 : 3.0,
      ),
      child: Container(
        height: 110,
        padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10, top: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PuzzleNotchBorderPainter extends CustomPainter {
  final Color color;
  final Color fillColor;
  final double strokeWidth;

  _PuzzleNotchBorderPainter({
    required this.color,
    required this.fillColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final radius = 18.0;
    final corner = 22.0;

    final path = Path();
    path.moveTo(corner, 0);
    path.lineTo(w - corner, 0);
    path.quadraticBezierTo(w, 0, w, corner);
    path.lineTo(w, h - corner);
    path.quadraticBezierTo(w, h, w - corner, h);

    path.lineTo(cx + radius, h);
    path.arcToPoint(
      Offset(cx - radius, h),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(corner, h);
    path.quadraticBezierTo(0, h, 0, h - corner);
    path.lineTo(0, corner);
    path.quadraticBezierTo(0, 0, corner, 0);
    path.close();

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _PuzzleNotchBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class PuzzleTabTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isMatched;

  const PuzzleTabTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = isMatched
        ? const Color(0xFF81C784)
        : isSelected
            ? const Color(0xFF2E7D32)
            : const Color(0xFF4CAF50);

    return CustomPaint(
      painter: _PuzzleTabPainter(
        color: tileColor,
      ),
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 6),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PuzzleTabPainter extends CustomPainter {
  final Color color;

  _PuzzleTabPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final radius = 16.0;
    final corner = 20.0;
    final topOffset = 10.0;

    final path = Path();
    path.moveTo(corner, topOffset);

    path.lineTo(cx - radius, topOffset);
    path.arcToPoint(
      Offset(cx + radius, topOffset),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(w - corner, topOffset);
    path.quadraticBezierTo(w, topOffset, w, topOffset + corner);
    path.lineTo(w, h - corner);
    path.quadraticBezierTo(w, h, w - corner, h);
    path.lineTo(corner, h);
    path.quadraticBezierTo(0, h, 0, h - corner);
    path.lineTo(0, topOffset + corner);
    path.quadraticBezierTo(0, topOffset, corner, topOffset);
    path.close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 3.0, true);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _PuzzleTabPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
