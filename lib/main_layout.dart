import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/pages/event_page.dart';
import 'package:ta_mobile_ayas/pages/home_page.dart';
import 'package:ta_mobile_ayas/pages/saran_page.dart';
import 'package:ta_mobile_ayas/pages/profile_page.dart';
import 'package:ta_mobile_ayas/pages/services/auth_service.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  String _loggedInUsername = "Guest"; // Default username

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final session = await _authService.checkLoginStatus();
    if (mounted && session != null && session['username'] != null) {
      setState(() {
        _loggedInUsername = session['username']!;
      });
    }
  }

  // Daftar halaman yang akan ditampilkan
  List<Widget> get _pages => <Widget>[
        // Kirim username ke HomePage
        HomePage(username: _loggedInUsername),
        const EventsPage(),
        const SaranPage(),
        const ProfilePage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // <-- ITEM BARU UNTUK EVENTS
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_rounded),
            label: 'Saran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        elevation: 4,
      ),
    );
  }
}
