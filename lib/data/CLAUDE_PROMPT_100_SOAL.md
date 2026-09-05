# 🤖 MASTER PROMPT: GENERATE 100 SOAL BAHASA INGGRIS SD (KELAS 1 - 6)

Salin prompt di bawah ini dan berikan ke **Claude AI** untuk mendaptkan 100 soal lengkap berformat Dart yang langsung dapat di-paste ke folder `lib/data/grades/`!

---

## 📌 PROMPT UNTUK CLAUDE AI (COPY-PASTE PROMPT DI BAWAH INI):

```text
Halo Claude! Kamu adalah Pakar Kurikulum Bahasa Inggris Sekolah Dasar (SD) di Indonesia.
Tolong buatkan 100 soal Bahasa Inggris yang variatif, seru, dan edukatif untuk [TENTUKAN KELAS: KELAS 1 / KELAS 2 / KELAS 3 / KELAS 4 / KELAS 5 / KELAS 6].

### 🎯 ATURAN WAJIB GENERASI 100 SOAL:
1. Wajib menghasilkan tepat 100 objek `GameQuestion(...)` berformat Dart yang valid tanpa ada koma/tanda kurung yang salah.
2. Kombinasikan 8 jenis mini-game berbeda secara acak agar tidak membosankan:
   - 'quiz' : Pilihan ganda Bahasa Inggris/Indonesia
   - 'phrase' : Menyusun frasa kata dengan wordBank
   - 'pair' : Memasangkan 3 kata Indonesia & Inggris
   - 'listening' : Soal pendengaran pengucapan audio
   - 'unscramble' : Menyusun acakan huruf menjadi kata
   - 'guess_picture' : Tebak gambar/emoji dengan opsi pilihan
   - 'memory' : Membalik kartu memori untuk mencocokkan kata
   - 'boss_battle' : Tantangan lawan Boss Level di akhir bab (+25 XP)
3. Jangan ada soal yang persis sama (wajib 100 unik).
4. Gunakan Bahasa Indonesia untuk instruksi/prompt dan Bahasa Inggris untuk target jawaban.

### 📐 FORMAT OUTPUT DART KODE:

import '../../models/game_content.dart';

final List<ChapterGameData> grade[NOMOR_KELAS]Chapters = [
  ChapterGameData(
    chapterId: 'bab_1',
    chapterTitle: 'Judul Bab 1',
    chapterDescription: 'Deskripsi singkat materi bab 1',
    questions: [
      // 100 objek GameQuestion(...) di sini...
    ],
  ),
];
```

---

## 🎨 FITUR GAME & ANIMASI DALAM APLIKASI:

1. **Generasi Suara Audio (Gemini TTS API)**:
   Setiap kata Bahasa Inggris secara otomatis disuarakan oleh AI Gemini 3.1 Flash TTS (`GeminiAudioService`) secara native 24kHz.
2. **Guru AI Ceria (Gemini 2.5 Flash API)**:
   Siswa dapat menekan tombol `🤖 Guru AI` untuk bertanya atau meminta petunjuk hint kapan saja.
3. **Pengacakan Soal Otomatis (Auto-Shuffle)**:
   Soal diacak secara otomatis saat permainan dimulai sehingga siswa tidak pernah bosan.
4. **Animasi Berhasil & Gagal**:
   - **Benar**: Partikel ledakan bintang (confetti) + dialog bouncing hijau + Haptic Feedback (+10 XP).
   - **Salah**: Efek layar bergetar elastis (shake effect) + dialog oranye penyemangat (+3 XP).
