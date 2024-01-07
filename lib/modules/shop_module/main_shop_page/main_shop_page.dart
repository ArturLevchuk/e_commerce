// ignore_for_file: use_build_context_synchronously
import 'package:e_commerce/modules/core_modules/user_settings_module/vm/user_settings_controller.dart';

import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/shop_module/core_buisness_logic/cart/vm/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../services/abstracts/notification_service.dart';
import '../../core_modules/auth_module/vm/auth_controller.dart';
import '../core_buisness_logic/products/vm/products_controller.dart';
import '../screens/home_screen/home_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class MainShopPage extends StatelessWidget {
  const MainShopPage({super.key});
  Future<void> init(BuildContext context) async {
    try {
      final authController = context.read<AuthController>();
      final String userId = authController.state.id;
      final String authToken = authController.state.token;
      final userSettingsController = context.read<UserSettingsController>();
      final cartController = context.read<CartController>();
      final productsController = context.read<ProductsController>();
      if (userSettingsController.state.userInfoStatus ==
          UserInfoStatus.unknown) {
        userSettingsController.init(userId: userId, token: authToken);
      }
      if (productsController.state.productsLoadStatus ==
          ProductsLoadStatus.initial) {
        await productsController.fetchAndSetProducts(
            userId: userId, authToken: authToken);
        if (cartController.state.cartLoadStatus == CartLoadStatus.initial) {
          await cartController.fetchAndSetCart(
              userId: userId, authToken: authToken);
        }
      }
    } catch (err) {
      showErrorDialog(
        context: context,
        err: err.toString(),
        retryFun: () async {
          await init(context);
        },
      );
    }
  }

  Future<void> notificationsPermissonsCheck(BuildContext context) async {
    final NotificationService notificationService = context.read<NotificationService>();
    return notificationService.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Allow Notifications"),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Remind me later',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    notificationService.requestNotificationPermission().then(
                          (_) => Modular.to.pop(),
                        ),
                child: Text(
                  'Allow',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init(context);
      await notificationsPermissonsCheck(context);
    });
    if (Modular.to.path == "/shop/") {
      Modular.to.navigate(".${HomeScreen.routeName}");
    }
    return const Scaffold(
      extendBody: true,
      body: RouterOutlet(),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
