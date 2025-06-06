// lib/domain/models/titan_model.dart

class Titan {
  final int id;
  final String name;
  final String? img;
  final String? height;
  final List<String> abilities;
  final String? currentInheritor; // Ini adalah URL
  final List<String> formerInheritors; // Ini adalah list URL
  final dynamic allegiance; // Bisa jadi string atau list

  Titan({
    required this.id,
    required this.name,
    this.img,
    this.height,
    required this.abilities,
    this.currentInheritor,
    required this.formerInheritors,
    this.allegiance,
  });

  factory Titan.fromJson(Map<String, dynamic> json) {
    return Titan(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      height: json['height'],
      abilities: List<String>.from(json['abilities'] ?? []),
      currentInheritor: json['current_inheritor'],
      formerInheritors: List<String>.from(json['former_inheritors'] ?? []),
      allegiance: json['allegiance'], // Biarkan dinamis, handle di UI
    );
  }

  // Informasi penting untuk ditampilkan di grid
  String get primaryInfo => height ?? 'Unknown Height';
  String get displayImage => img ?? 'https://via.placeholder.com/200x300.png?text=No+Image';
}