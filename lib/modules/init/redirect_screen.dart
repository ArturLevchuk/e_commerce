import 'dart:async';

import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '../../widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core_modules/user_settings_module/vm/user_settings_controller.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key, this.redirectRoute});

  final String? redirectRoute;

  Future<void> initCoreModules(BuildContext context) async {
    try {
      final authController = context.read<AuthController>();
      await authController.tryAutoLogin().then((_) async {
        if (authController.state.authStatus == AuthStatus.authenticated) {
          final String token = authController.state.token;
          final String userId = authController.state.id;
          await context.read<UserSettingsController>().init(
                token: token,
                userId: userId,
              );
          Modular.to.navigate("/shop${redirectRoute ?? "/"}");
        } else {
          Modular.to.navigate("/authorization/");
        }
      });
    } catch (err) {
      // ignore: use_build_context_synchronously
      showErrorDialog(
        context: context,
        err: err.toString(),
        retryFun: () async {
          await initCoreModules(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initCoreModules(context);
    });
    return const LoadingScreen();
  }
}
