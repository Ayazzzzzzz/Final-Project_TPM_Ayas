// lib/domain/models/event_item_model.dart

class EventItem {
  final String id;
  final String title;
  final String description;
  final DateTime eventTimeUtc; // WAKTU HARUS DISIMPAN DALAM UTC
  final String
      originalTimeZoneLabel; // Contoh: "JST", "PST" untuk ditampilkan ke user
  final String? imageUrl; // Opsional
  final double? latitude;  // <-- TAMBAHKAN INI (nullable double)
  final double? longitude; // <-- TAMBAHKAN INI (nullable double)

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.eventTimeUtc,
    required this.originalTimeZoneLabel,
    this.imageUrl,
    this.latitude,  // <-- TAMBAHKAN DI CONSTRUCTOR (opsional)
    this.longitude, // <-- TAMBAHKAN DI CONSTRUCTOR (opsional)
  });
}
