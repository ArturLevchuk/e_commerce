import '../../../../utils/size_config.dart';
import '/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/no_account_text.dart';
import '../widgets/social_card.dart';
import 'widgets/sign_form.dart';
import 'widgets/welcome_back_text_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const routeName = "/SignInScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: getBodyHeight(context),
              width: double.infinity,
              child: RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  final bodyHeight = constraints.maxHeight;
                  return Column(
                    children: [
                      const WelcomeBackText(),
                      SizedBox(height: bodyHeight * .07),
                      SizedBox(
                        height: bodyHeight * .6,
                        child: const SignForm(),
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
                      const NoAccountText(),
                      const Spacer(),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Sign In",
      ),
    );
  }
}
