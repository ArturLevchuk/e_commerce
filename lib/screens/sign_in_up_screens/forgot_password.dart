import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/DefaultButton.dart';
import 'widgets/FormError.dart';
import 'widgets/NoAccountText.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = "/ForgotPasswordScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(context),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              Text(
                "Forgot Password",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Please enter your email and we will send \nyou a link to return your account",
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const ForgotPassForm(),
              const Spacer(),
              const NoAccountText(),
              SizedBox(height: getProportionateScreenWidth(10)),
            ],
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
        "Forgot Password",
        style: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        buildEmailFormField(),
        SizedBox(height: getProportionateScreenHeight(20)),
        FormError(errors: errors),
        SizedBox(height: SizeConfig.screenHeight * 0.25),
        DefaultButton(
          text: "Continue",
          press: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
            }
          },
        ),
      ]),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        label: Text(
          "Email",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your email",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
      onSaved: (newValue) {
        email = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          // return "Please enter your email";
          setState(() {
            errors.remove(kEmailNullError);
          });
        }
        if (emailValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.remove(kInvalidEmailError);
          });
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kEmailNullError)) {
          // return "Please enter your email";
          setState(() {
            errors.add(kEmailNullError);
          });
        }
        if (!emailValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidEmailError)) {
          setState(() {
            errors.add(kInvalidEmailError);
          });
        }
        return null;
      },
    );
  }
}
