import 'package:e_commerce/repositories/cart_repository.dart';
import 'package:e_commerce/repositories/orders_repository.dart';
import 'package:e_commerce/screens/loading_screen.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/main_app/home/home_screen.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/products_repository.dart';
import '../../routs.dart';
import '../../theme.dart';
import '../main_app/home/products_bloc/products_bloc.dart';
import '../splash_screen.dart';
import 'auth_bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  Widget homeScreen(AuthState state) {
    if (state is Unauthenticated) {
      return const SplashScreen();
    } else if (state is Authenticated) {
      return const HomeScreen();
    }
    return const LoadingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
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
        child: BlocBuilder<AuthBloc, AuthState>(
          // buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return MaterialApp(
              title: 'Flutter E-commerce',
              debugShowCheckedModeBanner: false,
              theme: theme(),
              home: homeScreen(state),
              routes: routes,
            );
          },
        ),
      ),
    );
  }
}
