// lib/data/dummy/character_quotes.dart
final Map<String, List<String>> characterIconicQuotes = {
  // Menggunakan List<String> agar satu karakter bisa punya beberapa kutipan acak
  "Eren Jaeger": [
    "If you win, you live. If you lose, you die. If you don't fight, you can't win!",
    "I'll destroy them! Every last one of those animals that's on this earth!",
    "Keep moving forward."
  ],
  "Mikasa Ackerman": [
    "This world is cruel, but also very beautiful.",
    "If I can't, then I'll just die. But if I win, I live. Unless I fight, I cannot win."
  ],
  "Armin Arlelt": [
    "To surpass monsters, you must be willing to abandon your humanity.",
    "Someone who can't sacrifice anything, can't ever change anything."
  ],
  "Levi Ackerman": [
    "The only thing we're allowed to do is to believe that we won't regret the choice we made.",
    "Give up on your dream and die."
  ],
  "Erwin Smith": [
    "My soldiers, rage! My soldiers, scream! My soldiers, fight!",
    "Dedicate your hearts! (Shinzou wo Sasageyo!)"
  ],
  "Hange Zoë": [
    "If there's something you don't understand, learn about it.",
    "Titans are magnificent, aren't they?"
  ],
  "Jean Kirschtein": [
    "We're not all that different, are we? We've all got our own ideas about what's right."
  ],
  // Tambahkan lebih banyak karakter dan kutipan mereka di sini
  // Pastikan nama karakter di sini SAMA PERSIS dengan nama di API
};

// Fungsi helper untuk mendapatkan kutipan acak, dengan fallback jika tidak ada
String getQuoteByCharacterName(String characterName) {
  final List<String>? quotes = characterIconicQuotes[characterName];
  if (quotes != null && quotes.isNotEmpty) {
    // Ambil kutipan acak dari list
    return quotes[(DateTime.now().millisecondsSinceEpoch % quotes.length)];
  }
  return "Shinzou wo Sasageyo!"; // Kutipan default jika tidak ditemukan
}
