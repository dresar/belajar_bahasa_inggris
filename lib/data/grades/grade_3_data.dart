import '../../models/game_content.dart';

/*
================================================================================
🤖 MASTER PROMPT CLAUDE AI - GENERASI 100 SOAL KELAS 3 (SD)
================================================================================
Salin seluruh teks di dalam blok petunjuk ini ke Claude AI untuk menghasilkan 100 soal!

PROMPT START >>>
Halo Claude! Kamu adalah Pakar Kurikulum Bahasa Inggris SD di Indonesia.
Tolong buatkan TEPAT 100 SOAL Bahasa Inggris berformat KODE DART UTUH yang variatif, seru, dan edukatif untuk KELAS 3 SD.

⛔ ATURAN MUTLAK HASIL KELUARAN (STRICT OUTPUT FORMAT):
1. JANGAN HASILKAN FORMAT JSON! JANGAN HASILKAN TEXT PENJELASAN PENGANTAR!
2. KAMU WAJIB MENGENERATE 100% KODE DART UTUH BERFORMAT .DART yang siap digunakan untuk langsung menimpa (overwrite) file grade_3_data.dart ini!
3. Wajib dimulai dengan `import '../../models/game_content.dart';` dan deklarasi `final List<ChapterGameData> grade3Chapters = [...];`.
4. Setiap soal wajib menggunakan konstruktor `const GameQuestion(...)` atau `GameQuestion(...)` yang valid dan sintaksnya 100% kompatibel dengan Flutter Dart.

💡 ATURAN GAYA BAHASA SANTAI & PEDAGOGI ANAK SD (BERDASARKAN RISET EDUKASI):
1. GAYA BAHASA INDONESIA NON-FORMAL & SANTAI BANGET:
   - Gunakan bahasa Indonesia yang super ramah, ceria, santai, dan seru khas teman belajar anak SD.
   - CONTOH PETUNJUK SANTAI: "Pernah nyobain minuman ini gak?", "Gimana ya ngomong cuaca panas?", "Yuk ketik kata yang pas!", "Wah keren, coba jawab yang ini!".
   - HINDARI BAHASA FORMAL KAKU seperti "Terjemahkanlah kalimat berikut" atau "Sebutkanlah pilihan yang tepat".
2. KONTEKS DUNIA ANAK SD:
   - Makanan & minuman kesukaan, cuaca, jam/waktu sehari-hari, pakaian favorit, dan perasaan gembira.

🎯 ATURAN KESULITAN KELAS 3 SD:
- Level Kesulitan: MENENGAH DASAR (Anak usia 8-9 tahun).
- Topik Utama: Food & Drinks (Makanan & Minuman), Weather & Seasons (Cuaca), Time & Clock (Waktu/Jam), Clothes (Pakaian), Feelings & Emotions (Perasaan).

🎮 DAFTAR LENGKAP 11 TIPE MINI-GAME (Wajib Kombinasi Acak):
1. 'quiz'          : Kuis Pilihan Ganda (4 pilihan jawaban).
2. 'phrase'        : Menyusun frasa kata dengan wordBank.
3. 'pair'          : Memasangkan 3 kata Inggris & Indonesia.
4. 'listening'     : Kuis mendengarkan pengucapan audio.
5. 'unscramble'    : Menyusun acakan huruf.
6. 'guess_picture' : Tebak emoji/gambar dengan 4 pilihan kata.
7. 'memory'        : Membalik kartu memori untuk mencocokkan kata.
8. 'boss_battle'   : Tantangan Lawan Boss Level (+25 XP, bossHp: 100).
9. 'typing'        : Mengetik jawaban Bahasa Inggris langsung.
10. 'fill_blank'   : Isi kata yang hilang pada kalimat.
11. 'true_false'   : Pernyataan Benar (True) atau Salah (False).

📐 FORMAT OUTPUT KODE DART SIAP COPY-PASTE OVERWRITE:

import '../../models/game_content.dart';

final List<ChapterGameData> grade3Chapters = [
  // Masukkan 100 soal yang dibagi menjadi beberapa ChapterGameData di sini!
];
<<< PROMPT END
================================================================================
*/

