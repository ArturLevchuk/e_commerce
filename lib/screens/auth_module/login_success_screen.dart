import 'package:e_commerce/screens/main_app/home/home_screen.dart';
import 'package:e_commerce/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});
  static const routeName = '/LoginSuccessScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/success.png",
            height: 0.4.sh,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Text(
            "Login Success",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1?.color,
              fontWeight: FontWeight.bold,
              fontSize: 26.sp,
            ),
          ),
          const Spacer(),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: DefaultButton(
              text: "Back to home",
              press: () {
                Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        "Login Succes",
        style: TextStyle(color: const Color(0XFF8B8B8B), fontSize: 18.sp),
      ),
    );
  }
}
