import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/repositories/cart_repository.dart';
import 'package:e_commerce/repositories/orders_repository.dart';
import 'package:e_commerce/screens/app/appScreen.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/products_repository.dart';
import '../../routs.dart';
import '../../theme.dart';
import '../../utils/notification_controller.dart';
import '../main_app/home/products_bloc/products_bloc.dart';
import 'auth_bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          lazy: false,
          create: (context) => AuthRepositiry(),
        ),
        RepositoryProvider(
          create: (context) => ProductsRepository(
            authToken: context.read<AuthRepositiry>().token!,
            userId: context.read<AuthRepositiry>().userId,
          ),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(
              userId: context.read<AuthRepositiry>().userId,
              authToken: context.read<AuthRepositiry>().token!),
        ),
        RepositoryProvider(
          create: (context) => OrdersRepository(
              userId: context.read<AuthRepositiry>().userId,
              authToken: context.read<AuthRepositiry>().token!),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) =>
                AuthBloc(context.read<AuthRepositiry>())..add(TryAutoLogin()),
          ),
          BlocProvider(
            create: (context) =>
                ProductsBloc(context.read<ProductsRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CartBloc(cartRepository: context.read<CartRepository>()),
          ),
          BlocProvider(
            create: (context) => OrdersBloc(context.read<OrdersRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter E-commerce',
          debugShowCheckedModeBanner: false,
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: ThemeMode.system,
          navigatorKey: navigatorKey,
          home: const AppScreen(),
          routes: routes,
        ),
      ),
    );
  }
}
