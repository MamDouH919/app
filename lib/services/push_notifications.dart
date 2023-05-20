import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:starkids_app/data/notification/data_notification.dart';
import 'package:starkids_app/utils/redux/GlobalRedux.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

//Function to handle Notification data in background.
Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  if (GlobalRedux.store.state.user != null) {
    print("FCM backgroundMessageHandler $message");
    showNotification(DataNotification.fromPushMessage(message['notification']),
        DataNotification.fromPushMessage(message['data']));
  }
  return Future<void>.value();
}

//Function to handle Notification Click.
Future<void> onSelectNotification(String payload) {
  print("FCM onSelectNotification");
  return Future<void>.value();
}

//Function to Parse and Show Notification when app is in foreground
Future<dynamic> onMessage(Map<String, dynamic> message) {
  if (GlobalRedux.store.state.user != null) {
    print("FCM onMessage $message");
    showNotification(DataNotification.fromPushMessage(message['notification']),
        DataNotification.fromPushMessage(message['data']));
  }
  return Future<void>.value();
}

//Function to Handle notification click if app is in background
Future<dynamic> onResume(Map<String, dynamic> message) {
  print("FCM onResume $message");
  return Future<void>.value();
}

//Function to Handle notification click if app is not in foreground neither in background
Future<dynamic> onLaunch(Map<String, dynamic> message) {
  print("FCM onLaunch $message");
  return Future<void>.value();
}

void showNotification(
    DataNotification notification, DataNotification data) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      await getAndroidNotificationDetails(notification);

  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  if (GlobalRedux.store.state.user!.id == data.userId) {
    await notificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  } else {
    print("no notification for you!");
  }
}

Future<AndroidNotificationDetails> getAndroidNotificationDetails(
    DataNotification notification) async {
  switch (notification.notificationType) {
    case NotificationType.NEW_INVITATION:
    case NotificationType.NEW_MEMBERSHIP:
    case NotificationType.NEW_ADMIN_ROLE:
    case NotificationType.MEMBERSHIP_BLOCKED:
    case NotificationType.MEMBERSHIP_REMOVED:
    case NotificationType.NEW_MEMBERSHIP_REQUEST:
      return AndroidNotificationDetails(
          'starkids_channel', 'starkids management',
          channelDescription: 'Notifications regarding your memberships.',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          // category: "Organization",
          icon: '@mipmap/splash',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/splash'),
          styleInformation: await getBigPictureStyle(notification));
    // sound: RawResourceAndroidNotificationSound('slow_spring_board');
    case NotificationType.NONE:
    default:
      return AndroidNotificationDetails('starkids_channel',
          'starkids management',channelDescription: 'Notifications regarding your memberships.',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          // category: "General",
          icon: '@mipmap/splash',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/splash'),
          styleInformation: await getBigPictureStyle(notification));
    // sound: RawResourceAndroidNotificationSound('slow_spring_board'));
  }
}

Future<BigPictureStyleInformation?> getBigPictureStyle(
    DataNotification notification) async {
  if (notification.imageUrl != null) {
    print("downloading");
    final String bigPicturePath =
        await _downloadAndSaveFile(notification.imageUrl, 'bigPicture');

    return BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: notification.title,
        htmlFormatContentTitle: false,
        summaryText: notification.body,
        htmlFormatSummaryText: false);
  } else {
    print("NOT downloading");
    return null;
  }
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(url as Uri);
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

// class NotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   void init() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/splash');

//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings();

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await notificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (value) => onSelectNotification(value));
//     _fcm.getToken().then((value) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("jw_token", value!);
//     });

//     _fcm.onTokenRefresh.listen((newToken) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("jw_token", newToken);
//     });
//     // await _fcm.subscribeToTopic('all');
//     _fcm.configure(
//       onMessage: onMessage,
//       onBackgroundMessage: backgroundMessageHandler,
//       onLaunch: onLaunch,
//       onResume: onResume,
//     );
//   }
// }
