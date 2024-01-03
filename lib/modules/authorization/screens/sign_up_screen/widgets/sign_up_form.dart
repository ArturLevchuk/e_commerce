import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants.dart';
import '../../../../../widgets/default_button.dart';
import '../complete_profile_screen.dart';
import '../../widgets/error_form.dart';
import '../../widgets/form_fields_rounded.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String confirmPassword = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 9.w),
          TextFormFieldRounded(
            text: "Email",
            icon: Icons.email_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s')),
            ],
            onSaved: (newValue) {
              email = newValue!.trim();
            },
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailEmptyError)) {
                setState(() {
                  errors.remove(kEmailEmptyError);
                });
              }
              if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
            },
            validator: (value) {
              if (value == null) return;
              if (value.isEmpty && !errors.contains(kEmailEmptyError)) {
                setState(() {
                  errors.add(kEmailEmptyError);
                });
              }
              if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError) &&
                  !errors.contains(kEmailEmptyError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
          ),
          SizedBox(height: 18.w),
          PasswordTextForm(
            onSaved: (newValue) {
              password = newValue!;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kPassNullError)) {
                setState(() {
                  errors.add(kPassNullError);
                });
              }
              if (value.length < 8 &&
                  !errors.contains(kShortPassError) &&
                  !errors.contains(kPassNullError)) {
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
              }
              if (value.length >= 8 && errors.contains(kShortPassError)) {
                setState(() {
                  errors.remove(kShortPassError);
                });
              }
              setState(() {
                password = value;
              });
            },
          ),
          SizedBox(height: 18.w),
          PasswordTextForm(
            text: "Confirm Password",
            onSaved: (_) {},
            validator: (_) {
              return null;
            },
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
              if (password == confirmPassword &&
                  errors.contains(kMatchPassError)) {
                setState(() {
                  errors.remove(kMatchPassError);
                });
              }
            },
          ),
          SizedBox(height: 9.w),
          Expanded(child: FormError(errors: errors)),
          SizedBox(height: 10.w),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                if (errors.isNotEmpty) {
                  return;
                }
                _formKey.currentState?.save();
                Modular.to
                    .pushNamed(".${CompleteProfileScreen.routeName}", arguments: {
                  'email': email,
                  'password': password,
                });
                // await Navigator.of(context).pushNamed(
                //   CompleteProfileScreen.routeName,
                //   arguments: {
                //     'email': email,
                //     'password': password,
                //   },
                // );
              }
            },
          ),
        ],
      ),
    );
  }
}
