import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'modules/core_modules/app_settings_module/vm/app_settings_controller.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final AppSettingsController appSettingsController =
        context.read<AppSettingsController>();
    appSettingsController.init();
    return StreamBuilder<AppSettings>(
      stream: appSettingsController.stream,
      builder: (context, snapshot) {
        return MaterialApp.router(
          title: 'Flutter E-commerce',
          debugShowCheckedModeBanner: false,
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: appSettingsController.state.themeMode,
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}
