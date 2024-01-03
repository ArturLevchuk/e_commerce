import '/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/size_config.dart';
import '../../../../widgets/back_appbar_button.dart';
import '../widgets/social_card.dart';
import 'widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const routeName = "/SignUpScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: getBodyHeight(context),
              child: LayoutBuilder(builder: (context, constraints) {
                final bodyHeight = constraints.maxHeight;
                return Column(
                  children: [
                    Text(
                      "Register Account",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Complete your details or continue\nwith social media",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: bodyHeight * 0.01),
                    SizedBox(
                      height: bodyHeight * .64,
                      child: const SignUpForm(),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialCard(
                          icon: "assets/icons/facebook-2.svg",
                          press: () {},
                        ),
                        SocialCard(
                          icon: "assets/icons/google-icon.svg",
                          press: () {},
                        ),
                        SocialCard(
                          icon: "assets/icons/twitter.svg",
                          press: () {},
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "By continuing you confirm that you agree\nwith our Term and Condition",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontSize: 12.sp),
                    ),
                    const Spacer(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: backAppBarButton(context),
      title: const Text(
        "Sign Up",
      ),
    );
  }
}
