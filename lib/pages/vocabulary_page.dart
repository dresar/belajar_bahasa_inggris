import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/vocabularies/vocab_repository.dart';
import '../models/game_content.dart';
import '../services/gemini_audio_service.dart';
import '../services/theme_service.dart';
import '../shared/animations/scale_animation.dart';
import '../shared/animations/slide_animation.dart';

class VocabularyPage extends StatefulWidget {
  final int grade;

  const VocabularyPage({
    super.key,
    required this.grade,
  });

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  late List<VocabItem> _allVocabs;
  List<VocabItem> _filteredVocabs = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  List<String> _categories = ['Semua'];
  String? _currentlyPlayingId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allVocabs = VocabRepository.getVocabForGrade(widget.grade);
    final cats = _allVocabs.map((v) => v.category).toSet().toList();
    _categories = ['Semua', ...cats];
    _applyFilter();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    setState(() {
      _filteredVocabs = _allVocabs.where((v) {
        final matchesQuery = _searchQuery.isEmpty ||
            v.english.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            v.indonesian.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'Semua' ||
            v.category.toLowerCase() == _selectedCategory.toLowerCase();
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  Future<void> _playPronunciation(VocabItem item) async {
    HapticFeedback.lightImpact();
    setState(() {
      _currentlyPlayingId = item.id;
    });

    await GeminiAudioService.instance.speak(item.english);

    if (mounted) {
      setState(() {
        _currentlyPlayingId = null;
      });
    }
  }

  void _scrollToTop() {
    HapticFeedback.mediumImpact();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemeService.instance.currentPalette;

    return Scaffold(
      backgroundColor: palette.backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, palette),
                  const SizedBox(height: 10),
                  _buildSearchBar(palette),
                  const SizedBox(height: 10),
                  _buildCategoryChips(palette),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _filteredVocabs.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 70),
                            itemCount: _filteredVocabs.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = _filteredVocabs[index];
                              final isPlaying = _currentlyPlayingId == item.id;

                              return SlideAnimation(
                                direction: SlideDirection.fromBottom,
                                delay: Duration(milliseconds: (index % 10) * 30),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: const Color(0xFF8E24AA)
                                          .withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF8E24AA),
                                              Color(0xFFAB47BC)
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.english
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.english,
                                                    style: const TextStyle(
                                                      color: Color(
                                                          0xFF8E24AA), // Explicit High Contrast Purple
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFF3E5F5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFAB47BC),
                                                        width: 1),
                                                  ),
                                                  child: Text(
                                                    item.category,
                                                    style: const TextStyle(
                                                      color: Color(0xFF8E24AA),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 10.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              item.indonesian,
                                              style: const TextStyle(
                                                color: Color(
                                                    0xFF222222), // Explicit Sharp Dark Text
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14.5,
                                              ),
                                            ),
                                            if (item.pronunciation.isNotEmpty) ...[
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.record_voice_over_rounded,
                                                    size: 13,
                                                    color: Color(0xFF1E88E5),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Dibaca: "${item.pronunciation}"',
                                                    style: const TextStyle(
                                                      color: Color(0xFF1E88E5),
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 12.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            if (item.exampleSentence
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                '"${item.exampleSentence}"',
                                                style: const TextStyle(
                                                  color: Color(0xFF666666),
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ScaleAnimation(
                                        onTap: () => _playPronunciation(item),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isPlaying
                                                ? const Color(0xFF00C853)
                                                : const Color(0xFF8E24AA),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.purple
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isPlaying
                                                ? Icons.volume_up_rounded
                                                : Icons.volume_down_rounded,
                                            color: Colors.white,
                                            size: 22,
                                          ),
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
          ),

          // Bottom-Right Floating Action Button (Scroll to Top)
          Positioned(
            bottom: 16,
            right: 16,
            child: SafeArea(
              child: ScaleAnimation(
                onTap: _scrollToTop,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemePalette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)], // Explicit Purple Gradient Header
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
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
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kamus Kosakata Kelas ${widget.grade}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${_filteredVocabs.length} Kata Tersedia dengan Audio',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemePalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (val) {
          _searchQuery = val;
          _applyFilter();
        },
        decoration: InputDecoration(
          hintText: 'Cari kata (Inggris / Indonesia)...',
          hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13.5),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8E24AA)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8E24AA), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: const Color(0xFF8E24AA).withValues(alpha: 0.3),
                width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8E24AA), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(ThemePalette palette) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _selectedCategory.toLowerCase() == cat.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ScaleAnimation(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedCategory = cat;
                });
                _applyFilter();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF8E24AA) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF8E24AA),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF8E24AA),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xFF888888),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kosakata Tidak Ditemukan',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coba ketik kata lain atau ubah kategori pilihan.',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
