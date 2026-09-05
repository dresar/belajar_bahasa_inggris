import '../../models/game_content.dart';

/*
================================================================================
🤖 MASTER PROMPT CLAUDE AI - GENERASI 100 SOAL KELAS 1 (SD)
================================================================================
Salin seluruh teks di dalam blok petunjuk ini ke Claude AI untuk menghasilkan 100 soal!

PROMPT START >>>
Halo Claude! Kamu adalah Pakar Kurikulum Bahasa Inggris SD di Indonesia.
Tolong buatkan TEPAT 100 SOAL Bahasa Inggris berformat KODE DART UTUH yang variatif, seru, dan edukatif untuk KELAS 1 SD.

⛔ ATURAN MUTLAK HASIL KELUARAN (STRICT OUTPUT FORMAT):
1. JANGAN HASILKAN FORMAT JSON! JANGAN HASILKAN TEXT PENJELASAN PENGANTAR!
2. KAMU WAJIB MENGENERATE 100% KODE DART UTUH BERFORMAT .DART yang siap digunakan untuk langsung menimpa (overwrite) file grade_1_data.dart ini!
3. Wajib dimulai dengan `import '../../models/game_content.dart';` dan deklarasi `final List<ChapterGameData> grade1Chapters = [...];`.
4. Setiap soal wajib menggunakan konstruktor `const GameQuestion(...)` atau `GameQuestion(...)` yang valid dan sintaksnya 100% kompatibel dengan Flutter Dart.

💡 ATURAN GAYA BAHASA SANTAI & PEDAGOGI ANAK SD (BERDASARKAN RISET EDUKASI):
1. GAYA BAHASA INDONESIA NON-FORMAL & SANTAI BANGET:
   - Gunakan bahasa Indonesia yang super ramah, ceria, santai, dan seru khas teman belajar anak SD.
   - CONTOH PETUNJUK SANTAI: "Yuk tebak hewan lucu ini!", "Gimana ya cara ngomong 'Selamat Pagi'?", "Warna favoritmu apa nih?", "Coba ketik kata yang hilang ini yuk!".
   - HINDARI BAHASA FORMAL KAKU seperti "Sebutkanlah definisi berikut" atau "Terjemahkanlah kalimat di bawah ini".
2. KONTEKS DUNIA ANAK SD:
   - Kaitkan dengan hewan lucu, makanan enak, warna ceria, mainan, dan sekolah.

🎯 ATURAN KESULITAN KELAS 1 SD:
- Level Kesulitan: SANGAT DASAR & MUDAH (Kata pendek 3-6 huruf, ramah anak usia 6-7 tahun).
- Topik Utama: Greeting & Salam, Numbers 1-10, Primary Colors, Cute Animals, Family, Fruits, School Items.

🎮 DAFTAR LENGKAP 11 TIPE MINI-GAME (Wajib Diacak & Memiliki Contoh Struktur Objek):

1. 'quiz' (Pilihan Ganda):
   GameQuestion(
     id: 'g1_q1',
     type: 'quiz',
     prompt: 'Tahu gak, kalau "Cat" dalam Bahasa Indonesia artinya apa?',
     targetAnswer: 'Kucing',
     options: ['Kucing', 'Anjing', 'Kelinci', 'Burung'],
   )

2. 'phrase' (Menyusun Frasa Kata):
   GameQuestion(
     id: 'g1_q2',
     type: 'phrase',
     prompt: 'Gimana ucapan "Selamat pagi" dalam Bahasa Inggris?',
     targetAnswer: 'good morning',
     wordBank: ['good', 'morning', 'night', 'afternoon', 'hello', 'bye'],
   )

3. 'pair' (Memasangkan Kata):
   GameQuestion(
     id: 'g1_q3',
     type: 'pair',
     prompt: 'Yuk pasangkan warna Bahasa Inggris dan Indonesianya!',
     leftWords: ['Red', 'Blue', 'Green'],
     rightWords: ['Merah', 'Biru', 'Hijau'],
     correctPairs: {'Red': 'Merah', 'Blue': 'Biru', 'Green': 'Hijau'},
   )

4. 'listening' (Pendengaran Audio):
   GameQuestion(
     id: 'g1_q4',
     type: 'listening',
     prompt: 'Dengerin suaranya yuk, terus pilih kata yang bener!',
     targetAnswer: 'Apple',
     options: ['Apple', 'Banana', 'Orange', 'Grape'],
   )

5. 'unscramble' (Menyusun Acakan Huruf):
   GameQuestion(
     id: 'g1_q5',
     type: 'unscramble',
     prompt: 'Yuk susun huruf acak ini jadi kata salam!',
     targetAnswer: 'hello',
     shuffledLetters: ['l', 'e', 'h', 'o', 'l'],
   )

6. 'guess_picture' (Tebak Gambar/Emoji):
   GameQuestion(
     id: 'g1_q6',
     type: 'guess_picture',
     prompt: 'Tebak yuk, nama hewan lucu ini apa?',
     imageEmoji: '🐱',
     targetAnswer: 'Cat',
     options: ['Cat', 'Dog', 'Rabbit', 'Bird'],
   )

7. 'memory' (Kartu Memori):
   GameQuestion(
     id: 'g1_q7',
     type: 'memory',
     prompt: 'Buka kartu memorinya dan cocokkan kata salam ya!',
     leftWords: ['Morning', 'Night', 'Hello'],
     rightWords: ['Pagi', 'Malam', 'Halo'],
     correctPairs: {'Morning': 'Pagi', 'Night': 'Malam', 'Hello': 'Halo'},
   )

8. 'boss_battle' (Boss Level Battle):
   GameQuestion(
     id: 'g1_q8',
     type: 'boss_battle',
     prompt: 'Tantangan Boss: "Selamat malam" bahasa Inggrisnya apa ayo?',
     bossName: 'King Dragon Salam',
     bossHp: 100,
     targetAnswer: 'Good Night',
     options: ['Good Night', 'Good Morning', 'Good Afternoon', 'Goodbye'],
   )

9. 'typing' (Mengetik Jawaban Directly):
   GameQuestion(
     id: 'g1_q9',
     type: 'typing',
     prompt: 'Coba ketik Bahasa Inggris dari kata "Buku"!',
     targetAnswer: 'book',
   )

10. 'fill_blank' (Isi Kata Hilang):
    GameQuestion(
      id: 'g1_q10',
      type: 'fill_blank',
      prompt: 'Isi kata yang hilang yuk: "Good ______!" (Selamat Pagi)',
      targetAnswer: 'morning',
      options: ['morning', 'night', 'evening', 'bye'],
    )

11. 'true_false' (Benar atau Salah):
    GameQuestion(
      id: 'g1_q11',
      type: 'true_false',
      prompt: 'Bener gak sih kalau "Dog" itu artinya "Anjing"?',
      targetAnswer: 'True',
    )

📐 FORMAT OUTPUT KODE DART SIAP COPY-PASTE OVERWRITE:

import '../../models/game_content.dart';

final List<ChapterGameData> grade1Chapters = [
  // Masukkan 100 soal yang dibagi menjadi beberapa ChapterGameData di sini!
];
<<< PROMPT END
================================================================================
*/

