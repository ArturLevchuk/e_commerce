import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/utils/custom_blocobserver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'screens/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
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
