import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/user.dart';

final firebaseMessagingServiceProvider = Provider((ref) {
  return FirebaseMessagingService(ref);
});

class FirebaseMessagingService {
  final ProviderRef ref;

  FirebaseMessagingService(this.ref);
  Future<void> initialize(BuildContext context) async {
    await _requestPermission();
    _onForegroundMessage();
    _getFirebaseToken(ref);

    _onBackgroundMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // var senderId = message.data['sender_id'];
      // ref.read(authControllerProvider).userDataById(senderId).then((user) {
      //   Navigator.pushNamed(context, '/chat-screen', arguments: user);
      // });
      Navigator.pushNamed(context, '/home');
    });
  }

  void _onMessageOpened(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var senderId = message.data['sender_id'];
      ref.read(authControllerProvider).userDataById(senderId).then((user) {
        Navigator.pushNamed(context, '/chat-screen', arguments: user);
      });
    });
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void _onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _getFirebaseToken(ProviderRef ref) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final authController = ref.watch(authControllerProvider);
    authController.saveFCMToken(fcmToken!);
    if (kDebugMode) {
      print('FCM TOKEN $fcmToken');
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      authController.saveFCMToken(token);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    print("Handling a background message: ${message.messageId}");
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.setAutoInitEnabled(true);
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
