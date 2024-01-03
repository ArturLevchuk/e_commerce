import 'dart:async';
import 'dart:developer';
import '/services/abstracts/notification_service.dart';
import '/services/aw_notification_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'modules/main_module.dart';
import 'app.dart';

void main() async {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    final NotificationService notificationService = AWNotificationService();
    notificationService.init();
    runApp(
      ModularApp(
        module: MainModule(),
        child: const App(),
      ),
    );
  }, (error, stack) {
    log("", error: error, stackTrace: stack);
  });
}
