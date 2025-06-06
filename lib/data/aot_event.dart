// lib/data/dummy/dummy_aot_events.dart
import 'package:ta_mobile_ayas/models/event_item_model.dart';

List<EventItem> getDummyAotEvents() {
  // Ingat: eventTimeUtc harus dalam UTC.
  // Contoh: Jika acara di Jepang (JST = UTC+9) pukul 20:00, maka waktu UTC-nya adalah 11:00.
  // Gunakan DateTime.utc(tahun, bulan, hari, jam, menit)
  return [
    EventItem(
      id: 'aot_game_release_2025',
      title: 'Rilis Game "AOT: Final Stand"',
      description:
          'Game mobile terbaru Attack on Titan akan dirilis global! Bersiaplah untuk pertempuran terakhir.',
      // Contoh: 15 Juli 2025, pukul 10:00 JST (UTC+9) -> berarti 01:00 UTC
      eventTimeUtc: DateTime.utc(2025, 7, 15, 1, 0, 0),
      originalTimeZoneLabel: '10:00 JST',
      imageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1027200/capsule_616x353.jpg?t=1683292274', // Contoh gambar AoT Game
      latitude: 35.7056, // Koordinat Tokyo Dome, Jepang
      longitude: 139.7519,
    ),
    EventItem(
      id: 'aot_exhibition_london_2025',
      title: 'AOT Exhibition di London',
      description:
          'Pameran seni dan merchandise Attack on Titan hadir di London. Jangan lewatkan item eksklusif!',
      // Contoh: 5 Agustus 2025, pukul 14:00 BST (UTC+1 saat musim panas) -> berarti 13:00 UTC
      eventTimeUtc: DateTime.utc(2025, 8, 5, 13, 0, 0),
      originalTimeZoneLabel: '14:00 BST (London)',
      imageUrl: 'https://i.ytimg.com/vi/dYtr0e91pOA/maxresdefault.jpg',
      latitude: 51.5085, // Koordinat ExCeL London, UK
      longitude: 0.0302,
    ),
    EventItem(
      id: 'online_rewatch_finale_2025',
      title: 'Global Rewatch Party: AOT Finale Episodes',
      description:
          'Bergabunglah dengan fans di seluruh dunia untuk menonton ulang episode-episode terakhir AOT secara bersamaan.',
      // Contoh: 20 September 2025, pukul 19:00 PST (UTC-7 saat Daylight Saving) -> berarti 02:00 UTC tanggal 21
      eventTimeUtc: DateTime.utc(2025, 9, 21, 2, 0, 0),
      originalTimeZoneLabel: '19:00 PST (USA West Coast)',
      imageUrl:
          'https://static1.srcdn.com/wordpress/wp-content/uploads/2024/11/aot-last-attack-2-1.png',
      latitude: null,
      longitude: null,
    ),
    EventItem(
      id: 'levi_birthday_2025',
      title: 'Perayaan Ulang Tahun Levi Ackerman',
      description:
          'Mari rayakan ulang tahun Kapten Levi! Bagikan fanart dan momen favoritmu.',
      // Contoh: 25 Desember 2025 (sepanjang hari, kita ambil tengah malam UTC sebagai patokan)
      eventTimeUtc: DateTime.utc(2025, 12, 25, 0, 0, 0),
      originalTimeZoneLabel: 'All Day Event',
      imageUrl:
          'https://static.wikia.nocookie.net/shingekinokyojin/images/b/b1/Levi_Ackermann_%28Anime%29_character_image.png/revision/latest?cb=20230309145235',
      latitude: null,
      longitude: null, // URL yang mungkin mati, ganti jika perlu
    ),
  ];
}
