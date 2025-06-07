import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_mobile_ayas/models/user_model.dart';
import '../../main.dart'; 

class AuthService {
  final Box<User> _userBox = Hive.box<User>(userBoxName);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes); 
    return digest.toString(); 
  }

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    String? initialProfilePicPath, 
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
      profilePicturePath: initialProfilePicPath, 
    );
    try {
      await _userBox.put(userId, newUser);
      return null;
    } catch (e) {
      return 'Registrasi gagal: ${e.toString()}';
    }
  }

  Future<bool> updateUserProfilePicture(String userId, String newPath) async {
    final user = _userBox.get(userId.toLowerCase());
    if (user != null) {
      user.profilePicturePath = newPath;
      try {
        await user.save(); 
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
        .get(userId); 

    if (user == null) {
      return null;
    }

    final hashedPassword = _hashPassword(password);
    if (user.hashedPassword == hashedPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUserId',
          user.id);
      await prefs.setString('loggedInUsername', user.username);

      return {
        'id': user.id,
        'username': user.username,
        'email': user.email,
      };
    }
    return null; 
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId'); 
    await prefs.remove('loggedInUsername');
  }

  Future<Map<String, String?>?> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loggedInUserId');
    final username = prefs.getString('loggedInUsername');
    if (userId != null && username != null) {
      return {'userId': userId, 'username': username};
    }
    return null;
  }
}
