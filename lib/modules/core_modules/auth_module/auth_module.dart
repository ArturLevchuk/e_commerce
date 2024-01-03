import '/services/aw_notification_service.dart';

import '../../../services/abstracts/notification_service.dart';
import '/apis/firebase_auth_api.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/services/abstracts/local_storage_service.dart';
import '/services/sp_local_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../apis/abstract/auth_api.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<AuthApi>(FirebaseAuthApi.new);
    i.add<LocalStorageService>(SPLocalStorageService.new);
    i.add<NotificationService>(AWNotificationService.new);
    i.addSingleton(AuthController.new);
  }
}
