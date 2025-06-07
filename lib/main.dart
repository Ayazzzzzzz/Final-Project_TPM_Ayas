import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_mobile_ayas/data/merch_data.dart';
import 'package:ta_mobile_ayas/models/merch_item_model.dart';
import 'package:ta_mobile_ayas/models/user_model.dart';
import 'package:ta_mobile_ayas/pages/splash_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

const String userBoxName = 'userBox';
const String merchBoxName = 'merchBox';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _prefillMerchData() async {
  final merchBox = Hive.box<MerchItem>(merchBoxName);
  if (merchBox.isEmpty) {
    debugPrint("Merch box is empty, pre-filling data...");
    final initialData = getInitialMerchData();
    for (var item in initialData) {
      await merchBox.put(item.id,
          item); 
    }
    debugPrint("${merchBox.length} merch items added to the box.");
  } else {
    debugPrint("Merch box already contains data: ${merchBox.length} items.");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
 
  await initializeDateFormatting('id_ID', null);

  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); 

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>(userBoxName);

  Hive.registerAdapter(MerchItemAdapter());
  await Hive.openBox<MerchItem>(merchBoxName);

  await _prefillMerchData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color scoutRegimentGreen =
        Color.fromARGB(255, 77, 96, 63); 
    const Color leatherBrown =
        Color.fromARGB(255, 141, 89, 71); 
    const Color parchmentWhite = Color(0xFFF5EFE6);
    const Color darkStoneGrey =
        Color(0xFF3E3E3E); 
    const Color darkerStoneBg =
        Color(0xFF2A2A2A); 
    const Color deepMaroon =
        Color.fromARGB(255, 188, 69, 69); 
        
    return MaterialApp(
      title: 'AOT Fanbase Hub', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'NotoSerif', 

          colorScheme: ColorScheme(
            brightness: Brightness.dark,

            primary: scoutRegimentGreen,
            onPrimary: parchmentWhite,

            secondary: leatherBrown,
            onSecondary: parchmentWhite,

            tertiary:
                const Color.fromARGB(255, 198, 99, 99), 
            onTertiary: parchmentWhite,

            error: deepMaroon, 
            onError: parchmentWhite,

            background: darkerStoneBg,
            onBackground: parchmentWhite,

            surface: darkStoneGrey,
            onSurface: parchmentWhite,

            outline: Colors.grey[600],
            surfaceVariant: const Color(
                0xFF4A443F),
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
              borderRadius: BorderRadius.circular(8.0), 
            ),
            color: darkStoneGrey,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: scoutRegimentGreen,
                foregroundColor: parchmentWhite,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      6),
                ),
                textStyle: const TextStyle(
                  fontSize:
                      15, 
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
                scoutRegimentGreen, 
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
