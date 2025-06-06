// lib/utils/notification_helper.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // Untuk mengakses flutterLocalNotificationsPlugin

class NotificationHelper {
  static Future<void> showCharacterQuoteNotification(
      String characterName, String quote) async {
    const String notificationIconName = 'ic_notification_aot';

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'character_quotes_channel_id',
      'Character Quotes',
      channelDescription:
          'Notifications with iconic quotes from AOT characters.',
      // --- TINGKATKAN PARAMETER INI ---
      importance: Importance.max, // Tingkatkan ke max
      priority: Priority.high, // Tingkatkan ke high
      // --------------------------------
      showWhen: true,
      icon: notificationIconName,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        quote,
        htmlFormatBigText: true,
        contentTitle: characterName,
        htmlFormatContentTitle: true,
        summaryText: 'Quote of the Moment',
        htmlFormatSummaryText: true,
      ),
      // Anda bisa coba tambahkan lockscreenVisibility jika tersedia di versi plugin Anda
      // (Ini mungkin tidak ada, tergantung versi plugin)
      // lockscreenVisibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      characterName.hashCode,
      characterName,
      quote,
      platformChannelSpecifics,
    );
  }
}
