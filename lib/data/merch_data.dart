// lib/data/dummy/dummy_merch_data.dart
import 'package:ta_mobile_ayas/models/merch_item_model.dart';

List<MerchItem> getInitialMerchData() {
  // Catatan: URL Gambar ini adalah contoh dan telah dicari ulang.
  // Stabilitas URL dari sumber eksternal tidak dijamin dalam jangka panjang.
  return [
    MerchItem(
      id: 'nendo_eren_final_szn',
      name: 'Nendoroid Eren Yeager: The Final Season Ver.',
      description:
          'Figur Nendoroid Eren Yeager dari "Attack on Titan" The Final Season. Dilengkapi dengan tiga plat wajah dan aksesoris.',
      priceJpy: 6100,
      // Sumber: Good Smile Company (biasanya stabil)
      imageUrl:
          'https://cloudstoycollection.com/cdn/shop/products/Eren_d0658625-3677-496f-b706-7a3af265c7f7.jpg?v=1658288967',
      category: 'Figure',
      storeUrl:
          'https://www.goodsmile.com/en/product/10640/Nendoroid+Eren+Yeager+The+Final+Season+Ver.',
    ),
    MerchItem(
      id: 'scout_jacket_premium',
      name: 'Attack on Titan Scout Regiment Jacket',
      description:
          'Jaket cosplay kualitas tinggi dari Scout Regiment dengan bordir emblem Wings of Freedom yang detail.',
      priceJpy: 12693,
      // Sumber: Contoh dari eBay/Amazon (bisa kurang stabil, carilah yang lebih direct jika memungkinkan)
      imageUrl:
          'https://jacketera.com/wp-content/uploads/2023/08/Attack-On-Titan-Jacket-3-1200x675.webp',
      category: 'Apparel',
      storeUrl: 'https://www.jacketmakers.com/product/attack-on-titan-jacket/',
    ),
    MerchItem(
      id: 'figma_levi_ackerman_fs',
      name: 'figma Levi Ackerman: The Final Season ver.',
      description:
          'Dari seri anime "Attack on Titan", figma Levi dengan penampilan barunya di The Final Season! Termasuk 3D Maneuver Gear.',
      priceJpy: 7800,
      // Sumber: Good Smile Company
      imageUrl:
          'https://farm4.staticflickr.com/3839/14809752762_0c213d7ec4_h.jpg',
      category: 'Figure',
      storeUrl: 'https://www.goodsmile.com/en/product/1978/figma+Levi',
    ),
    MerchItem(
      id: 'aot_manga_box_set_final_part2', // Ganti ID agar lebih spesifik
      name: 'Attack on Titan Manga Box Set - Final Season Part 2 (Vol 30-34)',
      description:
          'Collector\'s box set berisi Volume 30-34 dari seri manga Attack on Titan, mencakup bagian akhir cerita.',
      priceJpy: 6340, // Estimasi
      // Sumber: Contoh dari Amazon (bisa berubah)
      imageUrl:
          'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/130/2023/10/24/IMG_0556-1809998447.jpeg',
      category: 'Manga',
      storeUrl:
          'https://www.amazon.com/Attack-Titan-Final-Season-Manga/dp/164651453X',
    ),
    MerchItem(
      id: 'kotobukiya_mikasa_statue_renewal', // Ganti ID agar lebih spesifik
      name: 'Mikasa Ackerman ARTFX J Renewal Pkg Ver. (Statue)',
      description:
          'Patung seri ARTFX J dari Kotobukiya untuk Mikasa Ackerman dalam pose dinamis dengan 3D Maneuver Gear. Edisi Renewal.',
      priceJpy: 30720,
      // Sumber: Kotobukiya (biasanya stabil)
      imageUrl:
          'https://www.gokin.it/wp-content/uploads/2018/07/FIGURE-041186_000.jpg',
      category: 'Figure',
      storeUrl:
          'https://kyou.id/items/74311/artfx-j-figure-18-mikasa-ackerman-renewal-package-ver-rerelease',
    ),
    MerchItem(
      id: 'aot_character_pin_set',
      name: 'Attack on Titan Character Enamel Pin Set',
      description:
          'Set pin enamel berkualitas tinggi menampilkan karakter-karakter utama Attack on Titan. Sempurna untuk tas atau jaket.',
      priceJpy: 290,
      // Sumber: Contoh dari Etsy/merch store (bisa berubah)
      imageUrl:
          'https://i.kickstarter.com/assets/033/145/626/d4eb9dea4b74ca524e834640eeb485af_original.png?anim=false&fit=cover&gravity=auto&height=873&origin=ugc&q=92&v=1618547753&width=1552&sig=VtirGN6R5iwVwx2l2n%2B13ewjwIWxc%2FgT%2FnFxn9Rqt6M%3D',
      category: 'Accessory',
      storeUrl: 'https://www.etsy.com/market/attack_on_titan_pins_enamel',
    ),
    MerchItem(
      id: 'survey_corps_green_cloak_cosplay', // Ganti ID
      name: 'Survey Corps Official Green Cloak (Cosplay)',
      description:
          'Jubah hijau panjang seperti yang dikenakan Survey Corps, lengkap dengan emblem Wings of Freedom di punggung. Bahan berkualitas.',
      priceJpy: 477,
      // Sumber: Contoh dari Amazon/cosplay store
      imageUrl:
          'https://img.joomcdn.net/67d69f9b376b88455775a6d0cc5161cfb045d7a6_original.jpeg',
      category: 'Apparel',
      storeUrl:
          'https://www.micotaku.com/official-licensed-attack-on-titan-survey-corps-cloak-250957p.html',
    ),
    MerchItem(
      id: 'eren_titan_form_banpresto',
      name: 'Eren Yeager Attack Titan Form Figure (Banpresto)',
      description:
          'Figur Eren dalam bentuk Attack Titan dari Banpresto. Detail yang mengesankan untuk kolektor.',
      priceJpy: 5174,
      // Sumber: Contoh dari situs kolektor/eBay (bisa berubah)
      imageUrl:
          'https://www.ctboxmanila.com/cdn/shop/files/FIGURE-172001_10.jpg?v=1747305621&width=1946',
      category: 'Figure',
      storeUrl:
          'https://www.walmart.com/ip/Eren-Yeager-Attack-on-Titan-The-Final-Season-Prize-Figure/2826475609',
    )
  ];
}
