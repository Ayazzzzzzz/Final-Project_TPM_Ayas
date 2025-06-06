// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_mobile_ayas/data/merch_data.dart';
import 'package:ta_mobile_ayas/models/merch_item_model.dart';
import 'package:ta_mobile_ayas/models/user_model.dart';
import 'package:ta_mobile_ayas/pages/splash_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

const String userBoxName = 'userBox';
const String merchBoxName = 'merchBox';

// --- BUAT INSTANCE GLOBAL UNTUK PLUGIN NOTIFIKASI ---
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// ----------------------------------------------------

// Fungsi untuk mengisi data merch awal jika box kosong
Future<void> _prefillMerchData() async {
  final merchBox = Hive.box<MerchItem>(merchBoxName);
  if (merchBox.isEmpty) {
    debugPrint("Merch box is empty, pre-filling data...");
    final initialData = getInitialMerchData();
    for (var item in initialData) {
      await merchBox.put(item.id,
          item); // Menggunakan ID item sebagai key untuk kemudahan akses/update
    }
    debugPrint("${merchBox.length} merch items added to the box.");
  } else {
    debugPrint("Merch box already contains data: ${merchBox.length} items.");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- INISIALISASI TIMEZONE (untuk notifikasi terjadwal) ---
  tz.initializeTimeZones();
  // Anda mungkin perlu mengatur lokasi default, meskipun untuk notifikasi instan ini kurang kritikal
  // tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Contoh
  // --------------------------------------------------------

// --- INISIALISASI DATA LOCALE UNTUK INTL ---
  // Kita menggunakan 'id_ID' untuk Bahasa Indonesia
  // Argumen kedua (filePath) bisa null agar menggunakan mekanisme default intl
  await initializeDateFormatting('id_ID', null);
  // ---------------------------------------------

  tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Opsional
  // --- INISIALISASI FLUTTER LOCAL NOTIFICATIONS ---
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Pastikan ikon ini ada

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Callback jika dibutuhkan
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, // Callback saat notifikasi diklik
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(userBoxName);

  Hive.registerAdapter(MerchItemAdapter());
  await Hive.openBox<MerchItem>(merchBoxName); // <-- BUKA BOX MERCH

  await _prefillMerchData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DEFINISI WARNA KHAS AOT "RELICS OF THE WALLS"
    const Color scoutRegimentGreen =
        Color.fromARGB(255, 77, 96, 63); // Hijau zaitun tua/lumut
    const Color leatherBrown =
        Color.fromARGB(255, 141, 89, 71); // Coklat kulit yang lebih standar
    const Color parchmentWhite = Color(0xFFF5EFE6); // Putih krem/kertas tua
    const Color darkStoneGrey =
        Color(0xFF3E3E3E); // Abu-abu batu gelap untuk surface
    const Color darkerStoneBg =
        Color(0xFF2A2A2A); // Lebih gelap untuk background utama
    const Color deepMaroon =
        Color.fromARGB(255, 188, 69, 69); // Merah anggur tua untuk aksen/error

    return MaterialApp(
      title: 'AOT Fanbase Hub', // Judul bisa disesuaikan
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'NotoSerif', // Font serif untuk kesan klasik dan formal

          colorScheme: ColorScheme(
            brightness: Brightness.dark,

            primary: scoutRegimentGreen,
            onPrimary: parchmentWhite,

            secondary: leatherBrown,
            onSecondary: parchmentWhite,

            tertiary:
                const Color.fromARGB(255, 198, 99, 99), // Aksen merah anggur
            onTertiary: parchmentWhite,

            error: deepMaroon, // Menggunakan deepMaroon untuk error
            onError: parchmentWhite,

            background: darkerStoneBg,
            onBackground: parchmentWhite,

            surface: darkStoneGrey,
            onSurface: parchmentWhite,

            outline: Colors.grey[600], // Garis tepi yang lebih lembut
            surfaceVariant: const Color(
                0xFF4A443F), // Varian surface, sedikit lebih coklat dari darkStoneGrey
            onSurfaceVariant: parchmentWhite,
          ),
          scaffoldBackgroundColor: darkerStoneBg,
          appBarTheme: AppBarTheme(
            backgroundColor: darkStoneGrey,
            elevation: 1.0,
            iconTheme: IconThemeData(color: parchmentWhite.withOpacity(0.85)),
            titleTextStyle: TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: parchmentWhite,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Sedikit lebih tegas
            ),
            color: darkStoneGrey,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: scoutRegimentGreen,
                foregroundColor: parchmentWhite,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 14), // Padding disesuaikan
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      6), // Border radius lebih kecil untuk kesan tegas
                ),
                textStyle: const TextStyle(
                  fontSize:
                      15, // Sedikit lebih kecil agar tidak terlalu dominan
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSerif',
                  letterSpacing: 0.5,
                )),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: leatherBrown,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'NotoSerif'))),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: darkStoneGrey.withOpacity(0.7),
            hintStyle: TextStyle(color: parchmentWhite.withOpacity(0.5)),
            labelStyle: TextStyle(
                color: parchmentWhite.withOpacity(0.7),
                fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              // Border saat tidak aktif
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scoutRegimentGreen, width: 2),
            ),
            prefixIconColor: leatherBrown,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFF4E4A43),
            labelStyle: TextStyle(
                color: parchmentWhite,
                fontWeight: FontWeight.w500,
                fontSize: 13),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: BorderSide.none,
            secondarySelectedColor:
                scoutRegimentGreen, // Warna chip saat dipilih (jika ada)
            selectedColor: scoutRegimentGreen,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: darkStoneGrey,
            selectedItemColor: scoutRegimentGreen,
            unselectedItemColor: parchmentWhite.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'NotoSerif'),
            unselectedLabelStyle: TextStyle(
                fontFamily: 'NotoSerif',
                color: parchmentWhite.withOpacity(0.6)),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                color: parchmentWhite,
                fontSize: 16,
                height: 1.5,
                fontFamily: 'Inter'),
            bodyMedium: TextStyle(
                color: parchmentWhite.withOpacity(0.85),
                fontSize: 14,
                height: 1.4,
                fontFamily: 'Inter'),
            titleLarge: TextStyle(
                color: parchmentWhite,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSerif'),
            titleMedium: TextStyle(
                color: parchmentWhite.withOpacity(0.9),
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(
                color: parchmentWhite,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSerif'),
            headlineMedium: TextStyle(
                color: parchmentWhite,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSerif'),
            labelLarge: TextStyle(
                color: parchmentWhite,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSerif',
                letterSpacing: 0.5), // Untuk tombol
          ),
          iconTheme: IconThemeData(
            color: parchmentWhite.withOpacity(0.8),
          ),
          tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: TextStyle(color: parchmentWhite, fontSize: 12),
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey[700],
            thickness: 0.5,
          )),
      home: const SplashPage(),
    );
  }
}
