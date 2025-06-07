import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; 

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
      importance: Importance.max, 
      priority: Priority.high,
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
