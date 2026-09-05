import 'package:flutter/material.dart';
import '../../services/xp_service.dart';

class ExpDetailsDialog extends StatelessWidget {
  const ExpDetailsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ExpDetailsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalXp = XpService.instance.totalXp;
    final level = XpService.instance.level;

    // XP calculation for current level progress (100 XP per level)
    final currentLevelXp = totalXp % 100;
    final nextLevelXp = 100;
    final progress = currentLevelXp / nextLevelXp;

    String levelTitle = 'Pemula Cerdas 🚀';
    if (level >= 10) {
      levelTitle = 'Master Bahasa 👑';
    } else if (level >= 5) {
      levelTitle = 'Jagoan Inggris 🌟';
    } else if (level >= 3) {
      levelTitle = 'Bintang Belajar ⭐';
    } else if (level >= 2) {
      levelTitle = 'Pejuang Hebat 🛡️';
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🏆', style: TextStyle(fontSize: 42)),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalXp TOTAL EXP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Level $level • $levelTitle',
                    style: const TextStyle(
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body Progress Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progres Level Berikutnya:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      '$currentLevelXp / $nextLevelXp XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: const Color(0xFFFFECB3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8F00)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '💡 Cara Mendapatkan Poin EXP:',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 10),
                _buildXpRule('✅ Selesaikan Bab Materi', '+150 EXP'),
                _buildXpRule('🎯 Jawab Soal Kuis Benar', '+10 EXP'),
                _buildXpRule('🔊 Pengucapan Suara CDN Gemini', '+20 EXP'),
                _buildXpRule('📖 Latihan Kosakata', '+15 EXP'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8F00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildXpRule(String title, String xpReward) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12.5, color: Color(0xFF555555), fontWeight: FontWeight.w600)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFD54F)),
            ),
            child: Text(
              xpReward,
              style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.w900, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}
