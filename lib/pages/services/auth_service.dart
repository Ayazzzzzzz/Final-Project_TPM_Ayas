// lib/data/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Untuk utf8.encode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile_ayas/models/user_model.dart';
import '../../main.dart'; // Untuk userBoxName

class AuthService {
  final Box<User> _userBox = Hive.box<User>(userBoxName);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Encode password ke bytes
    final digest = sha256.convert(bytes); // Hash menggunakan SHA-256
    return digest.toString(); // Kembalikan sebagai string
  }

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    String? initialProfilePicPath, // Tambahkan parameter opsional
  }) async {
    final userId = email.toLowerCase();
    if (_userBox.containsKey(userId)) {
      return 'Email sudah terdaftar.';
    }
    final hashedPassword = _hashPassword(password);
    final newUser = User(
      id: userId,
      username: username,
      email: email,
      hashedPassword: hashedPassword,
      profilePicturePath: initialProfilePicPath, // Simpan path awal
    );
    try {
      await _userBox.put(userId, newUser);
      return null;
    } catch (e) {
      return 'Registrasi gagal: ${e.toString()}';
    }
  }

  // Fungsi untuk update foto profil
  Future<bool> updateUserProfilePicture(String userId, String newPath) async {
    final user = _userBox.get(userId.toLowerCase());
    if (user != null) {
      user.profilePicturePath = newPath;
      try {
        await user.save(); // HiveObject bisa di-save langsung
        // Atau jika key-nya adalah user.id: await _userBox.put(user.id, user);
        return true;
      } catch (e) {
        debugPrint("Error updating profile picture in Hive: $e");
        return false;
      }
    }
    return false;
  }

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final userId = email.toLowerCase();
    final user = _userBox
        .get(userId); // Mengambil user dari Hive menggunakan key [cite: 10]

    if (user == null) {
      return null; // Pengguna tidak ditemukan
    }

    final hashedPassword = _hashPassword(password);
    if (user.hashedPassword == hashedPassword) {
      // Password cocok, login berhasil
      // Simpan sesi menggunakan Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUserId',
          user.id); // Simpan ID pengguna yang login [cite: 13]
      await prefs.setString('loggedInUsername', user.username);

      return {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        // Jangan kembalikan password atau hashedPassword
      };
    }
    return null; // Password salah
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId'); // Hapus ID dari sesi [cite: 13]
    await prefs.remove('loggedInUsername');
  }

  Future<Map<String, String?>?> checkLoginStatus() async {
    // Mengambil data sesi [cite: 15]
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loggedInUserId');
    final username = prefs.getString('loggedInUsername');
    if (userId != null && username != null) {
      return {'userId': userId, 'username': username};
    }
    return null;
  }
}
