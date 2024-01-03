import '../../../apis/abstract/user_settings_api.dart';
import '../../../apis/firebase_user_settings_api.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'vm/user_settings_controller.dart';

class UserSettingsModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<UserSettingsApi>(FirebaseUserSettingsApi.new);
    i.addSingleton(UserSettingsController.new);
  }
}
