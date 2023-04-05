import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/DefaultButton.dart';
import 'complete_profile_screen.dart';
import 'widgets/FormError.dart';
import 'widgets/SocialCard.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const routeName = "/SignUpScreen";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: newAppBar(context),
        body: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [
                  Text(
                    "Register Account",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Complete your details or continue\nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  const SignUpForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
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
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    "By continuing you confirm that you agree\nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kTextColor,
                        fontSize: getProportionateScreenWidth(12)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar newAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: getProportionateScreenWidth(25),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: const Text(
        "Sign Up",
        style: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String confirmPassword = "";
  Map<String, String> signUpInf = {
    'email': '',
    'password': '',
  };
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _confirmPassFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                if (errors.isEmpty) {
                  _formKey.currentState?.save();
                  await Navigator.of(context).pushNamed(
                      CompleteProfileScreen.routeName,
                      arguments: signUpInf);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      focusNode: _confirmPassFocusNode,
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: const Text(
          "Confirm Password",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Re-enter your Password",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      obscureText: true,
      onSaved: (newValue) {
        confirmPassword = newValue!;
      },
      validator: (value) {
        if (signUpInf['password'] != confirmPassword &&
            !errors.contains(kMatchPassError)) {
          setState(() {
            errors.add(kMatchPassError);
          });
        }
        return null;
      },
      onChanged: (value) {
        confirmPassword = value;
        if (signUpInf['password'] == confirmPassword &&
            errors.contains(kMatchPassError)) {
          setState(() {
            errors.remove(kMatchPassError);
          });
        }
      },
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: const Text(
          "Email",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your email",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
      onSaved: (newValue) {
        signUpInf['email'] = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          setState(() {
            errors.remove(kEmailNullError);
          });
        } else if (emailValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.remove(kInvalidEmailError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kEmailNullError)) {
          setState(() {
            errors.add(kEmailNullError);
          });
        } else if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      focusNode: _passFocusNode,
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: const Text(
          "Password",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your Password",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      obscureText: true,
      onSaved: (newValue) {
        signUpInf['password'] = newValue!;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kPassNullError)) {
          setState(() {
            errors.add(kPassNullError);
          });
        } else if (value.length < 8 && !errors.contains(kShortPassError)) {
          setState(() {
            errors.add(kShortPassError);
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPassNullError)) {
          setState(() {
            errors.remove(kPassNullError);
          });
        } else if (value.length >= 8 && errors.contains(kShortPassError)) {
          setState(() {
            errors.remove(kShortPassError);
          });
        }
        signUpInf['password'] = value;
      },
    );
  }
}
