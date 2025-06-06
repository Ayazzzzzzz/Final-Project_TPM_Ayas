// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/main_layout.dart';
import 'package:ta_mobile_ayas/pages/login_page.dart';
import 'dart:async';

import 'package:ta_mobile_ayas/pages/services/auth_service.dart';
// Halaman login

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  void _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Efek splash
    final session = await _authService.checkLoginStatus(); // Cek sesi login [cite: 33]
    
    if (!mounted) return;

    if (session != null) {
      // Jika ada sesi, langsung ke halaman utama
      // Anda bisa mengirim data user dari sesi ke MainLayout jika perlu
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()), // Anda mungkin perlu passing username ke MainLayout
      );
    } else {
      // Jika tidak ada sesi, ke halaman login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Memuat Aplikasi..."),
          ],
        ),
      ),
    );
  }
}