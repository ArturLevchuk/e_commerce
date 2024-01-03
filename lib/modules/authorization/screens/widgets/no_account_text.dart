import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../sign_up_screen/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
    this.replacePage = false,
  }) : super(key: key);

  final bool replacePage;

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
            if (replacePage) {
              Modular.to.pushReplacementNamed(".${SignUpScreen.routeName}");
            } else {
              Modular.to.pushNamed(".${SignUpScreen.routeName}");
            }
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
