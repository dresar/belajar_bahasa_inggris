import '../../models/game_content.dart';

/*
================================================================================
🤖 MASTER PROMPT CLAUDE AI - GENERASI 100 SOAL KELAS 2 (SD)
================================================================================
Salin seluruh teks di dalam blok petunjuk ini ke Claude AI untuk menghasilkan 100 soal!

PROMPT START >>>
Halo Claude! Kamu adalah Pakar Kurikulum Bahasa Inggris SD di Indonesia.
Tolong buatkan TEPAT 100 SOAL Bahasa Inggris berformat KODE DART UTUH yang variatif, seru, dan edukatif untuk KELAS 2 SD.

⛔ ATURAN MUTLAK HASIL KELUARAN (STRICT OUTPUT FORMAT):
1. JANGAN HASILKAN FORMAT JSON! JANGAN HASILKAN TEXT PENJELASAN PENGANTAR!
2. KAMU WAJIB MENGENERATE 100% KODE DART UTUH BERFORMAT .DART yang siap digunakan untuk langsung menimpa (overwrite) file grade_2_data.dart ini!
3. Wajib dimulai dengan `import '../../models/game_content.dart';` dan deklarasi `final List<ChapterGameData> grade2Chapters = [...];`.
4. Setiap soal wajib menggunakan konstruktor `const GameQuestion(...)` atau `GameQuestion(...)` yang valid dan sintaksnya 100% kompatibel dengan Flutter Dart.

💡 ATURAN GAYA BAHASA SANTAI & PEDAGOGI ANAK SD (BERDASARKAN RISET EDUKASI):
1. GAYA BAHASA INDONESIA NON-FORMAL & SANTAI BANGET:
   - Gunakan bahasa Indonesia yang super ramah, ceria, santai, dan seru khas teman belajar anak SD.
   - CONTOH PETUNJUK SANTAI: "Benda kelas yang satu ini apa hayo?", "Yuk tebak bahasa Inggrisnya 'Tangan'!", "Pernah dengar kata ini gak?", "Gimana ya cara ngomongnya?".
   - HINDARI BAHASA FORMAL KAKU seperti "Terjemahkanlah kalimat berikut" atau "Sebutkanlah pilihan yang tepat".
2. KONTEKS DUNIA ANAK SD:
   - Sekolah, alat tulis, anggota tubuh, nama hari, bentuk, sayuran & makanan favorit.

🎯 ATURAN KESULITAN KELAS 2 SD:
- Level Kesulitan: DASAR & INTERAKTIF (Anak usia 7-8 tahun).
- Topik Utama: School Supplies (Benda Sekolah), Body Parts (Anggota Tubuh), Days of the Week (Nama Hari), Shapes (Bentuk), Vegetables & Foods.

🎮 DAFTAR LENGKAP 11 TIPE MINI-GAME (Wajib Kombinasi Acak):

1. 'quiz' (Pilihan Ganda):
   GameQuestion(id: 'g2_q1', type: 'quiz', prompt: 'Tahukah kamu, "Pencil" itu artinya apa?', targetAnswer: 'Pensil', options: ['Pensil', 'Buku', 'Tas', 'Penggaris'])

2. 'phrase' (Menyusun Frasa):
   GameQuestion(id: 'g2_q2', type: 'phrase', prompt: 'Gimana ya cara bilang "Tutup bukumu"?', targetAnswer: 'close your book', wordBank: ['close', 'your', 'book', 'open', 'read'])

3. 'pair' (Memasangkan Kata):
   GameQuestion(id: 'g2_q3', type: 'pair', prompt: 'Yuk pasangkan anggota tubuh ini!', leftWords: ['Eyes', 'Ears', 'Nose'], rightWords: ['Mata', 'Telinga', 'Hidung'], correctPairs: {'Eyes': 'Mata', 'Ears': 'Telinga', 'Nose': 'Hidung'})

4. 'listening' (Pendengaran Audio):
   GameQuestion(id: 'g2_q4', type: 'listening', prompt: 'Dengerin baik-baik yuk, mana benda sekolah yang diucapkan?', targetAnswer: 'Ruler', options: ['Ruler', 'Pencil', 'Eraser', 'Sharpener'])

5. 'unscramble' (Acakan Huruf):
   GameQuestion(id: 'g2_q5', type: 'unscramble', prompt: 'Susun huruf acak ini jadi kata "Buku" yuk!', targetAnswer: 'book', shuffledLetters: ['k', 'o', 'o', 'b'])

6. 'guess_picture' (Tebak Gambar/Emoji):
   GameQuestion(id: 'g2_q6', type: 'guess_picture', prompt: 'Benda sekolah apa nih?', imageEmoji: '✏️', targetAnswer: 'Pencil', options: ['Pencil', 'Book', 'Ruler', 'Bag'])

7. 'memory' (Kartu Memori):
   GameQuestion(id: 'g2_q7', type: 'memory', prompt: 'Yuk cocokkan nama-nama hari di kartu ini!', leftWords: ['Monday', 'Sunday', 'Friday'], rightWords: ['Senin', 'Minggu', 'Jumat'], correctPairs: {'Monday': 'Senin', 'Sunday': 'Minggu', 'Friday': 'Jumat'})

8. 'boss_battle' (Boss Battle Level):
   GameQuestion(id: 'g2_q8', type: 'boss_battle', prompt: 'Tantangan Boss: Bahasa Inggrisnya "Kepala" apa hayo?', bossName: 'Monster Tubuh', bossHp: 100, targetAnswer: 'Head', options: ['Head', 'Hand', 'Foot', 'Leg'])

9. 'typing' (Mengetik Jawaban):
   GameQuestion(id: 'g2_q9', type: 'typing', prompt: 'Coba ketik Bahasa Inggris dari kata "Tangan"!', targetAnswer: 'hand')

10. 'fill_blank' (Isi Kata Hilang):
    GameQuestion(id: 'g2_q10', type: 'fill_blank', prompt: 'Isi kata hilang yuk: "Raise your ______!" (Angkat tanganmu)', targetAnswer: 'hand', options: ['hand', 'foot', 'head', 'eye'])

11. 'true_false' (Benar atau Salah):
    GameQuestion(id: 'g2_q11', type: 'true_false', prompt: 'Bener gak sih kalau "Monday" itu hari "Senin"?', targetAnswer: 'True')

📐 FORMAT OUTPUT KODE DART SIAP COPY-PASTE OVERWRITE:

import '../../models/game_content.dart';

final List<ChapterGameData> grade2Chapters = [
  // Masukkan 100 soal yang dibagi menjadi beberapa ChapterGameData di sini!
];
<<< PROMPT END
================================================================================
*/

