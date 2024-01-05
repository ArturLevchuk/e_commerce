import 'package:e_commerce/modules/core_modules/app_settings_module/vm/app_settings_controller.dart';
import 'package:e_commerce/widgets/back_appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/SettingsScreen';

  @override
  Widget build(BuildContext context) {
    final settingsController = context.read<AppSettingsController>();
    return Scaffold(
      appBar: appbar(context),
      body: StreamBuilder(
          stream: settingsController.stream,
          builder: (context, snapshot) {
            final state = settingsController.state;
            return SingleChildScrollView(
              child: Column(
                children: [
                  RPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Theme mode",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Icon(Icons.brightness_auto),
                            Radio(
                              value: ThemeMode.system,
                              groupValue: state.themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  settingsController.changeThemeMode(value);
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.light_mode),
                            Radio(
                              value: ThemeMode.light,
                              groupValue: state.themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  settingsController.changeThemeMode(value);
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.dark_mode),
                            Radio(
                              value: ThemeMode.dark,
                              groupValue: state.themeMode,
                              onChanged: (value) {
                                if (value != null) {
                                  settingsController.changeThemeMode(value);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Settings",
        style: TextStyle(
          // color: Colors.black,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      titleSpacing: 0,
      leading: backAppBarButton(context),
    );
  }
}
