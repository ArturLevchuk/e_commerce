import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../loading_screen.dart';
import '../main_app/home/home_screen.dart';
import '../splash_screen.dart';
import 'auth_bloc/auth_bloc.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  Widget homeScreen(AuthState state) {
    if (state is Unauthenticated) {
      return const SplashScreen();
    } else if (state is Authenticated) {
      return const HomeScreen();
    } else {
      return const LoadingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return homeScreen(state);
      },
    );
  }
}
