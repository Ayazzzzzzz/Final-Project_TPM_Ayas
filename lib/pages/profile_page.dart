// lib/pages/profile_page.dart
import 'dart:io'; // Untuk File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar
import 'package:path_provider/path_provider.dart'; // Untuk path direktori
import 'package:path/path.dart' as p; // Untuk join path dan basename
import 'package:ta_mobile_ayas/models/user_model.dart';
import 'package:ta_mobile_ayas/pages/login_page.dart';
import 'package:ta_mobile_ayas/pages/services/auth_service.dart';

import '../main.dart'; // Untuk mengakses userBoxName
// Untuk navigasi setelah logout

import 'package:hive/hive.dart'; // Diperlukan jika Anda mengakses Hive Box secara langsung

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  File? _profileImageFileForDisplay;
  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    if (!mounted) return;
    setState(() => _isLoadingUserData = true);
    final sessionData = await _authService.checkLoginStatus();
    if (sessionData != null && sessionData['userId'] != null) {
      // Akses Hive box untuk mendapatkan data User lengkap
      final userBox =
          await Hive.openBox<User>(userBoxName); // Pastikan box dibuka
      final user = userBox.get(sessionData['userId']!.toLowerCase());
      // Jangan lupa tutup box jika sudah tidak digunakan di page ini atau gunakan Hive.box<User>(userBoxName) jika sudah dibuka di main
      // await userBox.close(); // Pertimbangkan ini jika hanya sekali akses

      if (mounted) {
        setState(() {
          _currentUser = user;
          if (user?.profilePicturePath != null &&
              user!.profilePicturePath!.isNotEmpty) {
            final potentialFile = File(user.profilePicturePath!);
            if (potentialFile.existsSync()) {
              // Selalu cek apakah file ada
              _profileImageFileForDisplay = potentialFile;
            } else {
              _profileImageFileForDisplay =
                  null; // Path ada tapi file tidak, set null
              debugPrint(
                  "Profile picture file not found at: ${user.profilePicturePath}");
            }
          } else {
            _profileImageFileForDisplay = null; // Path null atau kosong
          }
          _isLoadingUserData = false;
        });
      }
    } else if (mounted) {
      setState(() => _isLoadingUserData = false);
      // Mungkin navigasi ke login jika tidak ada sesi
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  // Future<void> _pickAndSaveImage() async {
  //   if (_currentUser == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('User data not loaded. Cannot change picture.')),
  //     );
  //     return;
  //   }

  //   final picker = ImagePicker();
  //   final XFile? pickedFile =
  //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

  //   if (pickedFile != null) {
  //     final File imageFile = File(pickedFile.path);

  //     final directory = await getApplicationDocumentsDirectory();
  //     final String fileExtension = p.extension(imageFile.path);
  //     final String fileName =
  //         'profile_${_currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
  //     final String newPath = p.join(directory.path, fileName);

  //     try {
  //       final File newImage = await imageFile.copy(newPath);
  //       bool success = await _authService.updateUserProfilePicture(
  //           _currentUser!.id, newImage.path);

  //       if (success && mounted) {
  //         setState(() {
  //           _profileImageFileForDisplay = newImage;
  //           _currentUser?.profilePicturePath = newImage.path;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
  //         );
  //       } else if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Gagal menyimpan path foto profil.')),
  //         );
  //       }
  //     } catch (e) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error menyimpan gambar: $e')),
  //         );
  //       }
  //     }
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Pemilihan gambar dibatalkan.')),
  //       );
  //     }
  //   }
  // }

  Future<void> _pickAndUploadImage() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User data not loaded. Cannot change picture.')),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      final directory = await getApplicationDocumentsDirectory();
      final String fileExtension = p.extension(imageFile.path);
      final String fileName =
          'profile_${_currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final String newPath = p.join(directory.path, fileName);

      try {
        final File newImage = await imageFile.copy(newPath);
        bool success = await _authService.updateUserProfilePicture(
            _currentUser!.id, newImage.path);

        if (success && mounted) {
          setState(() {
            _profileImageFileForDisplay = newImage;
            _currentUser?.profilePicturePath = newImage.path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan path foto profil.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error menyimpan gambar: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemilihan gambar dibatalkan.')),
        );
      }
    }
  }

  void _logout() async {
    await _authService.logoutUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget profilePicWidget;
    if (_profileImageFileForDisplay != null &&
        _profileImageFileForDisplay!.existsSync()) {
      profilePicWidget =
          Image.file(_profileImageFileForDisplay!, fit: BoxFit.cover);
    } else {
      profilePicWidget = Icon(Icons.person_rounded,
          size: 70, color: theme.colorScheme.onPrimaryContainer);
    }

    return Scaffold(
      // AppBar sudah ada di MainLayout, jadi body langsung
      body: _isLoadingUserData
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tidak dapat memuat data pengguna."),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text("Kembali ke Login"))
                  ],
                ))
              : Center(
                  // Menggunakan Center untuk konten profil
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Profil Pengguna",
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 80, // Perbesar avatar
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: profilePicWidget,
                                ),
                              ),
                            ),
                            Material(
                              color: theme
                                  .colorScheme.primary, // Warna tombol edit
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              elevation: 2,
                              child: InkWell(
                                onTap: _pickAndUploadImage,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.edit_rounded,
                                      size: 24,
                                      color: theme.colorScheme.onPrimary),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _currentUser!.username,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentUser!.email,
                          style: theme.textTheme.titleMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.errorContainer,
                              foregroundColor:
                                  theme.colorScheme.onErrorContainer,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
