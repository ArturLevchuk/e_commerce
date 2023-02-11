import 'package:awesome_notifications/awesome_notifications.dart';
import 'constants.dart';
import 'utils/notification_controller.dart';
import 'package:flutter/material.dart';
import 'screens/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelKey: cartNotificationKey,
        channelName: "Cart Notifications",
        channelDescription: "Notifications about total amount of items in cart",
        importance: NotificationImportance.High,
        channelShowBadge: true,
        defaultColor: kPrimaryColor,
        ledColor: kPrimaryColor,
      ),
    ],
  );

  runApp(const App());
}
