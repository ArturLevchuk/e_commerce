import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import '/modules/shop_module/screens/cart/cart_screen.dart';
import '/utils/uniq_id.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../constants.dart';
import 'abstracts/notification_service.dart';

class AWNotificationService implements NotificationService {
  final AwesomeNotifications _awController = AwesomeNotifications();

  @override
  Future<void> init() async {
    try {
      await _awController.initialize(
        'resource://drawable/ic_launcher',
        [
          NotificationChannel(
            channelKey: cartNotificationKey,
            channelName: "Cart Notifications",
            channelDescription:
                "Notifications about total amount of items in cart",
            importance: NotificationImportance.High,
            channelShowBadge: true,
            defaultColor: kPrimaryColor,
            ledColor: kPrimaryColor,
          ),
          NotificationChannel(
            channelKey: generalNotificationKey,
            channelName: "General Notifications",
            channelDescription: "General information about the app",
            importance: NotificationImportance.High,
            channelShowBadge: true,
            defaultColor: kPrimaryColor,
            ledColor: kPrimaryColor,
          ),
        ],
      );
      await _awController.setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
      );
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> cancelNotification({required String id}) async {
    try {
      await _awController.cancel(int.parse(id));
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> cancelNotificationsByChannelKey(
      {required String channelKey}) async {
    try {
      await _awController.cancelNotificationsByChannelKey(channelKey);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<String> createNotification({
    required String title,
    required String body,
    String? channelKey,
    required Duration timeOut,
  }) async {
    try {
      final id = createUniqueId();
      _awController.createNotification(
        content: NotificationContent(
            id: id,
            channelKey: channelKey ?? generalNotificationKey,
            title: title,
            body: body,
            category: NotificationCategory.Recommendation),
        schedule: NotificationInterval(interval: timeOut.inSeconds),
      );
      return id.toString();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      await _awController.cancelAll();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<bool> isNotificationAllowed() async {
    final bool isAllowed = await _awController.isNotificationAllowed();
    return isAllowed;
  }

  @override
  Future<void> requestNotificationPermission() async {
    await _awController.requestPermissionToSendNotifications();
  }
}

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
    if (receivedAction.channelKey == cartNotificationKey) {
      Modular.to.navigate("/", arguments: CartScreen.routeName);
      AwesomeNotifications()
          .cancelNotificationsByChannelKey(cartNotificationKey);
    }
    // AwesomeNotifications().cancelNotificationsByChannelKey(cartNotificationKey);
    // if (receivedAction.channelKey == cartNotificationKey) {
    //   App.navigatorKey.currentState?.pushReplacementNamed('/');
    // }
  }
}
