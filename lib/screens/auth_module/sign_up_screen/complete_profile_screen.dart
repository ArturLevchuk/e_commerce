import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../size_config.dart';
import 'widgets/complete_profile_form.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});
  static const routeName = "/CompleteProfileScreen";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: appBar(context),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          child: Container(
            height: getBodyHeight(context),
            padding: const EdgeInsets.symmetric(horizontal: 20).r,
            child: LayoutBuilder(builder: (context, constraints) {
              final bodyHeight = constraints.maxHeight;
              return Column(
                children: [
                  Text(
                    "Complete Profile",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Complete your details or continue\nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: bodyHeight * 0.04),
                  SizedBox(
                      height: bodyHeight * .7,
                      child: CompleteProfileForm(args: args)),
                  const Spacer(),
                  Text(
                    "By continuing your confirm that you agree with our Term and Condition",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                ],
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
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 20.w,
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text(
        "Sign Up",
        style: TextStyle(color: const Color(0XFF8B8B8B), fontSize: 18.sp),
      ),
    );
  }
}

