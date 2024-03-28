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
        showNotification(
            notificationMessage['title'], notificationMessage['body'],
            image: notificationMessage['image']);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        setupLocator();
      },
    );
  }
}

showNotification(String title, String message, {String? image}) async {
  bool shouldShowNotification = await isNotificationOn();

  if (shouldShowNotification) {
    if (image != null) {
      // AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: Random().nextInt(2147483647),
      //         title: title,
      //         body: message,
      //         channelKey: "basic_channel",
      //         notificationLayout: NotificationLayout.BigPicture,
      //         bigPicture: image));
    } else {
      // AwesomeNotifications().createNotification(
      //     content: NotificationContent(
      //         id: Random().nextInt(2147483647),
      //         title: title,
      //         body: message,
      //         channelKey: "basic_channel"));
    }
  }
}

Future<bool> isNotificationOn() async {

  try {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(SharedPrefConst.notificationStatus) ?? true;
  } catch (e) {
    return true;
  }
}
