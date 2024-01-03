import '/widgets/back_appbar_button.dart';

import '/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/size_config.dart';
import '../../../../utils/CustomScrollBehavior.dart';
import 'widgets/otp_form.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.email});
  static const routeName = '/OtpScreen';
  final String email;
  @override
  Widget build(BuildContext context) {
    // final String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: appBar(context),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: Container(
            height: getBodyHeight(context),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20).r,
            child: LayoutBuilder(builder: (context, constraints) {
              final bodyHeight = constraints.maxHeight;
              return Column(children: [
                const Spacer(flex: 3),
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "We sent your code to $email",
                  textAlign: TextAlign.center,
                ),
                buildTimer(),
                const Spacer(flex: 3),
                SizedBox(
                  height: bodyHeight * .6,
                  child: const OtpForm(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Resend OTP Code",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const Spacer(),
              ]);
            }),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: IntTween(begin: 59, end: 0),
          duration: const Duration(seconds: 59),
          builder: (context, value, child) => Text(
            "00 : ${value.toString().padLeft(2, "0")}",
            style: const TextStyle(color: kPrimaryColor),
          ),
          onEnd: () {},
        )
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("OTP Verification"),
      leading: backAppBarButton(context),
    );
  }
}
