import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../sign_up_screen.dart';

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
          "Don't have an account?  ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SignUpScreen.routeName);
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
