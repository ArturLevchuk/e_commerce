import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../sign_up_screen/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 16.sp),
        ),
        TextButton(
          style: Theme.of(context).textButtonTheme.style?.copyWith(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
          onPressed: () {
            Navigator.of(context).pushNamed(SignUpScreen.routeName);
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
