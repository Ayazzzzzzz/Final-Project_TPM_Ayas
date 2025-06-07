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
    await Future.delayed(const Duration(seconds: 2));
    final session = await _authService.checkLoginStatus(); 
    
    if (!mounted) return;

    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()), 
      );
    } else {
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