final List<ChapterGameData> grade3Chapters = [
  const ChapterGameData(
    chapterId: 'food_drinks',
    chapterTitle: 'Food & Drinks',
    chapterDescription: 'Mengenal makanan dan minuman favorit dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g3_q1',
        type: 'quiz',
        prompt: 'Pernah nyobain minuman ini gak? "Coffee" itu artinya apa?',
        targetAnswer: 'Kopi',
        options: ['Kopi', 'Teh', 'Susu', 'Jus'],
      ),
      GameQuestion(
        id: 'g3_q2',
        type: 'guess_picture',
        prompt: 'Minuman lezat apakah ini?',
        imageEmoji: '🥛',
        targetAnswer: 'Milk',
        options: ['Milk', 'Water', 'Tea', 'Juice'],
      ),
      GameQuestion(
        id: 'g3_q3',
        type: 'typing',
        prompt: 'Yuk ketik kata yang pas! Bahasa Inggris dari "Air Minum"!',
        targetAnswer: 'water',
      ),
      GameQuestion(
        id: 'g3_q4',
        type: 'fill_blank',
        prompt: 'Isi kata hilang yuk: "I drink a glass of ______ every morning." (Susu)',
        targetAnswer: 'milk',
        options: ['milk', 'bread', 'rice', 'apple'],
      ),
      GameQuestion(
        id: 'g3_q5',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Tea" itu artinya "Teh"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q6',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku suka minum jus jeruk"?',
        targetAnswer: 'i like orange juice',
        wordBank: ['i', 'like', 'orange', 'juice', 'tea'],
      ),
      GameQuestion(
        id: 'g3_q7',
        type: 'pair',
        prompt: 'Yuk pasangkan nama makanan ini!',
        leftWords: ['Bread', 'Egg', 'Cheese'],
        rightWords: ['Roti', 'Telur', 'Keju'],
        correctPairs: {'Bread': 'Roti', 'Egg': 'Telur', 'Cheese': 'Keju'},
      ),
      GameQuestion(
        id: 'g3_q8',
        type: 'listening',
        prompt: 'Dengerin nama makanannya yuk!',
        targetAnswer: 'Cake',
        options: ['Cake', 'Cookie', 'Bread', 'Sandwich'],
      ),
      GameQuestion(
        id: 'g3_q9',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Madu"!',
        targetAnswer: 'honey',
        shuffledLetters: ['y', 'e', 'n', 'o', 'h'],
      ),
      GameQuestion(
        id: 'g3_q10',
        type: 'guess_picture',
        prompt: 'Makanan dingin manis kesukaan anak-anak ini apa hayo?',
        imageEmoji: '🍦',
        targetAnswer: 'Ice Cream',
        options: ['Ice Cream', 'Cake', 'Chocolate', 'Cookie'],
      ),
      GameQuestion(
        id: 'g3_q11',
        type: 'memory',
        prompt: 'Yuk cocokkan bumbu dapur di kartu ini!',
        leftWords: ['Sugar', 'Salt', 'Butter'],
        rightWords: ['Gula', 'Garam', 'Mentega'],
        correctPairs: {'Sugar': 'Gula', 'Salt': 'Garam', 'Butter': 'Mentega'},
      ),
      GameQuestion(
        id: 'g3_q12',
        type: 'boss_battle',
        prompt: 'Wah keren, coba jawab yang ini! Makanan manis dari coklat, Bahasa Inggrisnya apa hayo?',
        bossName: 'Raja Dapur',
        bossHp: 100,
        targetAnswer: 'Chocolate',
        options: ['Chocolate', 'Candy', 'Honey', 'Sugar'],
      ),
      GameQuestion(
        id: 'g3_q13',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Roti Lapis"!',
        targetAnswer: 'sandwich',
      ),
      GameQuestion(
        id: 'g3_q14',
        type: 'fill_blank',
        prompt: 'Isi kata hilang yuk: "Please pass me the ______." (Garam)',
        targetAnswer: 'salt',
        options: ['salt', 'sugar', 'butter', 'honey'],
      ),
      GameQuestion(
        id: 'g3_q15',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Cookie" itu artinya "Kue kering"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q16',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Noodle" itu artinya makanan apa?',
        targetAnswer: 'Mi',
        options: ['Mi', 'Nasi', 'Roti', 'Sup'],
      ),
      GameQuestion(
        id: 'g3_q17',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku lapar, mau makan nasi"?',
        targetAnswer: 'i am hungry i want rice',
        wordBank: ['i', 'am', 'hungry', 'want', 'rice', 'water'],
      ),
      GameQuestion(
        id: 'g3_q18',
        type: 'pair',
        prompt: 'Yuk pasangkan nama minuman ini!',
        leftWords: ['Coffee', 'Juice', 'Water'],
        rightWords: ['Kopi', 'Jus', 'Air'],
        correctPairs: {'Coffee': 'Kopi', 'Juice': 'Jus', 'Water': 'Air'},
      ),
      GameQuestion(
        id: 'g3_q19',
        type: 'listening',
        prompt: 'Dengerin nama minumannya, terus pilih yang bener!',
        targetAnswer: 'Juice',
        options: ['Juice', 'Milk', 'Tea', 'Coffee'],
      ),
      GameQuestion(
        id: 'g3_q20',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Roti"!',
        targetAnswer: 'bread',
        shuffledLetters: ['d', 'r', 'a', 'e', 'b'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'weather_seasons',
    chapterTitle: 'Weather & Seasons',
    chapterDescription: 'Mengenal cuaca dan musim dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g3_q21',
        type: 'quiz',
        prompt: 'Gimana ya ngomong cuaca cerah? "Sunny" itu artinya cuaca apa?',
        targetAnswer: 'Cerah',
        options: ['Cerah', 'Hujan', 'Berawan', 'Berangin'],
      ),
      GameQuestion(
        id: 'g3_q22',
        type: 'guess_picture',
        prompt: 'Cuaca apa nih kalau ada matahari terang begini?',
        imageEmoji: '☀️',
        targetAnswer: 'Sunny',
        options: ['Sunny', 'Rainy', 'Cloudy', 'Snowy'],
      ),
      GameQuestion(
        id: 'g3_q23',
        type: 'typing',
        prompt: 'Yuk ketik kata yang pas! Bahasa Inggris dari "Hujan"!',
        targetAnswer: 'rainy',
      ),
      GameQuestion(
        id: 'g3_q24',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "Bring your umbrella, it is ______ today." (Hujan)',
        targetAnswer: 'rainy',
        options: ['rainy', 'sunny', 'windy', 'cloudy'],
      ),
      GameQuestion(
        id: 'g3_q25',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Windy" itu artinya "Berangin"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q26',
        type: 'phrase',
        prompt: 'Gimana ya ngomong cuaca panas dalam kalimat? "Cuaca hari ini sangat panas"',
        targetAnswer: 'today is very hot',
        wordBank: ['today', 'is', 'very', 'hot', 'cold'],
      ),
      GameQuestion(
        id: 'g3_q27',
        type: 'pair',
        prompt: 'Yuk pasangkan kata suhu ini!',
        leftWords: ['Hot', 'Cold', 'Cool'],
        rightWords: ['Panas', 'Dingin', 'Sejuk'],
        correctPairs: {'Hot': 'Panas', 'Cold': 'Dingin', 'Cool': 'Sejuk'},
      ),
      GameQuestion(
        id: 'g3_q28',
        type: 'listening',
        prompt: 'Dengerin kondisi cuacanya yuk!',
        targetAnswer: 'Cloudy',
        options: ['Cloudy', 'Sunny', 'Rainy', 'Windy'],
      ),
      GameQuestion(
        id: 'g3_q29',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Badai"!',
        targetAnswer: 'storm',
        shuffledLetters: ['m', 'r', 't', 's', 'o'],
      ),
      GameQuestion(
        id: 'g3_q30',
        type: 'guess_picture',
        prompt: 'Wah keren, coba jawab yang ini! Muncul warna-warni di langit habis hujan, apa hayo?',
        imageEmoji: '🌈',
        targetAnswer: 'Rainbow',
        options: ['Rainbow', 'Sun', 'Cloud', 'Storm'],
      ),
      GameQuestion(
        id: 'g3_q31',
        type: 'memory',
        prompt: 'Yuk cocokkan nama musim di kartu ini!',
        leftWords: ['Summer', 'Winter', 'Spring'],
        rightWords: ['Musim Panas', 'Musim Dingin', 'Musim Semi'],
        correctPairs: {
          'Summer': 'Musim Panas',
          'Winter': 'Musim Dingin',
          'Spring': 'Musim Semi',
        },
      ),
      GameQuestion(
        id: 'g3_q32',
        type: 'boss_battle',
        prompt: 'Gimana ya ngomong cuaca panas dalam Bahasa Inggris?',
        bossName: 'Dewa Cuaca',
        bossHp: 100,
        targetAnswer: 'Hot',
        options: ['Hot', 'Cold', 'Cool', 'Warm'],
      ),
      GameQuestion(
        id: 'g3_q33',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Berkabut"!',
        targetAnswer: 'foggy',
      ),
      GameQuestion(
        id: 'g3_q34',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "In ______, the leaves fall from the trees." (Musim Gugur)',
        targetAnswer: 'autumn',
        options: ['autumn', 'winter', 'summer', 'spring'],
      ),
      GameQuestion(
        id: 'g3_q35',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Snowy" itu artinya "Bersalju"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q36',
        type: 'quiz',
        prompt: 'Pernah dengar bunyi keras pas hujan deras gak? "Thunder" itu artinya apa?',
        targetAnswer: 'Petir',
        options: ['Petir', 'Hujan', 'Angin', 'Awan'],
      ),
      GameQuestion(
        id: 'g3_q37',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku suka musim semi"?',
        targetAnswer: 'i like spring',
        wordBank: ['i', 'like', 'spring', 'summer', 'winter'],
      ),
      GameQuestion(
        id: 'g3_q38',
        type: 'pair',
        prompt: 'Yuk pasangkan kata cuaca ini!',
        leftWords: ['Umbrella', 'Rainbow', 'Cloud'],
        rightWords: ['Payung', 'Pelangi', 'Awan'],
        correctPairs: {'Umbrella': 'Payung', 'Rainbow': 'Pelangi', 'Cloud': 'Awan'},
      ),
      GameQuestion(
        id: 'g3_q39',
        type: 'listening',
        prompt: 'Dengerin nama musimnya, terus pilih yang bener!',
        targetAnswer: 'Winter',
        options: ['Winter', 'Summer', 'Spring', 'Autumn'],
      ),
      GameQuestion(
        id: 'g3_q40',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Berawan"!',
        targetAnswer: 'cloudy',
        shuffledLetters: ['y', 'c', 'l', 'o', 'u', 'd'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'time_clock',
    chapterTitle: 'Time & Clock',
    chapterDescription: 'Mengenal waktu dan jam sehari-hari dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g3_q41',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Clock" itu artinya apa?',
        targetAnswer: 'Jam dinding',
        options: ['Jam dinding', 'Jam tangan', 'Kalender', 'Waktu'],
      ),
      GameQuestion(
        id: 'g3_q42',
        type: 'guess_picture',
        prompt: 'Benda buat membangunkan tidur ini apa hayo?',
        imageEmoji: '⏰',
        targetAnswer: 'Alarm Clock',
        options: ['Alarm Clock', 'Watch', 'Calendar', 'Clock'],
      ),
      GameQuestion(
        id: 'g3_q43',
        type: 'typing',
        prompt: 'Yuk ketik kata yang pas! Bahasa Inggris dari "Jam Tangan"!',
        targetAnswer: 'watch',
      ),
      GameQuestion(
        id: 'g3_q44',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "It is seven ______ in the morning." (Pukul tepat)',
        targetAnswer: "o'clock",
        options: ["o'clock", 'hour', 'minute', 'late'],
      ),
      GameQuestion(
        id: 'g3_q45',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Late" itu artinya "Terlambat"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q46',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Sekarang jam tujuh pagi"?',
        targetAnswer: 'it is seven in the morning',
        wordBank: ['it', 'is', 'seven', 'in', 'the', 'morning'],
      ),
      GameQuestion(
        id: 'g3_q47',
        type: 'pair',
        prompt: 'Yuk pasangkan waktu dalam sehari ini!',
        leftWords: ['Morning', 'Afternoon', 'Evening'],
        rightWords: ['Pagi', 'Siang', 'Sore'],
        correctPairs: {'Morning': 'Pagi', 'Afternoon': 'Siang', 'Evening': 'Sore'},
      ),
      GameQuestion(
        id: 'g3_q48',
        type: 'listening',
        prompt: 'Dengerin waktunya yuk!',
        targetAnswer: 'Night',
        options: ['Night', 'Morning', 'Afternoon', 'Evening'],
      ),
      GameQuestion(
        id: 'g3_q49',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Lebih Awal"!',
        targetAnswer: 'early',
        shuffledLetters: ['y', 'l', 'r', 'a', 'e'],
      ),
      GameQuestion(
        id: 'g3_q50',
        type: 'guess_picture',
        prompt: 'Jarum jam menunjukkan pukul berapa hayo?',
        imageEmoji: '🕐',
        targetAnswer: "One O'Clock",
        options: ["One O'Clock", "Two O'Clock", "Three O'Clock", "Twelve O'Clock"],
      ),
      GameQuestion(
        id: 'g3_q51',
        type: 'memory',
        prompt: 'Yuk cocokkan satuan waktu di kartu ini!',
        leftWords: ['Hour', 'Minute', 'Second'],
        rightWords: ['Jam', 'Menit', 'Detik'],
        correctPairs: {'Hour': 'Jam', 'Minute': 'Menit', 'Second': 'Detik'},
      ),
      GameQuestion(
        id: 'g3_q52',
        type: 'boss_battle',
        prompt: 'Wah keren, coba jawab yang ini! Setengah jam Bahasa Inggrisnya apa hayo?',
        bossName: 'Penguasa Waktu',
        bossHp: 100,
        targetAnswer: 'Half Past',
        options: ['Half Past', 'Quarter', "O'Clock", 'Late'],
      ),
      GameQuestion(
        id: 'g3_q53',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Terlambat"!',
        targetAnswer: 'late',
      ),
      GameQuestion(
        id: 'g3_q54',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "Wake up early, don\'t be ______." (Terlambat)',
        targetAnswer: 'late',
        options: ['late', 'early', 'fast', 'slow'],
      ),
      GameQuestion(
        id: 'g3_q55',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Quarter" itu artinya "Seperempat"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q56',
        type: 'quiz',
        prompt: 'Yuk ketik kata yang pas! "Alarm" itu artinya apa?',
        targetAnswer: 'Alarm',
        options: ['Alarm', 'Jam', 'Menit', 'Malam'],
      ),
      GameQuestion(
        id: 'g3_q57',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku bangun pagi setiap hari"?',
        targetAnswer: 'i wake up early every day',
        wordBank: ['i', 'wake', 'up', 'early', 'every', 'day'],
      ),
      GameQuestion(
        id: 'g3_q58',
        type: 'pair',
        prompt: 'Yuk pasangkan kata waktu ini!',
        leftWords: ['Early', 'Late', 'Now'],
        rightWords: ['Lebih Awal', 'Terlambat', 'Sekarang'],
        correctPairs: {'Early': 'Lebih Awal', 'Late': 'Terlambat', 'Now': 'Sekarang'},
      ),
      GameQuestion(
        id: 'g3_q59',
        type: 'listening',
        prompt: 'Dengerin waktunya, terus pilih yang bener!',
        targetAnswer: 'Afternoon',
        options: ['Afternoon', 'Morning', 'Evening', 'Night'],
      ),
      GameQuestion(
        id: 'g3_q60',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Menit"!',
        targetAnswer: 'minute',
        shuffledLetters: ['e', 't', 'u', 'n', 'i', 'm'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'clothes',
    chapterTitle: 'Clothes',
    chapterDescription: 'Mengenal nama-nama pakaian favorit dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g3_q61',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Shirt" itu artinya apa?',
        targetAnswer: 'Kemeja',
        options: ['Kemeja', 'Celana', 'Rok', 'Topi'],
      ),
      GameQuestion(
        id: 'g3_q62',
        type: 'guess_picture',
        prompt: 'Baju kaos santai ini namanya apa hayo?',
        imageEmoji: '👕',
        targetAnswer: 'T-Shirt',
        options: ['T-Shirt', 'Pants', 'Dress', 'Shoes'],
      ),
      GameQuestion(
        id: 'g3_q63',
        type: 'typing',
        prompt: 'Yuk ketik kata yang pas! Bahasa Inggris dari "Celana"!',
        targetAnswer: 'pants',
      ),
      GameQuestion(
        id: 'g3_q64',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "I wear a ______ to school every day." (Seragam)',
        targetAnswer: 'uniform',
        options: ['uniform', 'dress', 'jacket', 'hat'],
      ),
      GameQuestion(
        id: 'g3_q65',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Shoes" itu artinya "Sepatu"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q66',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku pakai topi baru"?',
        targetAnswer: 'i wear a new hat',
        wordBank: ['i', 'wear', 'a', 'new', 'hat', 'scarf'],
      ),
      GameQuestion(
        id: 'g3_q67',
        type: 'pair',
        prompt: 'Yuk pasangkan nama pakaian ini!',
        leftWords: ['Shirt', 'Pants', 'Shoes'],
        rightWords: ['Baju', 'Celana', 'Sepatu'],
        correctPairs: {'Shirt': 'Baju', 'Pants': 'Celana', 'Shoes': 'Sepatu'},
      ),
      GameQuestion(
        id: 'g3_q68',
        type: 'listening',
        prompt: 'Dengerin nama pakaiannya yuk!',
        targetAnswer: 'Jacket',
        options: ['Jacket', 'Sweater', 'Coat', 'Scarf'],
      ),
      GameQuestion(
        id: 'g3_q69',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Gaun"!',
        targetAnswer: 'dress',
        shuffledLetters: ['s', 'e', 'r', 'd', 's'],
      ),
      GameQuestion(
        id: 'g3_q70',
        type: 'guess_picture',
        prompt: 'Yuk ketik kata yang pas! Kaki pakai apa biar hangat pas dingin?',
        imageEmoji: '🧦',
        targetAnswer: 'Socks',
        options: ['Socks', 'Shoes', 'Gloves', 'Hat'],
      ),
      GameQuestion(
        id: 'g3_q71',
        type: 'memory',
        prompt: 'Yuk cocokkan pakaian musim dingin di kartu ini!',
        leftWords: ['Hat', 'Scarf', 'Gloves'],
        rightWords: ['Topi', 'Syal', 'Sarung tangan'],
        correctPairs: {'Hat': 'Topi', 'Scarf': 'Syal', 'Gloves': 'Sarung tangan'},
      ),
      GameQuestion(
        id: 'g3_q72',
        type: 'boss_battle',
        prompt: 'Pernah pakai baju hangat pas musim dingin gak? Bahasa Inggrisnya apa hayo?',
        bossName: 'Ratu Mode',
        bossHp: 100,
        targetAnswer: 'Sweater',
        options: ['Sweater', 'T-Shirt', 'Shorts', 'Sandals'],
      ),
      GameQuestion(
        id: 'g3_q73',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Rok"!',
        targetAnswer: 'skirt',
      ),
      GameQuestion(
        id: 'g3_q74',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "It is raining, wear your ______." (Jas hujan)',
        targetAnswer: 'raincoat',
        options: ['raincoat', 'dress', 'shorts', 'sandals'],
      ),
      GameQuestion(
        id: 'g3_q75',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Boots" itu artinya "Sandal"?',
        targetAnswer: 'False',
      ),
      GameQuestion(
        id: 'g3_q76',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Belt" itu artinya apa?',
        targetAnswer: 'Ikat pinggang',
        options: ['Ikat pinggang', 'Sarung tangan', 'Syal', 'Topi'],
      ),
      GameQuestion(
        id: 'g3_q77',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Dia memakai sepatu bot baru"?',
        targetAnswer: 'she wears new boots',
        wordBank: ['she', 'wears', 'new', 'boots', 'shoes'],
      ),
      GameQuestion(
        id: 'g3_q78',
        type: 'pair',
        prompt: 'Yuk pasangkan nama pakaian ini!',
        leftWords: ['Shorts', 'Cap', 'Sandals'],
        rightWords: ['Celana pendek', 'Topi', 'Sandal'],
        correctPairs: {'Shorts': 'Celana pendek', 'Cap': 'Topi', 'Sandals': 'Sandal'},
      ),
      GameQuestion(
        id: 'g3_q79',
        type: 'listening',
        prompt: 'Dengerin nama pakaiannya, terus pilih yang bener!',
        targetAnswer: 'Trousers',
        options: ['Trousers', 'Shorts', 'Skirt', 'Dress'],
      ),
      GameQuestion(
        id: 'g3_q80',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Jaket"!',
        targetAnswer: 'jacket',
        shuffledLetters: ['t', 'c', 'k', 'e', 'a', 'j'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'feelings_emotions',
    chapterTitle: 'Feelings & Emotions',
    chapterDescription: 'Mengenal ungkapan perasaan gembira dan lainnya dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g3_q81',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Happy" itu artinya apa?',
        targetAnswer: 'Senang',
        options: ['Senang', 'Sedih', 'Marah', 'Takut'],
      ),
      GameQuestion(
        id: 'g3_q82',
        type: 'guess_picture',
        prompt: 'Perasaan apa nih kalau muka begini?',
        imageEmoji: '😢',
        targetAnswer: 'Sad',
        options: ['Sad', 'Happy', 'Angry', 'Scared'],
      ),
      GameQuestion(
        id: 'g3_q83',
        type: 'typing',
        prompt: 'Yuk ketik kata yang pas! Bahasa Inggris dari "Marah"!',
        targetAnswer: 'angry',
      ),
      GameQuestion(
        id: 'g3_q84',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "I feel ______ when I get a gift." (Senang)',
        targetAnswer: 'happy',
        options: ['happy', 'sad', 'angry', 'tired'],
      ),
      GameQuestion(
        id: 'g3_q85',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Scared" itu artinya "Takut"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q86',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Aku merasa sangat senang hari ini"?',
        targetAnswer: 'i feel very happy today',
        wordBank: ['i', 'feel', 'very', 'happy', 'today', 'sad'],
      ),
      GameQuestion(
        id: 'g3_q87',
        type: 'pair',
        prompt: 'Yuk pasangkan kata perasaan ini!',
        leftWords: ['Happy', 'Sad', 'Angry'],
        rightWords: ['Senang', 'Sedih', 'Marah'],
        correctPairs: {'Happy': 'Senang', 'Sad': 'Sedih', 'Angry': 'Marah'},
      ),
      GameQuestion(
        id: 'g3_q88',
        type: 'listening',
        prompt: 'Dengerin perasaan ini, terus pilih yang bener!',
        targetAnswer: 'Tired',
        options: ['Tired', 'Excited', 'Bored', 'Happy'],
      ),
      GameQuestion(
        id: 'g3_q89',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Malu"!',
        targetAnswer: 'shy',
        shuffledLetters: ['y', 'h', 's'],
      ),
      GameQuestion(
        id: 'g3_q90',
        type: 'guess_picture',
        prompt: 'Perasaan kaget banget kayak gini namanya apa hayo?',
        imageEmoji: '😲',
        targetAnswer: 'Surprised',
        options: ['Surprised', 'Scared', 'Angry', 'Sad'],
      ),
      GameQuestion(
        id: 'g3_q91',
        type: 'memory',
        prompt: 'Yuk cocokkan kata perasaan di kartu ini!',
        leftWords: ['Excited', 'Bored', 'Nervous'],
        rightWords: ['Bersemangat', 'Bosan', 'Gugup'],
        correctPairs: {
          'Excited': 'Bersemangat',
          'Bored': 'Bosan',
          'Nervous': 'Gugup',
        },
      ),
      GameQuestion(
        id: 'g3_q92',
        type: 'boss_battle',
        prompt: 'Pernah ngerasa gugup sebelum tampil di depan kelas gak? Bahasa Inggrisnya apa hayo?',
        bossName: 'Monster Perasaan',
        bossHp: 100,
        targetAnswer: 'Nervous',
        options: ['Nervous', 'Happy', 'Calm', 'Proud'],
      ),
      GameQuestion(
        id: 'g3_q93',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggris dari kata "Bangga"!',
        targetAnswer: 'proud',
      ),
      GameQuestion(
        id: 'g3_q94',
        type: 'fill_blank',
        prompt: 'Isi kata hilang: "She feels ______ because she lost her toy." (Sedih)',
        targetAnswer: 'sad',
        options: ['sad', 'happy', 'proud', 'calm'],
      ),
      GameQuestion(
        id: 'g3_q95',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Brave" itu artinya "Pemberani"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g3_q96',
        type: 'quiz',
        prompt: 'Wah keren, coba jawab yang ini! "Confused" itu artinya apa?',
        targetAnswer: 'Bingung',
        options: ['Bingung', 'Tenang', 'Cemburu', 'Malu'],
      ),
      GameQuestion(
        id: 'g3_q97',
        type: 'phrase',
        prompt: 'Gimana ya cara bilang "Jangan takut, kamu berani"?',
        targetAnswer: "don't be scared you are brave",
        wordBank: ["don't", 'be', 'scared', 'you', 'are', 'brave'],
      ),
      GameQuestion(
        id: 'g3_q98',
        type: 'pair',
        prompt: 'Yuk pasangkan kata perasaan ini!',
        leftWords: ['Worried', 'Calm', 'Lonely'],
        rightWords: ['Khawatir', 'Tenang', 'Kesepian'],
        correctPairs: {'Worried': 'Khawatir', 'Calm': 'Tenang', 'Lonely': 'Kesepian'},
      ),
      GameQuestion(
        id: 'g3_q99',
        type: 'listening',
        prompt: 'Dengerin perasaan ini, terus pilih yang tepat!',
        targetAnswer: 'Grateful',
        options: ['Grateful', 'Jealous', 'Curious', 'Embarrassed'],
      ),
      GameQuestion(
        id: 'g3_q100',
        type: 'boss_battle',
        prompt: 'Tantangan terakhir! Perasaan pengen tahu banyak hal itu Bahasa Inggrisnya apa hayo?',
        bossName: 'Raja Emosi',
        bossHp: 150,
        targetAnswer: 'Curious',
        options: ['Curious', 'Bored', 'Shy', 'Proud'],
      ),
    ],
  ),
];