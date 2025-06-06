// lib/domain/models/user_model.dart
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String hashedPassword;

  @HiveField(4) // Field baru untuk path foto profil
  String? profilePicturePath; 

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.hashedPassword,
    this.profilePicturePath, // Tambahkan di constructor
  });
}