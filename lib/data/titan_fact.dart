import 'dart:math';

final List<String> _titanFacts = [
  "Titan Murni (Pure Titans) secara naluriah akan memburu manusia terdekat, namun mereka tidak butuh makan untuk bertahan hidup. Mereka mendapatkan energi dari sinar matahari.",
  "Leher bagian belakang (nape of the neck) adalah satu-satunya titik lemah fatal bagi semua Titan. Ukurannya persis 1 meter dan lebar 10 cm.",
  "The Founding Titan memiliki kemampuan untuk mengontrol semua Titan dan memanipulasi ingatan para Subjects of Ymir.",
  "Dinding (Walls) di Pulau Paradis sebenarnya terbuat dari jutaan Colossal Titan yang kulitnya mengeras.",
  "Seorang Titan Shifter akan mewarisi ingatan dari para pewaris sebelumnya jika mereka melakukan kontak dengan Titan lain yang memiliki darah kerajaan (royal blood).",
  "Armored Titan memiliki pelat baja yang mengeras di sekujur tubuhnya, menjadikannya tank berjalan yang sulit ditembus senjata biasa.",
  "Beast Titan, tergantung pewarisnya, bisa memiliki karakteristik hewan yang berbeda. Zeke Yeager memiliki bentuk seperti kera raksasa.",
  "Selama timeskip, Hange Zoë menemukan bahwa Titan dulunya adalah manusia, sebuah kebenaran yang coba ditutupi oleh pemerintah di dalam dinding.",
];

String getRandomTitanFact() {
  final random = Random();
  return _titanFacts[random.nextInt(_titanFacts.length)];
}
