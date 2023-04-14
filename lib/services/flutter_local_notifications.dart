// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   LocalNotificationService() {
//     setChannel();
//   }
//   AndroidNotificationChannel? channel;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void setChannel() {
//     // ignore: prefer_const_constructors
//     channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // titletion
//       'High Importance Notifications', // titletion
//       importance: Importance.high,
//     );
//   }

//   void show(RemoteMessage message) {
//     flutterLocalNotificationsPlugin.show(
//         message.notification.hashCode,
//         message.notification?.title,
//         message.notification?.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel!.id,
//             channel!.name,
//             channel!.description,
//           ),
//         ));
//   }
// }
