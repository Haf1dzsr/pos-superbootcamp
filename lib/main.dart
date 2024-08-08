import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/data/utils/local_notification_helper.dart';
import 'package:pos_superbootcamp/firebase_options.dart';
import 'package:pos_superbootcamp/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.instance.initLocalNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
