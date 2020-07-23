import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_core/api/api_http.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushNotificationsManager {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void getTokenFireMessenger({String documentIdCustommer}) {
    firebaseMessaging.getToken().then((token) async {
      //print('token: $token');
      var api = HttpApi();
      await api.updateTokenFirebaseMessaging(
          documentIdCustommer: documentIdCustommer, token: token);
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }
// không cần thiết
//  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//    if (message.containsKey('data')) {
//      final dynamic data = message['data'];
//      print(data);
//    }
//    if (message.containsKey('notification')) {
//      final dynamic notification = message['notification'];
//      print(notification);
//    }
//  }

  void configLocalNotification() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void registerNotification() async {
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      showNotification(message['notification']);

      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      showNotification(message['notification']);
      return;
    });
  }

  void showNotification(message) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.sunland',
      'SunLand',
      'Thông báo', //mô tả kênh
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print(message);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
