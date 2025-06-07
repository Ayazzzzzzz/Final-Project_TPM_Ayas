// lib/domain/models/organization_model.dart

class Organization {
  final int id;
  final String name;
  final String? img;
  final List<String> occupations;
  final List<String> notableMembers; 
  final List<String> notableFormerMembers;
  final String? affiliation;
  final String? debut; 

  Organization({
    required this.id,
    required this.name,
    this.img,
    required this.occupations,
    required this.notableMembers,
    required this.notableFormerMembers,
    this.affiliation,
    this.debut,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      occupations: List<String>.from(json['occupations'] ?? []),
      notableMembers: List<String>.from(json['notable_members'] ?? []),
      notableFormerMembers: List<String>.from(json['notable_former_members'] ?? []),
      affiliation: json['affiliation'],
      debut: json['debut'],
    );
  }

  String get primaryInfo => affiliation ?? 'Unknown Affiliation';
  String get displayImage => img ?? 'https://via.placeholder.com/200x300.png?text=No+Image';
}