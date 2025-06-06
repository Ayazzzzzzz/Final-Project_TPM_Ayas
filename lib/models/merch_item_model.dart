// lib/domain/models/merch_item_model.dart
import 'package:hive/hive.dart';

part 'merch_item_model.g.dart'; // File ini akan di-generate

@HiveType(typeId: 1)
class MerchItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late double priceJpy;

  @HiveField(4)
  late String imageUrl; // URL utama dari data dummy

  @HiveField(5)
  late String category;

  @HiveField(6) // <-- FIELD BARU
  late String storeUrl;

  MerchItem({
    required this.id,
    required this.name,
    required this.description,
    required this.priceJpy,
    required this.imageUrl,
    required this.category,
    required this.storeUrl,
  });

  // Getter untuk gambar yang akan ditampilkan, dengan fallback
  String get displayImageUrl {
    // Cek jika imageUrl valid (tidak kosong dan dimulai dengan http)
    if (imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return imageUrl;
    }
    // Jika tidak valid, kembalikan URL placeholder yang stabil
    // Menggunakan ID item untuk seed agar placeholder konsisten per item
    return 'https://picsum.photos/seed/aot_merch_${id}/400/300';
  }
}
