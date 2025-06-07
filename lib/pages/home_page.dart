import 'dart:async'; 
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/models/character_model.dart';
import 'package:ta_mobile_ayas/models/organization_model.dart';
import 'package:ta_mobile_ayas/models/titan_model.dart';
import 'package:ta_mobile_ayas/pages/merch_page.dart';
import 'package:ta_mobile_ayas/pages/widgets/data_grid_card.dart';
import 'package:ta_mobile_ayas/services/api_service.dart'; 
import 'package:sensors_plus/sensors_plus.dart'; 

enum DisplayCategory { character, titan, organization }

class HomePage extends StatefulWidget {
  final String username; 

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  DisplayCategory _selectedCategory = DisplayCategory.character;
  List<dynamic> _allItems = [];
  List<dynamic> _displayedItems = [];
  bool _isLoading = true;
  List<String> _uniqueOccupations = [];
  String? _selectedOccupationFilter;

  StreamSubscription? _accelerometerSubscription;
  bool _isProcessingShake = false;
  DateTime? _lastShakeTime;
  final Random _random = Random();
  List<Titan> _titansForSummon = [];
  bool _isLoadingTitansForSummon = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterAndSearchItems);
    _initAccelerometerListener(); 
  }

  @override
  void dispose() {
    _searchController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Fetch data untuk kategori default (character)
    await _fetchDataForCategory(_selectedCategory, initialLoad: true);
    // Fetch data titan untuk fitur summon (bisa berjalan di latar belakang)
    if (mounted && _titansForSummon.isEmpty && !_isLoadingTitansForSummon) {
      _fetchTitansForSummonFeature();
    }
  }

  void _extractUniqueOccupations() {
    if (!mounted) return;

    if (_selectedCategory == DisplayCategory.character &&
        _allItems.isNotEmpty) {
      final List<String?> nullableOccupations = _allItems
          .whereType<
              Character>() 
          .map((char) => char
              .occupation) 
          .toList();

      final List<String> validOccupations = nullableOccupations
          .where((occ) =>
              occ != null && occ.isNotEmpty) 
          .cast<String>() 
          .toSet() 
          .toList();

      validOccupations.sort();

      if (!const ListEquality().equals(_uniqueOccupations, validOccupations)) {
        if (mounted) {
          setState(() {
            _uniqueOccupations =
                validOccupations; 
            debugPrint(
                "${_uniqueOccupations.length} unique occupations found: $_uniqueOccupations");
          });
        }
      }
    } else {
      if (_uniqueOccupations.isNotEmpty) {
        if (mounted) {
          setState(() {
            _uniqueOccupations = [];
          });
        }
      }
    }
  }

  Future<void> _fetchDataForCategory(DisplayCategory category,
      {bool initialLoad = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _displayedItems = [];
      _allItems = [];
      if (category != DisplayCategory.character) {
        _selectedOccupationFilter = null;
        _uniqueOccupations = []; 
      }
    });

    try {
      dynamic fetchedItems;
      switch (category) {
        case DisplayCategory.character:
          fetchedItems = await _apiService.getAllCharacters();
          break;
        case DisplayCategory.titan:
          fetchedItems = await _apiService.getAllTitans();
          break;
        case DisplayCategory.organization:
          fetchedItems = await _apiService.getAllOrganizations();
          break;
      }
      if (mounted) {
        _allItems = fetchedItems; 
        if (category == DisplayCategory.character) {
          _extractUniqueOccupations();
        }
        setState(() {
          _isLoading = false;
          _filterAndSearchItems(); 
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error fetching data for ${category.name}: ${e.toString()}')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterAndSearchItems() {
    if (!mounted) return;
    final query = _searchController.text.toLowerCase();
    List<dynamic> tempFilteredList = List.from(_allItems);

    if (_selectedCategory == DisplayCategory.character &&
        _selectedOccupationFilter != null) {
      tempFilteredList = tempFilteredList.where((item) {
        if (item is Character) {
          return item.occupation?.toLowerCase() ==
              _selectedOccupationFilter!.toLowerCase();
        }
        return false;
      }).toList();
    }

    if (query.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((item) {
        String name = "";
        if (item is Character)
          name = item.name.toLowerCase();
        else if (item is Titan)
          name = item.name.toLowerCase();
        else if (item is Organization) name = item.name.toLowerCase();
        return name.contains(query);
      }).toList();
    }

    setState(() {
      _displayedItems = tempFilteredList;
    });
  }

  void _onCategorySelected(DisplayCategory category) {
    if (!mounted) return;
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
    });
    _fetchDataForCategory(category);
  }

  void _showOccupationFilterSheet() async {
    // ... (Kode _showOccupationFilterSheet Anda yang sudah benar dari sebelumnya)
    if (!mounted) return;
    if (_selectedCategory != DisplayCategory.character) return;

    if (_uniqueOccupations.isEmpty &&
        _allItems.isNotEmpty &&
        _selectedCategory == DisplayCategory.character) {
      _extractUniqueOccupations();
      if (_uniqueOccupations.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No occupations available to filter by.')),
        );
        return;
      }
    } else if (_uniqueOccupations.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No occupations available to filter by.')),
      );
      return;
    }

    final String? selected = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView.builder(
            itemCount: _uniqueOccupations.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: const Text("All Occupations (Clear Filter)"),
                  leading: _selectedOccupationFilter == null
                      ? Icon(Icons.check_box,
                          color: Theme.of(context).colorScheme.secondary)
                      : const Icon(Icons.check_box_outline_blank),
                  onTap: () => Navigator.pop(context, null),
                );
              }
              final occupation = _uniqueOccupations[index - 1];
              return ListTile(
                title: Text(occupation),
                leading: _selectedOccupationFilter == occupation
                    ? Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.secondary)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () => Navigator.pop(context, occupation),
              );
            },
          ),
        );
      },
    );

    bool filterActuallyChanged = (_selectedOccupationFilter != selected);

    if (filterActuallyChanged && mounted) {
      setState(() {
        _selectedOccupationFilter = selected;
        _filterAndSearchItems();
      });
    }
  }

  // --- Fungsi untuk Fitur Summon Titan ---
  Future<void> _fetchTitansForSummonFeature() async {
    if (!mounted) return;
    if (_titansForSummon.isNotEmpty) {
      debugPrint("Titans for summon mode already loaded.");
      return;
    }
    setState(() => _isLoadingTitansForSummon = true);
    try {
      final titans = await _apiService.getAllTitans();
      if (mounted) {
        setState(() {
          _titansForSummon = titans;
          _isLoadingTitansForSummon = false;
        });
        debugPrint("${_titansForSummon.length} Titans loaded for summon mode.");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTitansForSummon = false);
        debugPrint("Error fetching Titans for summon mode: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal memuat data Titan untuk summon: ${e.toString()}')),
        );
      }
    }
  }

  void _initAccelerometerListener() {
    if (_accelerometerSubscription != null) {
      _accelerometerSubscription!.cancel();
    }
    _accelerometerSubscription =
        accelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)
            .listen(
      (AccelerometerEvent event) {
        if (!mounted) return; 

        double x = event.x;
        double y = event.y;
        double z = event.z;
        double totalAcceleration = sqrt(x * x + y * y + z * z);
        double shakeThreshold = 18.0;

        if (totalAcceleration > shakeThreshold) {
          final now = DateTime.now();
          if (_lastShakeTime == null ||
              now.difference(_lastShakeTime!) > const Duration(seconds: 5)) {
            _lastShakeTime = now;
            if (!_isProcessingShake && _titansForSummon.isNotEmpty) {
              setState(() => _isProcessingShake = true);
              _performTitanSummon();
            } else if (mounted) {
              // Menghindari setState jika tidak perlu
              if (_isProcessingShake) {
                setState(() => _isProcessingShake = false);
              }
            }
          }
        }
      },
      onError: (error) {/* ... */},
      cancelOnError: true,
    );
  }


  void _performTitanSummon() {
    if (_titansForSummon.isEmpty || !mounted) {
      if (mounted) setState(() => _isProcessingShake = false);
      return;
    }

    final summonedTitan =
        _titansForSummon[_random.nextInt(_titansForSummon.length)];
    String summonMessage =
        "\"Getaran besar terdeteksi. ${summonedTitan.name} sedang menyerang kota, LARII!\"";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Icon(Icons.flare_rounded,
                  color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text("TITAN DETECTED!",
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSerif')),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 280,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: theme.colorScheme.surfaceVariant,
                ),
                child:
                    Image.network(summonedTitan.displayImage, fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                }, errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                      "Error loading summoned Titan image ${summonedTitan.displayImage}: $error");
                  return Center(
                      child: Icon(Icons.broken_image_outlined,
                          size: 80, color: Colors.grey[700]));
                }),
              ),
              const SizedBox(height: 20),
              Text(
                summonedTitan.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSerif',
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                summonMessage,
                style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.85)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("THANK, BYE!",
                  style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSerif')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isProcessingShake = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "AOT FANBASE HUB",
                          style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              fontFamily: 'NotoSerif',
                              height: 1.2),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Welcome, ${widget.username}",
                          style: theme.textTheme.titleMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                              height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MerchPage()),
                      );
                    },
                    icon: Icon(Icons.storefront_outlined,
                        size: 20, color: theme.colorScheme.onSecondary),
                    label: Text("AOT MERCH",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondary,
                            letterSpacing: 0.5,
                            fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // CONTAINER & SWITCHLISTTILE DIHAPUS DARI SINI

              Row(
                // Tombol Kategori
                children: DisplayCategory.values.map((category) {
                  bool isSelected = _selectedCategory == category;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: category != DisplayCategory.values.last
                              ? 6.0
                              : 0.0),
                      child: ElevatedButton(
                        onPressed: () => _onCategorySelected(category),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            foregroundColor: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        child: Text(category.name[0].toUpperCase() +
                            category.name.substring(1)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                // Search Bar dan Tombol Filter
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search in ${_selectedCategory.name}s...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                  if (_selectedCategory == DisplayCategory.character)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Tooltip(
                        message: "Filter by Occupation",
                        child: IconButton(
                          icon: Icon(Icons.work_outline,
                              color: _selectedOccupationFilter != null
                                  ? theme.colorScheme.secondary
                                  : Colors.grey[500]),
                          onPressed: _showOccupationFilterSheet,
                          style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                // Grid Data
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _displayedItems.isEmpty
                        ? Center(
                            child: Text(
                                "No results found for ${_selectedCategory.name}s."))
                        : GridView.builder(
                            padding:
                                const EdgeInsets.only(top: 16.0, bottom: 16.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2 / 3,
                            ),
                            itemCount: _displayedItems.length,
                            itemBuilder: (context, index) {
                              return DataGridCard(item: _displayedItems[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
