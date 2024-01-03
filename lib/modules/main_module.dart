import '/modules/shop_module/shop_module.dart';

import '/modules/init/init_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'authorization/authorization_module.dart';
import 'core_modules/app_settings_module/app_setting_module.dart';
import 'core_modules/auth_module/auth_module.dart';
import 'core_modules/user_settings_module/user_settings_module.dart';

class MainModule extends Module {
  @override
  List<Module> get imports => [
        AuthModule(),
        UserSettingsModule(),
        AppSettingsModule(),
      ];

  @override
  void routes(RouteManager r) {
    r.module("/", module: InitModule());
    r.module("/authorization", module: AuthorizationModule());
    r.module("/shop", module: ShopModule());
  }
}
