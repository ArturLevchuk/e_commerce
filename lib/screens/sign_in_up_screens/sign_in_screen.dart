import 'package:e_commerce/constants.dart';
import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/sign_in_up_screens/forgot_password.dart';
import 'package:e_commerce/screens/sign_in_up_screens/login_success_screen.dart';
import 'package:e_commerce/size_config.dart';
import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/HttpException.dart';
import '../../widgets/CustomSuffixIcon.dart';
import 'widgets/erros_show.dart';
import 'widgets/FormError.dart';
import 'widgets/NoAccountText.dart';
import 'widgets/SocialCard.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const routeName = "/SignInScreen";

  // bool _hasFocus = false;
  // List<FocusNode> _focusNodes = [];

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _getFocusNodes();
  //   });
  // }

  // void _getFocusNodes() {
  //   final focusScope = FocusScope.of(context);
  //   _focusNodes = focusScope.descendants.whereType<FocusNode>().toList();
  //   for (var focusNode in _focusNodes) {
  //     focusNode.addListener(() {
  //       setState(() {
  //         _hasFocus = focusNode.hasFocus;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: newAppBar(),
        body: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: SafeArea(
                child: SizedBox(
              height: SizeConfig.getBodyHeight(),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: LayoutBuilder(builder: (context, constraints) {
                  final bodyHeight = constraints.maxHeight;
                  return Column(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(28),
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Sign in with your email and password \nor continue with social media",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: bodyHeight * .08),
                      SizedBox(
                        height: bodyHeight * .6,
                        child: const SignForm(),
                      ),
                      const Spacer(),
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
                      const NoAccountText(),
                      const Spacer(),
                    ],
                  );
                }),
              ),
            )),
          ),
        ),
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Sign In",
        style: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ),
    );
  }
}

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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
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
          FormError(errors: errors),
          const Spacer(),
          isLoading
              ? const CircularProgressIndicator(color: kPrimaryColor)
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (_formKey.currentState!.validate()) {
                        if (errors.isEmpty) {
                          _formKey.currentState?.save();
                          await RepositoryProvider.of<AuthRepositiry>(context,
                                  listen: false)
                              .login(email, password, remember);
                        }
                      }
                    } on HttpException catch (err) {
                      showErrorDialog(context, err.toString());
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err.toString())));
                    } finally {
                      if (RepositoryProvider.of<AuthRepositiry>(context,
                              listen: false)
                          .isAuth) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context)
                            .pushReplacementNamed(LoginSuccessScreen.routeName);
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      focusNode: _emailFocusNode,
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
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      focusNode: _passFocusNode,
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
}
