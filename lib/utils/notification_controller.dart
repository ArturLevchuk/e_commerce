import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/screens/main_app/cart/cart_screen.dart';
import 'package:e_commerce/utils/offline_auth_check.dart';
import '../constants.dart';
import '../screens/app/app.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log("${receivedNotification.channelKey} - ${receivedNotification.createdDate}");
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log("${DateTime.now().toLocal().toString()} ${receivedNotification.channelKey}");
    if (receivedNotification.channelKey == cartNotificationKey) {
      final authStatus = await notifictionAuthCheck();
      if (authStatus) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: receivedNotification.id!,
            channelKey: receivedNotification.channelKey!,
            title: receivedNotification.title,
            body: receivedNotification.body,
            category: NotificationCategory.Recommendation,
          ),
          schedule: NotificationInterval(interval: 60 * 5, repeats: false),
        );
      } else {
        AwesomeNotifications()
            .cancelNotificationsByChannelKey(cartNotificationKey);
      }
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    AwesomeNotifications().cancelNotificationsByChannelKey(cartNotificationKey);
    if (receivedAction.channelKey == cartNotificationKey) {
      App.navigatorKey.currentState?.pushReplacementNamed(CartScreen.routeName);
    }
  }
}
