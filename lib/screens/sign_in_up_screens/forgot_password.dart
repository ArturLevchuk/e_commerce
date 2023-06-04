import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/DefaultButton.dart';
import 'widgets/FormError.dart';
import 'widgets/NoAccountText.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = "/ForgotPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.getBodyHeight(),
              child: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.1),
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
                      SizedBox(height: constraints.maxHeight * 0.1),
                      SizedBox(
                        height: constraints.maxHeight * 0.55,
                        child: const ForgotPassForm(),
                      ),
                      const Spacer(),
                      const NoAccountText(),
                      const Spacer(),
                    ],
                  ),
                );
              }),
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
  final FocusNode _focusNode = FocusNode();
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
        const Spacer(),
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
      focusNode: _focusNode,
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
        email = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
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
