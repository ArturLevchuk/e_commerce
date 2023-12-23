import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../repositories/auth_repository.dart';
import '../../../../utils/HttpException.dart';
import '../../../../widgets/default_button.dart';
import '../../forgot_password_screen/forgot_password.dart';
import '../../login_success_screen.dart';
import '../../widgets/error_form.dart';
import '../../widgets/errors_show.dart';
import '../../widgets/form_fields_rounded.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String email = "";
  String password = "";
  bool remember = true;
  bool isLoading = false;

  Future<void> buttonTap() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (errors.isEmpty) {
          _formKey.currentState?.save();
          await RepositoryProvider.of<AuthRepositiry>(context, listen: false)
              .login(email, password, remember);
        }
      }
      if (RepositoryProvider.of<AuthRepositiry>(context, listen: false)
          .isAuth) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context)
            .pushReplacementNamed(LoginSuccessScreen.routeName);
      }
    } on HttpException catch (err) {
      showErrorDialog(context, err.toString());
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldRounded(
            text: "Email",
            icon: Icons.email_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s')),
            ],
            keyboardType: TextInputType.emailAddress,
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
          SizedBox(height: 25.w),
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
              if (value.length < 8 && !errors.contains(kShortPassError)) {
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
            },
          ),
          SizedBox(height: 10.w),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
                activeColor: kPrimaryColor,
              ),
              const Text("Remember me"),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ForgotPasswordScreen.routeName);
                },
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60.w,
            child: FormError(errors: errors),
          ),
          const Spacer(),
          isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary)
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await buttonTap();
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
