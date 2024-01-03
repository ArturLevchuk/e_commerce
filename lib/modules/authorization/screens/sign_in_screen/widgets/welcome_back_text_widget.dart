import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeBackText extends StatelessWidget {
  const WelcomeBackText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline1?.color,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Sign in with your email and password \nor continue with social media",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
