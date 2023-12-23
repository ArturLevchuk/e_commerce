import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../size_config.dart';
import '../../../widgets/back_appbar_button.dart';
import '../widgets/no_account_text.dart';
import 'widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = "/ForgotPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: getBodyHeight(context),
            child: LayoutBuilder(builder: (context, constraints) {
              return RPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Please enter your email and we will send \nyou a link to return your account",
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: const ForgotPassForm(),
                    ),
                    const RPadding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: NoAccountText(),
                    ),
                  ],
                ),
              );
            }),
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
        "Forgot Password",
      ),
    );
  }
}
