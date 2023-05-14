import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/services/local_database.dart';
import 'package:whatsapp_clone/services/locator.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSound().logger.close();

  setUpLocator();
  await getIt<LocalDatabase>().init('cache');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  permissions();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
