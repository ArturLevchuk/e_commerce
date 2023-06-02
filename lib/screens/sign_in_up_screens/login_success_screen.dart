import 'package:e_commerce/screens/main_app/home/home_screen.dart';
import 'package:e_commerce/size_config.dart';
import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});
  static const routeName = '/LoginSuccessScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: Column(
        children: [
          // SizedBox(height: SizeConfig.screenHeight * .04),
          const Spacer(),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * .4,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          // SizedBox(height: SizeConfig.screenHeight * .04),
          Text(
            "Login Success",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(30),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(30)),
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

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        "Login Succes",
        style: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ),
    );
  }
}
