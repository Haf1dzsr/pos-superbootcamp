import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  NotificationHelper._internal();
  static final NotificationHelper instance = NotificationHelper._internal();
  factory NotificationHelper() {
    return instance;
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ValueNotifier<String> payload = ValueNotifier<String>('');

  void setPayload(String newPayload) {
    payload.value = newPayload;
  }

  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'Local Notifications',
    'Test Local Notifications',
    channelDescription: 'Local Notifications Test',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  static DarwinNotificationDetails iOSNotificationDetails =
      const DarwinNotificationDetails(
    threadIdentifier: 'Local Notifications',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iOSNotificationDetails,
  );

  Future<void> initLocalNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log("Notifikasi ditekan ${details.payload}");
        setPayload(details.payload ?? '');
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
