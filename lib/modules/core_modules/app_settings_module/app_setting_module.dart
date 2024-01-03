import '/modules/core_modules/app_settings_module/vm/app_settings_controller.dart';
import '/services/abstracts/local_storage_service.dart';
import '/services/sp_local_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppSettingsModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<LocalStorageService>(SPLocalStorageService.new);
    i.addSingleton(AppSettingsController.new);
  }
}