final List<ChapterGameData> grade2Chapters = [
  const ChapterGameData(
    chapterId: 'school_supplies',
    chapterTitle: 'School Supplies',
    chapterDescription: 'Mengenal nama peralatan sekolah dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g2_q1',
        type: 'quiz',
        prompt: 'Tahukah kamu, "Pencil" itu artinya apa?',
        targetAnswer: 'Pensil',
        options: ['Pensil', 'Buku', 'Tas', 'Penggaris'],
      ),
      GameQuestion(
        id: 'g2_q2',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Buka bukumu"?',
        targetAnswer: 'open your book',
        wordBank: ['open', 'your', 'book', 'close', 'read'],
      ),
      GameQuestion(
        id: 'g2_q3',
        type: 'pair',
        prompt: 'Yuk pasangkan teka-teki 9 kata benda sekolah dan artinya!',
        leftWords: ['Eraser', 'Ruler', 'Scissors', 'Book', 'Pencil', 'Bag', 'Desk', 'Chair', 'Map'],
        rightWords: ['Gunting', 'Penggaris', 'Penghapus', 'Peta', 'Buku', 'Meja', 'Pensil', 'Kursi', 'Tas'],
        correctPairs: {
          'Eraser': 'Penghapus',
          'Ruler': 'Penggaris',
          'Scissors': 'Gunting',
          'Book': 'Buku',
          'Pencil': 'Pensil',
          'Bag': 'Tas',
          'Desk': 'Meja',
          'Chair': 'Kursi',
          'Map': 'Peta',
        },
      ),
      GameQuestion(
        id: 'g2_q4',
        type: 'listening',
        prompt: 'Dengerin baik-baik yuk, mana benda sekolah yang diucapkan?',
        targetAnswer: 'Ruler',
        options: ['Ruler', 'Pencil', 'Eraser', 'Sharpener'],
      ),
      GameQuestion(
        id: 'g2_q5',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Buku" yuk!',
        targetAnswer: 'book',
        shuffledLetters: ['k', 'o', 'o', 'b'],
      ),
      GameQuestion(
        id: 'g2_q6',
        type: 'guess_picture',
        prompt: 'Benda sekolah apa nih?',
        imageEmoji: '✏️',
        targetAnswer: 'Pencil',
        options: ['Pencil', 'Book', 'Ruler', 'Bag'],
      ),
      GameQuestion(
        id: 'g2_q7',
        type: 'memory',
        prompt: 'Yuk cocokkan nama alat tulis di kartu ini!',
        leftWords: ['Glue', 'Crayon', 'Sharpener'],
        rightWords: ['Lem', 'Krayon', 'Peraut'],
        correctPairs: {
          'Glue': 'Lem',
          'Crayon': 'Krayon',
          'Sharpener': 'Peraut',
        },
      ),
      GameQuestion(
        id: 'g2_q8',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: benda buat menghapus tulisan pensil apa hayo?',
        bossName: 'Monster Sekolah',
        bossHp: 100,
        targetAnswer: 'Eraser',
        options: ['Eraser', 'Ruler', 'Pencil', 'Book'],
      ),
      GameQuestion(
        id: 'g2_q9',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Tas"!',
        targetAnswer: 'bag',
      ),
      GameQuestion(
        id: 'g2_q10',
        type: 'fill_blank',
        prompt: 'Isi kata hilang yuk: "Open your ______!" (Buka bukumu)',
        targetAnswer: 'book',
        options: ['book', 'pencil', 'ruler', 'bag'],
      ),
      GameQuestion(
        id: 'g2_q11',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Chair" itu artinya "Kursi"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g2_q12',
        type: 'quiz',
        prompt: 'Pernah dengar kata ini gak? "Notebook" itu artinya apa hayo?',
        targetAnswer: 'Buku catatan',
        options: ['Buku catatan', 'Buku cerita', 'Kamus', 'Majalah'],
      ),
      GameQuestion(
        id: 'g2_q13',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Tutup bukumu"?',
        targetAnswer: 'close your book',
        wordBank: ['close', 'your', 'book', 'open', 'read'],
      ),
      GameQuestion(
        id: 'g2_q14',
        type: 'pair',
        prompt: 'Yuk pasangkan benda kelas ini!',
        leftWords: ['Table', 'Chair', 'Board'],
        rightWords: ['Meja', 'Kursi', 'Papan'],
        correctPairs: {'Table': 'Meja', 'Chair': 'Kursi', 'Board': 'Papan'},
      ),
      GameQuestion(
        id: 'g2_q15',
        type: 'listening',
        prompt: 'Dengerin nama alat tulis ini yuk!',
        targetAnswer: 'Marker',
        options: ['Marker', 'Pen', 'Pencil', 'Crayon'],
      ),
      GameQuestion(
        id: 'g2_q16',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Kertas"!',
        targetAnswer: 'paper',
        shuffledLetters: ['r', 'a', 'p', 'e', 'p'],
      ),
      GameQuestion(
        id: 'g2_q17',
        type: 'guess_picture',
        prompt: 'Benda kelas yang satu ini apa hayo?',
        imageEmoji: '🎒',
        targetAnswer: 'Bag',
        options: ['Bag', 'Book', 'Pencil', 'Chair'],
      ),
      GameQuestion(
        id: 'g2_q18',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: alat buat menyatukan kertas namanya apa hayo?',
        bossName: 'Raja Kertas',
        bossHp: 100,
        targetAnswer: 'Stapler',
        options: ['Stapler', 'Glue', 'Scissors', 'Folder'],
      ),
      GameQuestion(
        id: 'g2_q19',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Gunting"!',
        targetAnswer: 'scissors',
      ),
      GameQuestion(
        id: 'g2_q20',
        type: 'fill_blank',
        prompt: 'Isi kata hilang yuk: "Cut the paper with ______" (Gunting)',
        targetAnswer: 'scissors',
        options: ['scissors', 'ruler', 'glue', 'pen'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'body_parts',
    chapterTitle: 'Body Parts',
    chapterDescription: 'Mengenal nama anggota tubuh dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g2_q21',
        type: 'quiz',
        prompt: 'Yuk tebak, "Head" itu artinya apa?',
        targetAnswer: 'Kepala',
        options: ['Kepala', 'Tangan', 'Kaki', 'Mata'],
      ),
      GameQuestion(
        id: 'g2_q22',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Angkat tanganmu"?',
        targetAnswer: 'raise your hand',
        wordBank: ['raise', 'your', 'hand', 'foot', 'head'],
      ),
      GameQuestion(
        id: 'g2_q23',
        type: 'pair',
        prompt: 'Yuk pasangkan anggota tubuh ini!',
        leftWords: ['Eyes', 'Ears', 'Nose'],
        rightWords: ['Mata', 'Telinga', 'Hidung'],
        correctPairs: {'Eyes': 'Mata', 'Ears': 'Telinga', 'Nose': 'Hidung'},
      ),
      GameQuestion(
        id: 'g2_q24',
        type: 'listening',
        prompt: 'Dengerin nama anggota tubuh ini yuk!',
        targetAnswer: 'Mouth',
        options: ['Mouth', 'Nose', 'Ear', 'Eye'],
      ),
      GameQuestion(
        id: 'g2_q25',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Tangan"!',
        targetAnswer: 'hand',
        shuffledLetters: ['d', 'a', 'n', 'h'],
      ),
      GameQuestion(
        id: 'g2_q26',
        type: 'guess_picture',
        prompt: 'Anggota tubuh buat mendengar ini apa hayo?',
        imageEmoji: '👂',
        targetAnswer: 'Ear',
        options: ['Ear', 'Eye', 'Nose', 'Mouth'],
      ),
      GameQuestion(
        id: 'g2_q27',
        type: 'memory',
        prompt: 'Yuk cocokkan anggota tubuh di kartu ini!',
        leftWords: ['Hair', 'Arm', 'Leg'],
        rightWords: ['Rambut', 'Lengan', 'Kaki'],
        correctPairs: {'Hair': 'Rambut', 'Arm': 'Lengan', 'Leg': 'Kaki'},
      ),
      GameQuestion(
        id: 'g2_q28',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: Bahasa Inggrisnya "Kepala" apa hayo?',
        bossName: 'Monster Tubuh',
        bossHp: 100,
        targetAnswer: 'Head',
        options: ['Head', 'Hand', 'Foot', 'Leg'],
      ),
      GameQuestion(
        id: 'g2_q29',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Tangan"!',
        targetAnswer: 'hand',
      ),
      GameQuestion(
        id: 'g2_q30',
        type: 'fill_blank',
        prompt: 'Isi kata hilang yuk: "Raise your ______!" (Angkat tanganmu)',
        targetAnswer: 'hand',
        options: ['hand', 'foot', 'head', 'eye'],
      ),
      GameQuestion(
        id: 'g2_q31',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Foot" itu artinya "Kaki"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g2_q32',
        type: 'quiz',
        prompt: 'Yuk tebak, "Finger" itu artinya apa?',
        targetAnswer: 'Jari',
        options: ['Jari', 'Tangan', 'Kuku', 'Lengan'],
      ),
      GameQuestion(
        id: 'g2_q33',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Cuci tanganmu"?',
        targetAnswer: 'wash your hands',
        wordBank: ['wash', 'your', 'hands', 'face', 'feet'],
      ),
      GameQuestion(
        id: 'g2_q34',
        type: 'pair',
        prompt: 'Yuk pasangkan anggota tubuh ini!',
        leftWords: ['Shoulder', 'Knee', 'Neck'],
        rightWords: ['Bahu', 'Lutut', 'Leher'],
        correctPairs: {'Shoulder': 'Bahu', 'Knee': 'Lutut', 'Neck': 'Leher'},
      ),
      GameQuestion(
        id: 'g2_q35',
        type: 'listening',
        prompt: 'Dengerin baik-baik, anggota tubuh apa ini?',
        targetAnswer: 'Teeth',
        options: ['Teeth', 'Tongue', 'Chin', 'Cheek'],
      ),
      GameQuestion(
        id: 'g2_q36',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Hidung"!',
        targetAnswer: 'nose',
        shuffledLetters: ['e', 's', 'o', 'n'],
      ),
      GameQuestion(
        id: 'g2_q37',
        type: 'guess_picture',
        prompt: 'Anggota tubuh buat melihat ini apa hayo?',
        imageEmoji: '👁️',
        targetAnswer: 'Eye',
        options: ['Eye', 'Ear', 'Nose', 'Mouth'],
      ),
      GameQuestion(
        id: 'g2_q38',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: Bahasa Inggrisnya "Gigi" apa hayo?',
        bossName: 'Raksasa Wajah',
        bossHp: 120,
        targetAnswer: 'Teeth',
        options: ['Teeth', 'Tongue', 'Lips', 'Chin'],
      ),
      GameQuestion(
        id: 'g2_q39',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Kaki"!',
        targetAnswer: 'foot',
      ),
      GameQuestion(
        id: 'g2_q40',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Elbow" itu artinya "Siku"?',
        targetAnswer: 'True',
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'days_of_the_week',
    chapterTitle: 'Days of the Week',
    chapterDescription: 'Mengenal nama-nama hari dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g2_q41',
        type: 'quiz',
        prompt: 'Tahukah kamu, "Monday" itu hari apa?',
        targetAnswer: 'Senin',
        options: ['Senin', 'Selasa', 'Rabu', 'Kamis'],
      ),
      GameQuestion(
        id: 'g2_q42',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Hari ini hari Senin"?',
        targetAnswer: 'today is monday',
        wordBank: ['today', 'is', 'monday', 'tuesday', 'tomorrow'],
      ),
      GameQuestion(
        id: 'g2_q43',
        type: 'pair',
        prompt: 'Yuk cocokkan nama-nama hari ini!',
        leftWords: ['Monday', 'Sunday', 'Friday'],
        rightWords: ['Senin', 'Minggu', 'Jumat'],
        correctPairs: {'Monday': 'Senin', 'Sunday': 'Minggu', 'Friday': 'Jumat'},
      ),
      GameQuestion(
        id: 'g2_q44',
        type: 'listening',
        prompt: 'Dengerin nama harinya yuk!',
        targetAnswer: 'Wednesday',
        options: ['Wednesday', 'Tuesday', 'Thursday', 'Monday'],
      ),
      GameQuestion(
        id: 'g2_q45',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Jumat"!',
        targetAnswer: 'friday',
        shuffledLetters: ['y', 'f', 'r', 'i', 'd', 'a'],
      ),
      GameQuestion(
        id: 'g2_q46',
        type: 'guess_picture',
        prompt: 'Kalau lihat kalender, hari pertama masuk sekolah biasanya hari apa hayo?',
        imageEmoji: '📅',
        targetAnswer: 'Monday',
        options: ['Monday', 'Sunday', 'Friday', 'Saturday'],
      ),
      GameQuestion(
        id: 'g2_q47',
        type: 'memory',
        prompt: 'Yuk cocokkan nama-nama hari di kartu ini!',
        leftWords: ['Tuesday', 'Thursday', 'Saturday'],
        rightWords: ['Selasa', 'Kamis', 'Sabtu'],
        correctPairs: {
          'Tuesday': 'Selasa',
          'Thursday': 'Kamis',
          'Saturday': 'Sabtu',
        },
      ),
      GameQuestion(
        id: 'g2_q48',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: hari terakhir dalam seminggu itu apa hayo?',
        bossName: 'Raja Kalender',
        bossHp: 100,
        targetAnswer: 'Sunday',
        options: ['Sunday', 'Saturday', 'Friday', 'Monday'],
      ),
      GameQuestion(
        id: 'g2_q49',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Rabu"!',
        targetAnswer: 'wednesday',
      ),
      GameQuestion(
        id: 'g2_q50',
        type: 'fill_blank',
        prompt: 'Isi hari yang hilang: "After Monday comes ______" (Selasa)',
        targetAnswer: 'Tuesday',
        options: ['Tuesday', 'Wednesday', 'Sunday', 'Friday'],
      ),
      GameQuestion(
        id: 'g2_q51',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Saturday" itu hari "Sabtu"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g2_q52',
        type: 'quiz',
        prompt: 'Tahukah kamu, "Sunday" itu hari apa?',
        targetAnswer: 'Minggu',
        options: ['Minggu', 'Senin', 'Sabtu', 'Jumat'],
      ),
      GameQuestion(
        id: 'g2_q53',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Besok hari Jumat"?',
        targetAnswer: 'tomorrow is friday',
        wordBank: ['tomorrow', 'is', 'friday', 'today', 'thursday'],
      ),
      GameQuestion(
        id: 'g2_q54',
        type: 'pair',
        prompt: 'Yuk pasangkan kata waktu ini!',
        leftWords: ['Today', 'Tomorrow', 'Yesterday'],
        rightWords: ['Hari ini', 'Besok', 'Kemarin'],
        correctPairs: {
          'Today': 'Hari ini',
          'Tomorrow': 'Besok',
          'Yesterday': 'Kemarin',
        },
      ),
      GameQuestion(
        id: 'g2_q55',
        type: 'listening',
        prompt: 'Dengerin nama harinya, terus pilih yang bener!',
        targetAnswer: 'Thursday',
        options: ['Thursday', 'Tuesday', 'Wednesday', 'Friday'],
      ),
      GameQuestion(
        id: 'g2_q56',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Minggu"!',
        targetAnswer: 'sunday',
        shuffledLetters: ['y', 'd', 'n', 'u', 'a', 's'],
      ),
      GameQuestion(
        id: 'g2_q57',
        type: 'quiz',
        prompt: 'Tahukah kamu, "Thursday" itu hari apa?',
        targetAnswer: 'Kamis',
        options: ['Kamis', 'Rabu', 'Jumat', 'Selasa'],
      ),
      GameQuestion(
        id: 'g2_q58',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Sabtu"!',
        targetAnswer: 'saturday',
      ),
      GameQuestion(
        id: 'g2_q59',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Tuesday" itu artinya "Rabu"?',
        targetAnswer: 'False',
      ),
      GameQuestion(
        id: 'g2_q60',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: hari sebelum hari Minggu itu apa hayo?',
        bossName: 'Penjaga Minggu',
        bossHp: 100,
        targetAnswer: 'Saturday',
        options: ['Saturday', 'Friday', 'Monday', 'Sunday'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'shapes',
    chapterTitle: 'Shapes',
    chapterDescription: 'Mengenal nama-nama bentuk dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g2_q61',
        type: 'quiz',
        prompt: 'Yuk tebak, "Circle" itu bentuk apa?',
        targetAnswer: 'Lingkaran',
        options: ['Lingkaran', 'Persegi', 'Segitiga', 'Bintang'],
      ),
      GameQuestion(
        id: 'g2_q62',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Ini bentuk bintang"?',
        targetAnswer: 'this is a star',
        wordBank: ['this', 'is', 'a', 'star', 'circle'],
      ),
      GameQuestion(
        id: 'g2_q63',
        type: 'pair',
        prompt: 'Yuk pasangkan nama bentuk ini!',
        leftWords: ['Circle', 'Square', 'Triangle'],
        rightWords: ['Lingkaran', 'Persegi', 'Segitiga'],
        correctPairs: {
          'Circle': 'Lingkaran',
          'Square': 'Persegi',
          'Triangle': 'Segitiga',
        },
      ),
      GameQuestion(
        id: 'g2_q64',
        type: 'listening',
        prompt: 'Dengerin nama bentuknya yuk!',
        targetAnswer: 'Rectangle',
        options: ['Rectangle', 'Square', 'Triangle', 'Circle'],
      ),
      GameQuestion(
        id: 'g2_q65',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Hati"!',
        targetAnswer: 'heart',
        shuffledLetters: ['t', 'r', 'a', 'e', 'h'],
      ),
      GameQuestion(
        id: 'g2_q66',
        type: 'guess_picture',
        prompt: 'Bentuk kelap-kelip di langit malam ini apa hayo?',
        imageEmoji: '⭐',
        targetAnswer: 'Star',
        options: ['Star', 'Heart', 'Circle', 'Diamond'],
      ),
      GameQuestion(
        id: 'g2_q67',
        type: 'memory',
        prompt: 'Yuk cocokkan nama bentuk di kartu ini!',
        leftWords: ['Oval', 'Diamond', 'Heart'],
        rightWords: ['Oval', 'Wajik', 'Hati'],
        correctPairs: {'Oval': 'Oval', 'Diamond': 'Wajik', 'Heart': 'Hati'},
      ),
      GameQuestion(
        id: 'g2_q68',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: bentuk dengan tiga sisi namanya apa hayo?',
        bossName: 'Penyihir Bentuk',
        bossHp: 100,
        targetAnswer: 'Triangle',
        options: ['Triangle', 'Square', 'Circle', 'Star'],
      ),
      GameQuestion(
        id: 'g2_q69',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Persegi"!',
        targetAnswer: 'square',
      ),
      GameQuestion(
        id: 'g2_q70',
        type: 'fill_blank',
        prompt: 'Isi bentuk yang hilang: "A ball is shaped like a ______" (Lingkaran)',
        targetAnswer: 'circle',
        options: ['circle', 'square', 'triangle', 'star'],
      ),
      GameQuestion(
        id: 'g2_q71',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Square" punya empat sisi sama panjang?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g2_q72',
        type: 'quiz',
        prompt: 'Yuk tebak, "Triangle" itu bentuk apa?',
        targetAnswer: 'Segitiga',
        options: ['Segitiga', 'Lingkaran', 'Persegi', 'Bintang'],
      ),
      GameQuestion(
        id: 'g2_q73',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Gambar bentuk hati"?',
        targetAnswer: 'draw a heart shape',
        wordBank: ['draw', 'a', 'heart', 'shape', 'star'],
      ),
      GameQuestion(
        id: 'g2_q74',
        type: 'pair',
        prompt: 'Yuk pasangkan nama bentuk ini!',
        leftWords: ['Star', 'Heart', 'Rectangle'],
        rightWords: ['Bintang', 'Hati', 'Persegi panjang'],
        correctPairs: {
          'Star': 'Bintang',
          'Heart': 'Hati',
          'Rectangle': 'Persegi panjang',
        },
      ),
      GameQuestion(
        id: 'g2_q75',
        type: 'listening',
        prompt: 'Dengerin nama bentuknya, terus pilih yang tepat!',
        targetAnswer: 'Diamond',
        options: ['Diamond', 'Star', 'Oval', 'Circle'],
      ),
      GameQuestion(
        id: 'g2_q76',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Persegi"!',
        targetAnswer: 'square',
        shuffledLetters: ['e', 'u', 'q', 'a', 'r', 's'],
      ),
      GameQuestion(
        id: 'g2_q77',
        type: 'guess_picture',
        prompt: 'Bentuk yang biasa dipakai buat kasih sayang ini apa hayo?',
        imageEmoji: '❤️',
        targetAnswer: 'Heart',
        options: ['Heart', 'Star', 'Circle', 'Diamond'],
      ),
      GameQuestion(
        id: 'g2_q78',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: bentuk lonjong seperti telur namanya apa hayo?',
        bossName: 'Raja Geometri',
        bossHp: 120,
        targetAnswer: 'Oval',
        options: ['Oval', 'Circle', 'Square', 'Diamond'],
      ),
      GameQuestion(
        id: 'g2_q79',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Bintang"!',
        targetAnswer: 'star',
      ),
      GameQuestion(
        id: 'g2_q80',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Rectangle" itu artinya "Segitiga"?',
        targetAnswer: 'False',
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'vegetables_and_foods',
    chapterTitle: 'Vegetables & Foods',
    chapterDescription: 'Mengenal nama sayuran dan makanan favorit dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g2_q81',
        type: 'quiz',
        prompt: 'Yuk tebak, "Carrot" itu sayur apa?',
        targetAnswer: 'Wortel',
        options: ['Wortel', 'Tomat', 'Kentang', 'Jagung'],
      ),
      GameQuestion(
        id: 'g2_q82',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku suka makan nasi"?',
        targetAnswer: 'i like eating rice',
        wordBank: ['i', 'like', 'eating', 'rice', 'bread'],
      ),
      GameQuestion(
        id: 'g2_q83',
        type: 'pair',
        prompt: 'Yuk pasangkan nama sayuran ini!',
        leftWords: ['Carrot', 'Tomato', 'Potato'],
        rightWords: ['Wortel', 'Tomat', 'Kentang'],
        correctPairs: {'Carrot': 'Wortel', 'Tomato': 'Tomat', 'Potato': 'Kentang'},
      ),
      GameQuestion(
        id: 'g2_q84',
        type: 'listening',
        prompt: 'Dengerin nama makanannya yuk!',
        targetAnswer: 'Bread',
        options: ['Bread', 'Rice', 'Noodle', 'Egg'],
      ),
      GameQuestion(
        id: 'g2_q85',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Jagung"!',
        targetAnswer: 'corn',
        shuffledLetters: ['r', 'n', 'o', 'c'],
      ),
      GameQuestion(
        id: 'g2_q86',
        type: 'guess_picture',
        prompt: 'Sayur oranye kesukaan kelinci ini apa hayo?',
        imageEmoji: '🥕',
        targetAnswer: 'Carrot',
        options: ['Carrot', 'Tomato', 'Corn', 'Potato'],
      ),
      GameQuestion(
        id: 'g2_q87',
        type: 'memory',
        prompt: 'Yuk cocokkan nama makanan di kartu ini!',
        leftWords: ['Egg', 'Milk', 'Fish'],
        rightWords: ['Telur', 'Susu', 'Ikan'],
        correctPairs: {'Egg': 'Telur', 'Milk': 'Susu', 'Fish': 'Ikan'},
      ),
      GameQuestion(
        id: 'g2_q88',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: sayur hijau berlapis-lapis ini namanya apa hayo?',
        bossName: 'Raksasa Dapur',
        bossHp: 100,
        targetAnswer: 'Cabbage',
        options: ['Cabbage', 'Spinach', 'Broccoli', 'Corn'],
      ),
      GameQuestion(
        id: 'g2_q89',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Roti"!',
        targetAnswer: 'bread',
      ),
      GameQuestion(
        id: 'g2_q90',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "I drink a glass of ______ every morning" (Susu)',
        targetAnswer: 'milk',
        options: ['milk', 'water', 'juice', 'soup'],
      ),
      GameQuestion(
        id: 'g2_q91',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Chicken" itu artinya "Ayam"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g2_q92',
        type: 'quiz',
        prompt: 'Yuk tebak, "Broccoli" itu sayur apa?',
        targetAnswer: 'Brokoli',
        options: ['Brokoli', 'Bayam', 'Kubis', 'Wortel'],
      ),
      GameQuestion(
        id: 'g2_q93',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku mau makan sup"?',
        targetAnswer: 'i want to eat soup',
        wordBank: ['i', 'want', 'to', 'eat', 'soup', 'rice'],
      ),
      GameQuestion(
        id: 'g2_q94',
        type: 'pair',
        prompt: 'Yuk pasangkan nama makanan ini!',
        leftWords: ['Rice', 'Bread', 'Noodle'],
        rightWords: ['Nasi', 'Roti', 'Mi'],
        correctPairs: {'Rice': 'Nasi', 'Bread': 'Roti', 'Noodle': 'Mi'},
      ),
      GameQuestion(
        id: 'g2_q95',
        type: 'listening',
        prompt: 'Dengerin nama sayurnya, terus pilih yang bener!',
        targetAnswer: 'Spinach',
        options: ['Spinach', 'Cabbage', 'Broccoli', 'Corn'],
      ),
      GameQuestion(
        id: 'g2_q96',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Tomat"!',
        targetAnswer: 'tomato',
        shuffledLetters: ['m', 'a', 'o', 't', 't', 'o'],
      ),
      GameQuestion(
        id: 'g2_q97',
        type: 'guess_picture',
        prompt: 'Hewan air yang enak dimasak jadi lauk ini apa hayo?',
        imageEmoji: '🐟',
        targetAnswer: 'Fish',
        options: ['Fish', 'Chicken', 'Egg', 'Milk'],
      ),
      GameQuestion(
        id: 'g2_q98',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: makanan panjang yang biasa dimasak jadi mi goreng namanya apa hayo?',
        bossName: 'Koki Ajaib',
        bossHp: 100,
        targetAnswer: 'Noodle',
        options: ['Noodle', 'Rice', 'Bread', 'Soup'],
      ),
      GameQuestion(
        id: 'g2_q99',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Telur"!',
        targetAnswer: 'egg',
      ),
      GameQuestion(
        id: 'g2_q100',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Potato" itu artinya "Kentang"?',
        targetAnswer: 'True',
      ),
    ],
  ),
];