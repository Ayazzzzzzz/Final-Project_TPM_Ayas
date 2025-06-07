import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:ta_mobile_ayas/data/titan_fact.dart'; 
import 'package:ta_mobile_ayas/models/user_model.dart';
import 'package:ta_mobile_ayas/pages/login_page.dart';
import 'package:ta_mobile_ayas/pages/services/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../main.dart';

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
  String _randomTitanFact = "";

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFacts();
  }

  Future<void> _loadUserDataAndFacts() async {
    await _loadCurrentUserData();
    _loadRandomFact();
  }

  void _loadRandomFact() {
    setState(() {
      _randomTitanFact = getRandomTitanFact();
    });
  }

  Future<void> _loadCurrentUserData() async {
    if (!mounted) return;
    setState(() => _isLoadingUserData = true);
    final sessionData = await _authService.checkLoginStatus();
    if (sessionData != null && sessionData['userId'] != null) {
      final userBox = await Hive.openBox<User>(userBoxName);
      final user = userBox.get(sessionData['userId']!.toLowerCase());
      if (mounted) {
        setState(() {
          _currentUser = user;
          if (user?.profilePicturePath != null &&
              user!.profilePicturePath!.isNotEmpty) {
            final file = File(user.profilePicturePath!);
            if (file.existsSync()) {
              _profileImageFileForDisplay = file;
            }
          }
          _isLoadingUserData = false;
        });
      }
    } else if (mounted) {
      setState(() => _isLoadingUserData = false);
    }
  }

  Future<void> _pickAndSaveImage() async {
    if (_currentUser == null) return;
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
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Foto profil berhasil diperbarui!')));
        }
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menyimpan gambar: $e')));
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

    return Scaffold(
      body: _isLoadingUserData
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? _buildLoginPrompt(context)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "My Profile",
                        style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSerif'),
                      ),
                      const SizedBox(height: 24),

                      // --- KOTAK 1: DATA PENGGUNA ---
                      _buildUserCard(theme),
                      const SizedBox(height: 24),

                      _buildTitanFactCard(theme),
                      const SizedBox(height: 32),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Logout'),
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: theme.colorScheme.errorContainer,
                            foregroundColor: theme.colorScheme.onErrorContainer,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildUserCard(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Sisi Kiri: Gambar Profil dengan Tombol Edit
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  backgroundImage: _profileImageFileForDisplay != null
                      ? FileImage(_profileImageFileForDisplay!)
                      : null,
                  child: _profileImageFileForDisplay == null
                      ? Icon(Icons.person_rounded,
                          size: 40, color: theme.colorScheme.onSurfaceVariant)
                      : null,
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    onPressed: _pickAndSaveImage,
                    tooltip: 'Ganti foto profil',
                    mini: true,
                    elevation: 2,
                    child: const Icon(Icons.edit, size: 16),
                  ),
                )
              ],
            ),
            const SizedBox(width: 16),
            // Sisi Kanan: Username dan Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUser!.username,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser!.email,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey[400]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitanFactCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Titan Fact of the Day",
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, fontFamily: 'NotoSerif'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadRandomFact,
                  tooltip: 'Get a new fact',
                ),
              ],
            ),
            const Divider(height: 8, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 4.0),
              child: Text(
                _randomTitanFact,
                style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.9)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Tidak dapat memuat data pengguna."),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Kembali ke Login"))
        ],
      ),
    );
  }
}
