import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:ta_mobile_ayas/pages/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  File? _selectedImageFile;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  void _register() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Username, email, dan password harus diisi.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    String? savedImagePath;
    if (_selectedImageFile != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final String fileExtension = p.extension(_selectedImageFile!.path);
        final String fileName =
            'profile_${email.toLowerCase().replaceAll('@', '_').replaceAll('.', '_')}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final String newPath = p.join(directory.path, fileName);

        await _selectedImageFile!.copy(newPath);
        savedImagePath = newPath;
      } catch (e) {
        debugPrint("Error saving image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal menyimpan gambar profil: ${e.toString()}')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    final errorMessage = await _authService.registerUser(
      username: username,
      email: email,
      password: password,
      initialProfilePicPath: savedImagePath,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
            style: TextStyle(
                fontFamily: 'NotoSerif', fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
      ),
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join the Corps',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: 'NotoSerif',
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  // Pusatkan CircleAvatar
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 65, 
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      foregroundImage: _selectedImageFile != null
                          ? FileImage(_selectedImageFile!)
                          : null,
                      child: _selectedImageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined,
                                    size: 36,
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withOpacity(0.7)),
                                const SizedBox(height: 4),
                                Text("Add Photo",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: theme
                                            .colorScheme.onSurfaceVariant
                                            .withOpacity(0.7)))
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.person_outline,
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
                ),
                const SizedBox(height: 20),
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
                        onPressed: _register,
                        child: Text('REGISTER',
                            style: TextStyle(
                                fontFamily: 'NotoSerif', letterSpacing: 1)),
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
