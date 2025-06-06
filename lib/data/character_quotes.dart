// lib/data/dummy/character_quotes.dart
final Map<String, List<String>> characterIconicQuotes = {
  // Menggunakan List<String> agar satu karakter bisa punya beberapa kutipan acak
  "Eren Jaeger": [
    "If you win, you live. If you lose, you die. If you don't fight, you can't win!",
    "I'll destroy them! Every last one of those animals that's on this earth!",
    "Keep moving forward."
  ],

  "Armin Arlert": [
    "To surpass monsters, you must be willing to abandon your humanity.",
    "Someone who can't sacrifice anything, can't ever change anything.",
    "People are crazy for believing that these walls will protect us forever.",
    "I’d rather die than become a burden.",
    "Nothing can suppress a human’s curiosity."
  ],
  "Levi Ackerman": [
    "The only thing we're allowed to do is to believe that we won't regret the choice we made.",
    "Give up on your dream and die.",
    "If you don’t want to die, think!",
    "No casualties. Don’t you dare die!",
    "The lesson you need to learn right now can’t be taught with words, only with action.",
    "Choose whatever you'll regret the least.",
    "What is more important: to protect or to destroy?",
    "Nothing is more dangerous than a person with nothing to lose."
  ],
  "Erwin Smith": [
    "My soldiers, rage! My soldiers, scream! My soldiers, fight!",
    "Dedicate your hearts! (Shinzou wo Sasageyo!)",
    "If you begin to regret, you’ll dull your future decisions and let others make your choices for you.",
    "The Titans are not our enemies. They are merely reflections of who we are.",
    "Revenge is a two-edged sword.",
    "Titans are not the greatest enemy. The greatest enemy is fear."
  ],
  "Hange Zoë": [
    "If there's something you don't understand, learn about it.",
    "Titans are magnificent, aren't they?",
    "Even in moments of the deepest despair… I guess we can still find hope, huh?",
    "Screw your inferiority complex. Don’t run from reality."
  ],
  "Jean Kirstein": [
    "We're not all that different, are we? We've all got our own ideas about what's right.",
    "Everyone is a hero when he has someone to save.",
    "Death is inevitable for everyone, but living in fear is a choice."
  ],
  "Historia Reiss": [
    "We need to stop living for others. From now on… Let’s live for ourselves!",
    "Even if you have your reasons and there are things you can’t tell me, no matter what, I’m on your side.",
    "We are the ones who shape our own destiny."
  ],

  "Mikasa Ackermann": [
    "Once I'm dead, I won't even be able to remember you. So I'll win, no matter what. I'll live, no matter what!",
    "You don't stand a single chance to win, unless you fight.",
    "I am strong. Stronger than all of you. Extremely strong. I can kill all the titans out there. Even if I am alone.",
    "My specialty is slicing up flesh. If need be, I'm prepared to display it. Anyone interested in experiencing my skills firsthand, step right up.",
    "Only victors are allowed to live... this world is merciless like that.",
    "Take a deep breath. This isn't a time to be emotional. Stand up.",
    "There are only so many lives I can value. And... I decided who those people were six years ago. So... You shouldn't try to ask for my pity. Because right now, I don't have... Time to spare or room in my heart.",
    "Believe in your own power."
  ],

  "Conny Springer": [
    "Whatever that damn ape is, I'll never forgive it.",
    "All I care about... is getting a chance to fight that Beast Titan.",
    "Give it back.",
    "Nobody else in the area!",
    "If we hadn't left right then, what would've happened to us?",
    "Why is the royal family's flag hanging everywhere?",
    "Yeah, that's it!",
    "It's about time to switch lookouts.",
    "Mikasa?",
    "That was close...",
    "So... All I have left is this picture… And my mum.",
    "Who is it… Who would do this to us… I definitely... Won't forgive them."
  ],

  "Sasha Blouse": [
    "It's alright. Even if you're weak, there'll be people who come to your rescue. Maybe you won't meet them right away, but don't give up and keep running until you meet them!",
    "You seriously don't know why human beings eat potatoes?",
    "I won't! Probably...",
    "I mean, Christa and Eren!",
    "Because we're talented, I assume.",
    "Nothing bread-related.",
    "Someone's coming from that way!",
    "More than one!",
    "Oh! Today must be the anniversary of the King's coronation.",
    "Once a year, they hand out a haul of rations.",
    "What a King! He sure is generous!",
    "If you move again, who knows where I'll hit?",
    "It looked quite delicious and it was getting cold, so I gave it shelter in my stomach, sir.",
    "Meat."
  ],
  "Levi Ackermann": [
    "The only thing we're allowed to do is believe that we won't regret the choice we made.",
    "Give up on your dreams and die.",
    "Just do the best you can and choose whichever you'll regret the least.",
    "The difference between your decision and ours is experience. But you don't have to rely on that.",
    "This is just my opinion, but when it comes to teaching somebody discipline... I think pain is the most effective way.",
    "Whether you have the body, dead is dead.",
    "We can't always carry our fallen comrades home, but we carry their memory.",
    "You can't change anything unless you can discard part of yourself too. To surpass monsters, you must be willing to abandon your humanity.",
    "I don't know which option you should choose. I could never advise you on that... No matter what kind of wisdom dictates the option you pick, no one will be able to tell if it's right or wrong until you arrive at some sort of outcome from your choice.",
    "You either will, or you won't."
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