final List<ChapterGameData> grade1Chapters = [
  const ChapterGameData(
    chapterId: 'greeting',
    chapterTitle: 'Greeting & Salam',
    chapterDescription: 'Menyapa dan menanyakan kabar dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q1',
        type: 'phrase',
        prompt: 'Gimana ucapan "Selamat pagi" dalam Bahasa Inggris?',
        targetAnswer: 'good morning',
        wordBank: ['good', 'morning', 'night', 'afternoon', 'hello', 'bye'],
      ),
      GameQuestion(
        id: 'g1_q2',
        type: 'typing',
        prompt: 'Coba ketik kata Bahasa Inggris untuk "Buku"!',
        targetAnswer: 'book',
      ),
      GameQuestion(
        id: 'g1_q3',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang yuk: "Good ______!" (Selamat Pagi)',
        targetAnswer: 'morning',
        options: ['morning', 'night', 'evening', 'bye'],
      ),
      GameQuestion(
        id: 'g1_q4',
        type: 'true_false',
        prompt: 'Bener gak sih kalau "Dog" itu artinya "Anjing"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q5',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: "Selamat malam" Bahasa Inggrisnya apa ayo?',
        bossName: 'King Dragon Salam',
        bossHp: 100,
        targetAnswer: 'Good Night',
        options: ['Good Night', 'Good Morning', 'Good Afternoon', 'Goodbye'],
      ),
      GameQuestion(
        id: 'g1_q6',
        type: 'quiz',
        prompt: 'Kalau denger orang bilang "Hello", itu artinya apa ya?',
        targetAnswer: 'Halo',
        options: ['Halo', 'Selamat tinggal', 'Terima kasih', 'Tolong'],
      ),
      GameQuestion(
        id: 'g1_q7',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata pas mau pamitan yuk!',
        targetAnswer: 'bye',
        shuffledLetters: ['e', 'b', 'y'],
      ),
      GameQuestion(
        id: 'g1_q8',
        type: 'pair',
        prompt: 'Yuk pasangkan teka-teki 9 kata salam Bahasa Inggris dan artinya!',
        leftWords: ['Hello', 'Bye', 'Thanks', 'Morning', 'Night', 'Sorry', 'Please', 'Welcome', 'Friend'],
        rightWords: ['Terima kasih', 'Malam', 'Halo', 'Sama-sama', 'Maaf', 'Teman', 'Sampai jumpa', 'Pagi', 'Tolong'],
        correctPairs: {
          'Hello': 'Halo',
          'Bye': 'Sampai jumpa',
          'Thanks': 'Terima kasih',
          'Morning': 'Pagi',
          'Night': 'Malam',
          'Sorry': 'Maaf',
          'Please': 'Tolong',
          'Welcome': 'Sama-sama',
          'Friend': 'Teman',
        },
      ),
      GameQuestion(
        id: 'g1_q9',
        type: 'guess_picture',
        prompt: 'Kalau lihat tangan melambai gini, kita bilang apa ya?',
        imageEmoji: '👋',
        targetAnswer: 'Hello',
        options: ['Hello', 'Goodbye', 'Sorry', 'Please'],
      ),
      GameQuestion(
        id: 'g1_q10',
        type: 'listening',
        prompt: 'Dengerin ucapan salam ini, terus pilih yang bener!',
        targetAnswer: 'Good Afternoon',
        options: ['Good Afternoon', 'Good Morning', 'Good Night', 'Hello'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'numbers',
    chapterTitle: 'Numbers 1-10',
    chapterDescription: 'Belajar menghitung angka 1 sampai 10 dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q11',
        type: 'quiz',
        prompt: 'Kalau "One" itu angka berapa ya?',
        targetAnswer: 'Satu',
        options: ['Satu', 'Dua', 'Tiga', 'Empat'],
      ),
      GameQuestion(
        id: 'g1_q12',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya angka "Tiga"!',
        targetAnswer: 'three',
      ),
      GameQuestion(
        id: 'g1_q13',
        type: 'fill_blank',
        prompt: 'Isi angka yang hilang: "______, Two, Three"',
        targetAnswer: 'One',
        options: ['One', 'Four', 'Five', 'Six'],
      ),
      GameQuestion(
        id: 'g1_q14',
        type: 'true_false',
        prompt: 'Bener gak sih "Five" itu artinya angka "Lima"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q15',
        type: 'unscramble',
        prompt: 'Yuk susun huruf acak ini jadi angka "Empat"!',
        targetAnswer: 'four',
        shuffledLetters: ['r', 'o', 'f', 'u'],
      ),
      GameQuestion(
        id: 'g1_q16',
        type: 'pair',
        prompt: 'Pasangkan angka Bahasa Inggris sama artinya ya!',
        leftWords: ['One', 'Two', 'Three'],
        rightWords: ['Satu', 'Dua', 'Tiga'],
        correctPairs: {'One': 'Satu', 'Two': 'Dua', 'Three': 'Tiga'},
      ),
      GameQuestion(
        id: 'g1_q17',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan angka ini yuk!',
        leftWords: ['Four', 'Five', 'Six'],
        rightWords: ['Empat', 'Lima', 'Enam'],
        correctPairs: {'Four': 'Empat', 'Five': 'Lima', 'Six': 'Enam'},
      ),
      GameQuestion(
        id: 'g1_q18',
        type: 'guess_picture',
        prompt: 'Angka berapa yang ada pada simbol emoji ini?',
        imageEmoji: '7️⃣',
        targetAnswer: 'Seven',
        options: ['Seven', 'Six', 'Eight', 'Nine'],
      ),
      GameQuestion(
        id: 'g1_q19',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: angka setelah "Eight" apa ayo?',
        bossName: 'Raja Angka',
        bossHp: 100,
        targetAnswer: 'Nine',
        options: ['Nine', 'Ten', 'Seven', 'Eight'],
      ),
      GameQuestion(
        id: 'g1_q20',
        type: 'listening',
        prompt: 'Dengerin angkanya baik-baik, terus pilih yang tepat!',
        targetAnswer: 'Ten',
        options: ['Ten', 'Nine', 'Eight', 'Seven'],
      ),
      GameQuestion(
        id: 'g1_q21',
        type: 'quiz',
        prompt: 'Kalau "Six" itu angka berapa ya?',
        targetAnswer: 'Enam',
        options: ['Enam', 'Lima', 'Tujuh', 'Delapan'],
      ),
      GameQuestion(
        id: 'g1_q22',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya angka "Sepuluh"!',
        targetAnswer: 'ten',
      ),
      GameQuestion(
        id: 'g1_q23',
        type: 'fill_blank',
        prompt: 'Isi angka yang hilang: "Six, Seven, ______"',
        targetAnswer: 'Eight',
        options: ['Eight', 'Nine', 'Five', 'Four'],
      ),
      GameQuestion(
        id: 'g1_q24',
        type: 'true_false',
        prompt: 'Bener gak sih "Two" itu artinya angka "2"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q25',
        type: 'unscramble',
        prompt: 'Yuk susun huruf acak ini jadi angka "Sembilan"!',
        targetAnswer: 'nine',
        shuffledLetters: ['e', 'n', 'i', 'n'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'colors',
    chapterTitle: 'Primary Colors',
    chapterDescription: 'Mengenal warna-warna ceria dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q26',
        type: 'quiz',
        prompt: 'Warna favoritmu apa nih? Kalau "Red" itu artinya warna apa ya?',
        targetAnswer: 'Merah',
        options: ['Merah', 'Biru', 'Kuning', 'Putih'],
      ),
      GameQuestion(
        id: 'g1_q27',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya warna "Kuning"!',
        targetAnswer: 'yellow',
      ),
      GameQuestion(
        id: 'g1_q28',
        type: 'fill_blank',
        prompt: 'Isi warna yang hilang: "Daun biasanya warna ______"',
        targetAnswer: 'green',
        options: ['green', 'red', 'blue', 'black'],
      ),
      GameQuestion(
        id: 'g1_q29',
        type: 'true_false',
        prompt: 'Bener gak sih "Blue" itu artinya "Biru"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q30',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi warna kesukaan boneka!',
        targetAnswer: 'pink',
        shuffledLetters: ['k', 'n', 'i', 'p'],
      ),
      GameQuestion(
        id: 'g1_q31',
        type: 'pair',
        prompt: 'Yuk pasangkan warna Bahasa Inggris dan Indonesianya!',
        leftWords: ['Red', 'Blue', 'Green'],
        rightWords: ['Merah', 'Biru', 'Hijau'],
        correctPairs: {'Red': 'Merah', 'Blue': 'Biru', 'Green': 'Hijau'},
      ),
      GameQuestion(
        id: 'g1_q32',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan warna ini ya!',
        leftWords: ['Yellow', 'Black', 'White'],
        rightWords: ['Kuning', 'Hitam', 'Putih'],
        correctPairs: {'Yellow': 'Kuning', 'Black': 'Hitam', 'White': 'Putih'},
      ),
      GameQuestion(
        id: 'g1_q33',
        type: 'guess_picture',
        prompt: 'Bola ini warnanya apa ya?',
        imageEmoji: '🟠',
        targetAnswer: 'Orange',
        options: ['Orange', 'Red', 'Yellow', 'Purple'],
      ),
      GameQuestion(
        id: 'g1_q34',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: naga ini suka warna ungu, Bahasa Inggrisnya apa?',
        bossName: 'Naga Pelangi',
        bossHp: 100,
        targetAnswer: 'Purple',
        options: ['Purple', 'Pink', 'Brown', 'Black'],
      ),
      GameQuestion(
        id: 'g1_q35',
        type: 'listening',
        prompt: 'Dengerin nama warnanya, terus pilih yang bener!',
        targetAnswer: 'Brown',
        options: ['Brown', 'Black', 'Grey', 'Orange'],
      ),
      GameQuestion(
        id: 'g1_q36',
        type: 'quiz',
        prompt: 'Kalau "Purple" itu artinya warna apa ya?',
        targetAnswer: 'Ungu',
        options: ['Ungu', 'Merah muda', 'Coklat', 'Abu-abu'],
      ),
      GameQuestion(
        id: 'g1_q37',
        type: 'true_false',
        prompt: 'Bener gak sih "Black" itu artinya "Putih"?',
        targetAnswer: 'False',
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'animals',
    chapterTitle: 'Cute Animals',
    chapterDescription: 'Mengenal nama-nama hewan lucu dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q38',
        type: 'quiz',
        prompt: 'Tahu gak, kalau "Cat" dalam Bahasa Indonesia artinya apa?',
        targetAnswer: 'Kucing',
        options: ['Kucing', 'Anjing', 'Kelinci', 'Burung'],
      ),
      GameQuestion(
        id: 'g1_q39',
        type: 'guess_picture',
        prompt: 'Tebak yuk, nama hewan lucu ini apa?',
        imageEmoji: '🐱',
        targetAnswer: 'Cat',
        options: ['Cat', 'Dog', 'Rabbit', 'Bird'],
      ),
      GameQuestion(
        id: 'g1_q40',
        type: 'guess_picture',
        prompt: 'Hewan setia yang suka menggonggong ini namanya apa?',
        imageEmoji: '🐶',
        targetAnswer: 'Dog',
        options: ['Dog', 'Cat', 'Bird', 'Fish'],
      ),
      GameQuestion(
        id: 'g1_q41',
        type: 'guess_picture',
        prompt: 'Hewan telinga panjang yang suka lompat ini namanya apa?',
        imageEmoji: '🐰',
        targetAnswer: 'Rabbit',
        options: ['Rabbit', 'Cat', 'Dog', 'Duck'],
      ),
      GameQuestion(
        id: 'g1_q42',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya hewan "Ayam"!',
        targetAnswer: 'chicken',
      ),
      GameQuestion(
        id: 'g1_q43',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang: "The ______ is big and grey" (Gajah)',
        targetAnswer: 'Elephant',
        options: ['Elephant', 'Mouse', 'Cat', 'Bird'],
      ),
      GameQuestion(
        id: 'g1_q44',
        type: 'true_false',
        prompt: 'Bener gak sih "Fish" itu artinya "Ikan"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q45',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi nama hewan yang bisa terbang!',
        targetAnswer: 'bird',
        shuffledLetters: ['d', 'r', 'i', 'b'],
      ),
      GameQuestion(
        id: 'g1_q46',
        type: 'pair',
        prompt: 'Yuk pasangkan nama hewan Bahasa Inggris dan artinya!',
        leftWords: ['Cat', 'Dog', 'Fish'],
        rightWords: ['Kucing', 'Anjing', 'Ikan'],
        correctPairs: {'Cat': 'Kucing', 'Dog': 'Anjing', 'Fish': 'Ikan'},
      ),
      GameQuestion(
        id: 'g1_q47',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan hewan di kandang ini ya!',
        leftWords: ['Duck', 'Cow', 'Goat'],
        rightWords: ['Bebek', 'Sapi', 'Kambing'],
        correctPairs: {'Duck': 'Bebek', 'Cow': 'Sapi', 'Goat': 'Kambing'},
      ),
      GameQuestion(
        id: 'g1_q48',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: raja hutan ini namanya apa dalam Bahasa Inggris?',
        bossName: 'Singa Hutan',
        bossHp: 120,
        targetAnswer: 'Lion',
        options: ['Lion', 'Tiger', 'Bear', 'Wolf'],
      ),
      GameQuestion(
        id: 'g1_q49',
        type: 'listening',
        prompt: 'Dengerin suara hewan ini, tebak namanya!',
        targetAnswer: 'Cow',
        options: ['Cow', 'Goat', 'Sheep', 'Horse'],
      ),
      GameQuestion(
        id: 'g1_q50',
        type: 'quiz',
        prompt: 'Kalau "Butterfly" itu artinya apa ya?',
        targetAnswer: 'Kupu-kupu',
        options: ['Kupu-kupu', 'Lebah', 'Semut', 'Capung'],
      ),
      GameQuestion(
        id: 'g1_q51',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya hewan "Kuda"!',
        targetAnswer: 'horse',
      ),
      GameQuestion(
        id: 'g1_q52',
        type: 'guess_picture',
        prompt: 'Hewan hijau yang suka lompat-lompat di kolam ini apa ya?',
        imageEmoji: '🐸',
        targetAnswer: 'Frog',
        options: ['Frog', 'Fish', 'Turtle', 'Snake'],
      ),
      GameQuestion(
        id: 'g1_q53',
        type: 'true_false',
        prompt: 'Bener gak sih "Snake" itu artinya "Ular"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q54',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi nama hewan yang suka berenang di kolam!',
        targetAnswer: 'duck',
        shuffledLetters: ['k', 'c', 'u', 'd'],
      ),
      GameQuestion(
        id: 'g1_q55',
        type: 'quiz',
        prompt: 'Kalau "Sheep" itu artinya apa ya?',
        targetAnswer: 'Domba',
        options: ['Domba', 'Sapi', 'Kuda', 'Kambing'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'family',
    chapterTitle: 'Family',
    chapterDescription: 'Mengenal anggota keluarga dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q56',
        type: 'quiz',
        prompt: 'Kalau "Mother" itu artinya apa ya?',
        targetAnswer: 'Ibu',
        options: ['Ibu', 'Ayah', 'Kakak', 'Adik'],
      ),
      GameQuestion(
        id: 'g1_q57',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya "Ayah"!',
        targetAnswer: 'father',
      ),
      GameQuestion(
        id: 'g1_q58',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang: "My ______ is kind" (Ibu)',
        targetAnswer: 'mother',
        options: ['mother', 'father', 'sister', 'brother'],
      ),
      GameQuestion(
        id: 'g1_q59',
        type: 'true_false',
        prompt: 'Bener gak sih "Brother" itu artinya "Saudara laki-laki"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q60',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi kata "Kakak/Adik perempuan"!',
        targetAnswer: 'sister',
        shuffledLetters: ['e', 'r', 's', 'i', 's', 't'],
      ),
      GameQuestion(
        id: 'g1_q61',
        type: 'pair',
        prompt: 'Yuk pasangkan anggota keluarga Bahasa Inggris dan artinya!',
        leftWords: ['Mother', 'Father', 'Sister'],
        rightWords: ['Ibu', 'Ayah', 'Kakak Perempuan'],
        correctPairs: {
          'Mother': 'Ibu',
          'Father': 'Ayah',
          'Sister': 'Kakak Perempuan',
        },
      ),
      GameQuestion(
        id: 'g1_q62',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan keluarga besar ini ya!',
        leftWords: ['Brother', 'Grandma', 'Grandpa'],
        rightWords: ['Saudara Laki-laki', 'Nenek', 'Kakek'],
        correctPairs: {
          'Brother': 'Saudara Laki-laki',
          'Grandma': 'Nenek',
          'Grandpa': 'Kakek',
        },
      ),
      GameQuestion(
        id: 'g1_q63',
        type: 'guess_picture',
        prompt: 'Adik kecil yang masih digendong ini namanya apa ya?',
        imageEmoji: '👶',
        targetAnswer: 'Baby',
        options: ['Baby', 'Mother', 'Father', 'Sister'],
      ),
      GameQuestion(
        id: 'g1_q64',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: sebutan untuk nenek dalam Bahasa Inggris apa ayo?',
        bossName: 'Ratu Keluarga',
        bossHp: 100,
        targetAnswer: 'Grandma',
        options: ['Grandma', 'Grandpa', 'Mother', 'Aunt'],
      ),
      GameQuestion(
        id: 'g1_q65',
        type: 'listening',
        prompt: 'Dengerin sebutan keluarga ini, terus pilih yang bener!',
        targetAnswer: 'Father',
        options: ['Father', 'Mother', 'Brother', 'Sister'],
      ),
      GameQuestion(
        id: 'g1_q66',
        type: 'quiz',
        prompt: 'Kalau "Uncle" itu artinya apa ya?',
        targetAnswer: 'Paman',
        options: ['Paman', 'Bibi', 'Kakek', 'Nenek'],
      ),
      GameQuestion(
        id: 'g1_q67',
        type: 'true_false',
        prompt: 'Bener gak sih "Aunt" itu artinya "Paman"?',
        targetAnswer: 'False',
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'fruits',
    chapterTitle: 'Fruits',
    chapterDescription: 'Mengenal nama-nama buah enak dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q68',
        type: 'quiz',
        prompt: 'Kalau "Apple" itu artinya buah apa ya?',
        targetAnswer: 'Apel',
        options: ['Apel', 'Pisang', 'Jeruk', 'Anggur'],
      ),
      GameQuestion(
        id: 'g1_q69',
        type: 'guess_picture',
        prompt: 'Buah kuning yang bentuknya melengkung ini namanya apa?',
        imageEmoji: '🍌',
        targetAnswer: 'Banana',
        options: ['Banana', 'Apple', 'Grape', 'Mango'],
      ),
      GameQuestion(
        id: 'g1_q70',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya buah "Mangga"!',
        targetAnswer: 'mango',
      ),
      GameQuestion(
        id: 'g1_q71',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang: "I like to eat ______" (Pisang)',
        targetAnswer: 'banana',
        options: ['banana', 'apple', 'grape', 'orange'],
      ),
      GameQuestion(
        id: 'g1_q72',
        type: 'true_false',
        prompt: 'Bener gak sih "Grape" itu artinya "Anggur"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q73',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi nama buah "Mangga"!',
        targetAnswer: 'mango',
        shuffledLetters: ['g', 'o', 'n', 'a', 'm'],
      ),
      GameQuestion(
        id: 'g1_q74',
        type: 'pair',
        prompt: 'Yuk pasangkan nama buah Bahasa Inggris dan artinya!',
        leftWords: ['Apple', 'Banana', 'Orange'],
        rightWords: ['Apel', 'Pisang', 'Jeruk'],
        correctPairs: {'Apple': 'Apel', 'Banana': 'Pisang', 'Orange': 'Jeruk'},
      ),
      GameQuestion(
        id: 'g1_q75',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan buah di keranjang ini ya!',
        leftWords: ['Grape', 'Mango', 'Melon'],
        rightWords: ['Anggur', 'Mangga', 'Melon'],
        correctPairs: {'Grape': 'Anggur', 'Mango': 'Mangga', 'Melon': 'Melon'},
      ),
      GameQuestion(
        id: 'g1_q76',
        type: 'guess_picture',
        prompt: 'Buah ungu kecil-kecil yang bergerombol ini namanya apa?',
        imageEmoji: '🍇',
        targetAnswer: 'Grape',
        options: ['Grape', 'Apple', 'Cherry', 'Mango'],
      ),
      GameQuestion(
        id: 'g1_q77',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: buah bulat warna oranye ini namanya apa ayo?',
        bossName: 'Raja Buah',
        bossHp: 100,
        targetAnswer: 'Orange',
        options: ['Orange', 'Apple', 'Lemon', 'Mango'],
      ),
      GameQuestion(
        id: 'g1_q78',
        type: 'listening',
        prompt: 'Dengerin nama buahnya, terus pilih yang bener!',
        targetAnswer: 'Watermelon',
        options: ['Watermelon', 'Melon', 'Grape', 'Mango'],
      ),
      GameQuestion(
        id: 'g1_q79',
        type: 'quiz',
        prompt: 'Kalau "Strawberry" itu artinya buah apa ya?',
        targetAnswer: 'Stroberi',
        options: ['Stroberi', 'Anggur', 'Apel', 'Ceri'],
      ),
      GameQuestion(
        id: 'g1_q80',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya buah "Nanas"!',
        targetAnswer: 'pineapple',
      ),
      GameQuestion(
        id: 'g1_q81',
        type: 'true_false',
        prompt: 'Bener gak sih "Lemon" itu artinya "Jeruk nipis"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q82',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi nama buah "Persik"!',
        targetAnswer: 'peach',
        shuffledLetters: ['c', 'h', 'e', 'a', 'p'],
      ),
    ],
  ),
  const ChapterGameData(
    chapterId: 'school_items',
    chapterTitle: 'School Items',
    chapterDescription: 'Mengenal alat-alat sekolah dalam Bahasa Inggris',
    questions: [
      GameQuestion(
        id: 'g1_q83',
        type: 'quiz',
        prompt: 'Kalau "Book" itu artinya apa ya?',
        targetAnswer: 'Buku',
        options: ['Buku', 'Pensil', 'Tas', 'Penggaris'],
      ),
      GameQuestion(
        id: 'g1_q84',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya alat tulis "Pensil"!',
        targetAnswer: 'pencil',
      ),
      GameQuestion(
        id: 'g1_q85',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang: "I write with a ______" (Pensil)',
        targetAnswer: 'pencil',
        options: ['pencil', 'pen', 'book', 'eraser'],
      ),
      GameQuestion(
        id: 'g1_q86',
        type: 'true_false',
        prompt: 'Bener gak sih "Bag" itu artinya "Tas"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q87',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi alat buat menggaris!',
        targetAnswer: 'ruler',
        shuffledLetters: ['l', 'e', 'r', 'u', 'r'],
      ),
      GameQuestion(
        id: 'g1_q88',
        type: 'pair',
        prompt: 'Yuk pasangkan alat sekolah Bahasa Inggris dan artinya!',
        leftWords: ['Book', 'Pencil', 'Bag'],
        rightWords: ['Buku', 'Pensil', 'Tas'],
        correctPairs: {'Book': 'Buku', 'Pencil': 'Pensil', 'Bag': 'Tas'},
      ),
      GameQuestion(
        id: 'g1_q89',
        type: 'memory',
        prompt: 'Buka kartu memorinya, cocokkan isi tas sekolah ini ya!',
        leftWords: ['Eraser', 'Ruler', 'Scissors'],
        rightWords: ['Penghapus', 'Penggaris', 'Gunting'],
        correctPairs: {
          'Eraser': 'Penghapus',
          'Ruler': 'Penggaris',
          'Scissors': 'Gunting',
        },
      ),
      GameQuestion(
        id: 'g1_q90',
        type: 'guess_picture',
        prompt: 'Alat buat menulis dan menggambar ini namanya apa?',
        imageEmoji: '✏️',
        targetAnswer: 'Pencil',
        options: ['Pencil', 'Pen', 'Ruler', 'Eraser'],
      ),
      GameQuestion(
        id: 'g1_q91',
        type: 'boss_battle',
        prompt: 'Tantangan Boss: alat buat menghapus tulisan pensil namanya apa?',
        bossName: 'Guru Ajaib',
        bossHp: 100,
        targetAnswer: 'Eraser',
        options: ['Eraser', 'Ruler', 'Pencil', 'Book'],
      ),
      GameQuestion(
        id: 'g1_q92',
        type: 'listening',
        prompt: 'Dengerin nama alat sekolah ini, terus pilih yang bener!',
        targetAnswer: 'Scissors',
        options: ['Scissors', 'Ruler', 'Eraser', 'Book'],
      ),
      GameQuestion(
        id: 'g1_q93',
        type: 'quiz',
        prompt: 'Kalau "Chair" itu artinya apa ya?',
        targetAnswer: 'Kursi',
        options: ['Kursi', 'Meja', 'Papan', 'Tas'],
      ),
      GameQuestion(
        id: 'g1_q94',
        type: 'typing',
        prompt: 'Coba ketik Bahasa Inggrisnya "Meja"!',
        targetAnswer: 'table',
      ),
      GameQuestion(
        id: 'g1_q95',
        type: 'true_false',
        prompt: 'Bener gak sih "Board" itu artinya "Papan tulis"?',
        targetAnswer: 'True',
      ),
      GameQuestion(
        id: 'g1_q96',
        type: 'unscramble',
        prompt: 'Susun huruf acak ini jadi alat gambar warna-warni!',
        targetAnswer: 'crayon',
        shuffledLetters: ['n', 'o', 'y', 'a', 'r', 'c'],
      ),
      GameQuestion(
        id: 'g1_q97',
        type: 'guess_picture',
        prompt: 'Tas yang dipakai di punggung buat bawa buku ini namanya apa?',
        imageEmoji: '🎒',
        targetAnswer: 'Bag',
        options: ['Bag', 'Book', 'Pencil', 'Chair'],
      ),
      GameQuestion(
        id: 'g1_q98',
        type: 'quiz',
        prompt: 'Kalau "Pen" itu artinya apa ya?',
        targetAnswer: 'Pulpen',
        options: ['Pulpen', 'Pensil', 'Buku', 'Penggaris'],
      ),
      GameQuestion(
        id: 'g1_q99',
        type: 'fill_blank',
        prompt: 'Isi kata yang hilang: "Please sit on the ______" (Kursi)',
        targetAnswer: 'chair',
        options: ['chair', 'table', 'bag', 'book'],
      ),
      GameQuestion(
        id: 'g1_q100',
        type: 'boss_battle',
        prompt: 'Tantangan terakhir! Alat buat menggambar warna-warni namanya apa?',
        bossName: 'Raja Kelas',
        bossHp: 150,
        targetAnswer: 'Crayon',
        options: ['Crayon', 'Pencil', 'Pen', 'Eraser'],
      ),
    ],
  ),
];