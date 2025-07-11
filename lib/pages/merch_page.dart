import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_mobile_ayas/models/merch_item_model.dart';
import '../../main.dart'; 
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';

class MerchPage extends StatefulWidget {
  const MerchPage({super.key});

  @override
  State<MerchPage> createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  String _selectedCurrency = 'JPY';
  final List<String> _currencies = ['JPY', 'USD', 'IDR', 'MYR'];

  String? _selectedCategoryFilter; 
  List<String> _uniqueCategories = []; 

  final Map<String, double> _jpyExchangeRates = {
    'USD': 0.006903,
    'IDR': 112.4,
    'MYR': 0.02919,
  };

  Box<MerchItem>? _merchBox;
  @override
  void initState() {
    super.initState();
    final merchBox = Hive.box<MerchItem>(merchBoxName);
    _initHiveBoxAndCategories();
    _updateFilterCategories(
        merchBox.values.toList()); // Panggil sekali saat init

    merchBox.listenable().addListener(() {
      if (mounted) {
        _updateFilterCategories(merchBox.values.toList());
      }
    });
  }

  Future<void> _initHiveBoxAndCategories() async {
    _merchBox = Hive.box<MerchItem>(merchBoxName);

    if (mounted && _merchBox != null) {
      _updateFilterCategories(_merchBox!.values.toList());
      // Dengarkan perubahan pada box
      _merchBox!.listenable().addListener(_onMerchBoxChanged);
    }
  }

  // Fungsi yang dipanggil ketika box berubah
  void _onMerchBoxChanged() {
    if (mounted && _merchBox != null) {
      _updateFilterCategories(_merchBox!.values.toList());
    }
  }

  void _updateFilterCategories(List<MerchItem> items) {
    if (!mounted) return;

    final Set<String> categoriesSet =
        items.map((item) => item.category).toSet();
    final List<String> newCategories = categoriesSet.toList();
    newCategories.sort();

    if (!const ListEquality().equals(_uniqueCategories, newCategories)) {
      setState(() {
        _uniqueCategories = newCategories;
        if (_selectedCategoryFilter != null &&
            !_uniqueCategories.contains(_selectedCategoryFilter)) {
          _selectedCategoryFilter = null;
        }
        debugPrint("Unique categories updated: $_uniqueCategories");
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka URL: $url')),
        );
      }
    }
  }

  String _getConvertedPrice(double priceJpy, String targetCurrency) {
    if (targetCurrency == 'JPY') {
      return "¥${priceJpy.toStringAsFixed(0)}";
    }
    double rate = _jpyExchangeRates[targetCurrency] ?? 1.0;
    switch (targetCurrency) {
      case 'USD':
        return "\$${(priceJpy * rate).toStringAsFixed(2)}";
      case 'IDR':
        var formattedPrice = (priceJpy * rate).toStringAsFixed(0);
        RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        formattedPrice = formattedPrice.replaceAllMapped(
            reg, (Match match) => '${match[1]}.');
        return "Rp $formattedPrice";
      case 'MYR':
        return "RM ${(priceJpy * rate).toStringAsFixed(2)}";
      default:
        return "¥${priceJpy.toStringAsFixed(0)}";
    }
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'JPY':
        return '¥';
      case 'USD':
        return '\$';
      case 'IDR':
        return 'Rp';
      case 'MYR':
        return 'RM';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("AOT Merch & Collectibles",
            style: TextStyle(
                fontFamily: theme.textTheme.headlineMedium?.fontFamily)),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    items: _currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Row(
                          children: [
                            Text(_getCurrencySymbol(currency),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface)),
                            const SizedBox(width: 8),
                            Text(currency,
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null && mounted) {
                        setState(() {
                          _selectedCurrency = newValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    dropdownColor: theme.colorScheme.surfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                // Dropdown Kategori
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategoryFilter,
                    hint: Text("All Categories",
                        style: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.7))),
                    items: [
                      DropdownMenuItem<String>(
                        value: null, 
                        child: Text("All Categories",
                            style:
                                TextStyle(color: theme.colorScheme.onSurface)),
                      ),
                      // Opsi dari kategori unik
                      ..._uniqueCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category,
                              style: TextStyle(
                                  color: theme.colorScheme.onSurface)),
                        );
                      }).toList()
                    ],
                    onChanged: (String? newValue) {
                      if (mounted) {
                        setState(() {
                          _selectedCategoryFilter = newValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    dropdownColor: theme.colorScheme.surfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<MerchItem>(merchBoxName).listenable(),
              builder: (context, Box<MerchItem> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                      child: Text("Belum ada item merchandise."));
                }

                List<MerchItem> filteredItems = box.values.toList();
                if (_selectedCategoryFilter != null) {
                  filteredItems = filteredItems
                      .where((item) => item.category == _selectedCategoryFilter)
                      .toList();
                }

                filteredItems.sort((a, b) =>
                    a.name.compareTo(b.name)); 

                if (filteredItems.isEmpty) {
                  return const Center(
                      child: Text("Tidak ada item untuk filter yang dipilih."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        // Tidak lagi pakai InkWell karena detail page dihapus
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                            ),
                            child: Image.network(
                              item.displayImageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ));
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                      child: Icon(Icons.inventory_2_outlined,
                                          size: 60, color: Colors.grey[700])),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NotoSerif')),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Chip(
                                        label: Text(item.category),
                                        backgroundColor:
                                            theme.colorScheme.primaryContainer,
                                        labelStyle: TextStyle(
                                            color: theme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getConvertedPrice(
                                          item.priceJpy, _selectedCurrency),
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        color: theme.colorScheme
                                            .tertiary, 
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            'NotoSerif', 
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                Text(item.description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.85)),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _launchURL(item.storeUrl),
                                    label: const Text("GO TO STORE"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme
                                          .colorScheme.secondary
                                          .withOpacity(0.9),
                                      foregroundColor:
                                          theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
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
