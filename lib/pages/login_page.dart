import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/main_layout.dart';
import 'package:ta_mobile_ayas/pages/register_page.dart';
import 'package:ta_mobile_ayas/pages/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final user = await _authService.loginUser(email: email, password: password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login gagal. Email atau password salah.')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: 400), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons
                      .shield_outlined, 
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'AOT Fanbase Hub',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSerif',
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to continue',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),
                // Form Input
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: theme.colorScheme.secondary),
                    filled: true,
                    fillColor: theme.colorScheme.surface.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: theme.colorScheme.secondary),
                    filled: true,
                    fillColor: theme.colorScheme.surface.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: theme.elevatedButtonTheme.style?.copyWith(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16)),
                        ),
                        onPressed: _login,
                        child: Text('LOGIN',
                            style: TextStyle(
                                fontFamily: 'NotoSerif', letterSpacing: 1)),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      //   ],
      // ),
    );
  }
}
