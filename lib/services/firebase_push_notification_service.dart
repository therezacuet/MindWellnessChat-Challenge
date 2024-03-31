import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/locator.dart';
import '../const/shared_pref_const.dart';
import '../main.dart';

class FirebasePushNotificationService {
  Future<String> getFcmToken() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    String? fcmToken = await fcm.getToken();
    return fcmToken.toString();
  }

  initMessaging() {
    FirebaseMessaging.instance.getInitialMessage().then((value) => {});

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Map<String, dynamic>? notificationMessage = message.data;
        showNotification(notificationMessage['id'], notificationMessage['title'], notificationMessage['body'], image: notificationMessage['image']);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        setupLocator();
      },
    );
  }
}

showNotification(String senderId, String title, String message, {String? image}) async {
  bool shouldShowNotification = await isNotificationOn();
  bool isCurrent = await isCurrentParticipant(senderId);
  if (shouldShowNotification && !isCurrent) {
    if (image != null && image.isNotEmpty) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              title: title,
              body: message,
              channelKey: "basic_channel",
              notificationLayout: NotificationLayout.BigPicture,
              bigPicture: image
          )
      );
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(2147483647),
              title: title,
              body: message,
              channelKey: "basic_channel"
          )
      );
    }
  }
}

Future<bool> isNotificationOn() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefConst.notificationStatus) ?? true;
  } catch (e) {
    return true;
  }
}

Future<bool> isCurrentParticipant(String senderId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentParticipant = prefs.getString(SharedPrefConst.currentParticipant);
    return currentParticipant == senderId ? true : false;
  } catch (e) {
    return true;
  }
}