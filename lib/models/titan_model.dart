class Titan {
  final int id;
  final String name;
  final String? img;
  final String? height;
  final List<String> abilities;
  final String? currentInheritor; 
  final List<String> formerInheritors; 
  final dynamic allegiance; 

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
      allegiance: json['allegiance'], 
    );
  }

  String get primaryInfo => height ?? 'Unknown Height';
  String get displayImage => img ?? 'https://via.placeholder.com/200x300.png?text=No+Image';
}