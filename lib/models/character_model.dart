class Character {
  final int id;
  final String name;
  final String? img; // Gambar bisa null
  final List<String> alias;
  final List<String> species;
  final String? gender;
  final dynamic age; // Bisa jadi String atau int dari API
  final String? height;
  final List<RelativeGroup> relatives;
  final String? birthplace;
  final String? residence;
  final String? status;
  final String? occupation;
  final List<GroupAffiliation> groups;
  final List<String> roles;
  final List<String> episodes;

  Character({
    required this.id,
    required this.name,
    this.img,
    required this.alias,
    required this.species,
    this.gender,
    this.age,
    this.height,
    required this.relatives,
    this.birthplace,
    this.residence,
    this.status,
    this.occupation,
    required this.groups,
    required this.roles,
    required this.episodes,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      alias: List<String>.from(json['alias'] ?? []),
      species: List<String>.from(json['species'] ?? []),
      gender: json['gender'],
      age: json['age'], // Biarkan dinamis, konversi di UI jika perlu
      height: json['height'],
      relatives: (json['relatives'] as List<dynamic>?)
              ?.map((e) => RelativeGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      birthplace: json['birthplace'],
      residence: json['residence'],
      status: json['status'],
      occupation: json['occupation'],
      groups: (json['groups'] as List<dynamic>?)
              ?.map((e) => GroupAffiliation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      roles: List<String>.from(json['roles'] ?? []),
      episodes: List<String>.from(json['episodes'] ?? []),
    );
  }
  
  String get primaryInfo => occupation ?? (species.isNotEmpty ? species.first : 'Unknown');
  String get displayImage => img ?? 'https://via.placeholder.com/200x300.png?text=No+Image';

}

class RelativeGroup {
  final String family;
  final List<String> members;

  RelativeGroup({required this.family, required this.members});

  factory RelativeGroup.fromJson(Map<String, dynamic> json) {
    return RelativeGroup(
      family: json['family'],
      members: List<String>.from(json['members']?.map((m) => m.toString()) ?? []),
    );
  }
}

class GroupAffiliation {
  final String name;
  final List<String> subGroups;

  GroupAffiliation({required this.name, required this.subGroups});

  factory GroupAffiliation.fromJson(Map<String, dynamic> json) {
    return GroupAffiliation(
      name: json['name'],
      subGroups: List<String>.from(json['sub_groups'] ?? []),
    );
  }
}