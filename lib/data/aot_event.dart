import 'package:ta_mobile_ayas/models/event_item_model.dart';

List<EventItem> getDummyAotEvents() {
  return [
    EventItem(
      id: 'aot_game_release_2025',
      title: 'Rilis Game "AOT: Final Stand',
      description:
          'Game mobile terbaru Attack on Titan akan dirilis global! Bersiaplah untuk pertempuran terakhir.',
      eventTimeUtc: DateTime.utc(2025, 7, 15, 1, 0, 0),
      originalTimeZoneLabel: '10:00 JST',
      imageUrl:
          'https://cdn.akamai.steamstatic.com/steam/apps/1027200/capsule_616x353.jpg?t=1683292274', 
      latitude: 35.7056, // Koordinat Tokyo Dome, Jepang
      longitude: 139.7519,
    ),
    EventItem(
      id: 'aot_last_attack_jakarta_2025',
      title: 'Pemutaran Spesial "Attack on Titan: The Last Attack',
      description: 'Pemutaran film spesial "Attack on Titan: The Last Attack" di bioskop CGV Indonesia.',
      eventTimeUtc: DateTime.utc(2025, 2, 14, 12, 0), 
      originalTimeZoneLabel: '19:00 WIB (Jakarta)',
      imageUrl: 'https://assets.pikiran-rakyat.com/crop/0x0:0x0/1200x675/photo/2025/02/13/2611144640.jpg',
      latitude: -6.1783,
      longitude: 106.7905,
    ),
    EventItem(
      id: 'aot_10th_popup_jgc_2025',
      title: 'Attack on Titan 10th Anniversary Pop-Up Store',
      description: 'Toko pop-up resmi untuk merayakan 10 tahun AOT, menampilkan merchandise eksklusif.',
      eventTimeUtc: DateTime.utc(2025, 1, 24, 3, 0), 
      originalTimeZoneLabel: '10:00 WIB (Jakarta)',
      imageUrl: 'https://cdn.clipkit.co/tenants/1499/articles/images/000/000/170/large/db98c33a-8840-4e76-94c8-939206c8c97b.jpg?1702374464',
      latitude: -6.1908,
      longitude: 106.9490,
    ),
    EventItem(
      id: 'aot_exhibition_tangerang_2025',
      title: 'Attack on Titan Exhibition di Aeon Mall Tangerang',
      description: 'Pameran AOT dengan diorama dan instalasi visual.',
      eventTimeUtc: DateTime.utc(2025, 5, 10, 4, 0), 
      originalTimeZoneLabel: '11:00 WIB (Tangerang)',
      imageUrl: 'https://asset-2.tstatic.net/tangerang/foto/bank/images/Anime1176.jpg',
      latitude: -6.2249,
      longitude: 106.6525,
    ),
    EventItem(
      id: 'aot_comiccon_jakarta_2025',
      title: 'Indonesia Comic Con x INACON 2025',
      description: 'Konvensi budaya pop dengan kemungkinan kehadiran booth atau konten AOT.',
      eventTimeUtc: DateTime.utc(2025, 10, 25, 3, 0), 
      originalTimeZoneLabel: '10:00 WIB (Jakarta)',
      imageUrl: 'https://tse3.mm.bing.net/th?id=OIP.KYa2j4ZUBT-8WpQbUYJIkQHaEL&pid=Api&P=0&h=180',
      latitude: -6.2186,
      longitude: 106.8010,
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
      latitude: 51.5085, 
      longitude: 0.0302,
    ),
    EventItem(
      id: 'online_rewatch_finale_2025',
      title: 'Global Rewatch Party: AOT Finale Episodes',
      description:
          'Bergabunglah dengan fans di seluruh dunia untuk menonton ulang episode-episode terakhir AOT secara bersamaan.',
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
      eventTimeUtc: DateTime.utc(2025, 12, 25, 0, 0, 0),
      originalTimeZoneLabel: 'All Day Event',
      imageUrl:
          'https://static.wikia.nocookie.net/shingekinokyojin/images/b/b1/Levi_Ackermann_%28Anime%29_character_image.png/revision/latest?cb=20230309145235',
      latitude: null,
      longitude: null, 
    ),
    EventItem(
      id: 'aot_concert_osaka_2025',
      title: 'Attack on Titan Final Season Orchestra Concert – Osaka',
      description:
          'Konser musik orkestra resmi dari Final Season, menampilkan soundtrack epik dari anime.',
      eventTimeUtc: DateTime.utc(2025, 10, 12, 9, 0), 
      originalTimeZoneLabel: '18:00 JST (Osaka)',
      imageUrl:
          'https://tse3.mm.bing.net/th?id=OIP.0aPJl0N96n9NYUq6YbAuGQHaFL&pid=Api&P=0&h=180',
      latitude: 34.6873,
      longitude: 135.5262,
    ),
    EventItem(
      id: 'aot_fan_meet_la_2025',
      title: 'AOT 2025 Global Fan Meet – Los Angeles',
      description:
          'Fan meeting dan pemutaran spesial episode terakhir, dengan tamu pengisi suara versi Jepang dan Inggris.',
      eventTimeUtc: DateTime.utc(2025, 11, 4, 3, 0), 
      originalTimeZoneLabel: '19:00 PST (Los Angeles)',
      imageUrl:
          'https://static1.cbrimages.com/wordpress/wp-content/uploads/2025/01/attackontitan_thelastattack_visual.jpg',
      latitude: 34.0980,
      longitude: -118.3267,
    ),
    EventItem(
      id: 'aot_art_exhibition_berlin_2025',
      title: 'Attack on Titan: The Art Legacy – Berlin Exhibition',
      description:
          'Pameran seni visual dan original concept art dari seluruh musim.',
      eventTimeUtc: DateTime.utc(2025, 8, 28, 9, 0), 
      originalTimeZoneLabel: '11:00 CEST (Berlin)',
      imageUrl:
          'https://tse1.mm.bing.net/th?id=OIP.IHPt9eSPsB3_W31n03HNaQHaEK&pid=Api&P=0&h=180',
      latitude: 52.5053,
      longitude: 13.4549,
    ),
  ];
}
