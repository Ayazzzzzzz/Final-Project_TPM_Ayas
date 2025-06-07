import 'package:hive/hive.dart';

part 'merch_item_model.g.dart';

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
  late String imageUrl; 

  @HiveField(5)
  late String category;

  @HiveField(6) 
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
    if (imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return imageUrl;
    }
    return 'https://picsum.photos/seed/aot_merch_${id}/400/300';
  }
}
