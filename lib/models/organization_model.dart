// lib/domain/models/organization_model.dart

class Organization {
  final int id;
  final String name;
  final String? img;
  final List<String> occupations;
  final List<String> notableMembers; // Ini adalah list URL
  final List<String> notableFormerMembers; // Ini adalah list URL
  final String? affiliation;
  final String? debut; // Ini adalah URL

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

  // Informasi penting untuk ditampilkan di grid
  String get primaryInfo => affiliation ?? 'Unknown Affiliation';
  String get displayImage => img ?? 'https://via.placeholder.com/200x300.png?text=No+Image';
}