import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:last/dao/dao.dart';
import 'package:last/services/notification_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class PushService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late IOWebSocketChannel channel;

  void connect() {
    NotificationService.initialize(flutterLocalNotificationsPlugin);

    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://192.168.0.8:8000/ws/notify/'),
    );
    print("NSDKJFNKDJNFDJKFNJFNSDFNKNFJKFNKDNFNFJKSDFNFJKFNFJKDSKJ");
    channel.stream.listen((message) {
      final data = json.decode(message);
      final currentUserID = UserPreferences.userId;
      print('ASSSSSSSSSSSSSSSSSSSSSSSAAAAAAAA $data');
      var authorID = data['author_id'][0];
      print('AAASASASAAAA $authorID');
      print('TETETETETETETE $currentUserID');

      if (authorID == currentUserID) {
        NotificationService.showBigTextNotification(
            title: "Новый лайк!",
            body: json.encode(data['message']),
            fln: flutterLocalNotificationsPlugin);
        channel.sink.add('received!');
      } else {
        print('вы не автор');
      }
    }, onDone: () {});
  }
}
