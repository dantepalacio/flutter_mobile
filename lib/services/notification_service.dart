import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('ic_android_black_24dp');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings =
        new InitializationSettings(androidInitialize, iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      "0",
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: false,
      importance: Importance.Max,
      priority: Priority.High,
    );

    var not = NotificationDetails(
        androidPlatformChannelSpecifics, IOSNotificationDetails());
    await fln.show(id, title, body, not);
  }
}
