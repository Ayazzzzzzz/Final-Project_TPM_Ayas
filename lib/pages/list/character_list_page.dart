// lib/pages/list/character_list_page.dart

import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/models/character_model.dart';
import 'package:ta_mobile_ayas/services/api_service.dart';
import '../detail/character_detail_page.dart'; // Halaman baru yang akan kita buat

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Character>> _characterFuture;
  List<Character> _allCharacters = [];
  List<Character> _displayedCharacters = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _characterFuture = _loadCharacters();
    _searchController.addListener(_filterCharacters);
  }

  Future<List<Character>> _loadCharacters() async {
    _allCharacters = await _apiService.getAllCharacters();
    _displayedCharacters = _allCharacters;
    return _displayedCharacters;
  }

  void _filterCharacters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedCharacters = _allCharacters.where((character) {
        return character.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Characters"),
        // Di sini nanti bisa ditambahkan tombol filter
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Character',
                hintText: 'e.g., Eren Yeager',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Grid
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _characterFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No characters found."));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2 / 3, // Aspek rasio kartu
                  ),
                  itemCount: _displayedCharacters.length,
                  itemBuilder: (context, index) {
                    final character = _displayedCharacters[index];
                    return CharacterGridCard(character: character);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget terpisah untuk kartu grid agar rapi
class CharacterGridCard extends StatelessWidget {
  const CharacterGridCard({super.key, required this.character});
  final Character character;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailPage(character: character),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              character.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child: Hero(
            tag: 'character-${character.id}', // Tag unik untuk animasi
            child: Image.network(
              character.img!,
              fit: BoxFit.cover,
              // Tampilkan loading indicator saat gambar dimuat
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              // Tampilkan icon error jika gambar gagal dimuat
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person_off,
                    size: 50, color: Colors.grey);
              },
            ),
          ),
        ),
      ),
    );
  }
}
