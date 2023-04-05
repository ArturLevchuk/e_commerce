import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../repositories/auth_repository.dart';
import '../../size_config.dart';
import '../../utils/HttpException.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/DefaultButton.dart';
import 'login_success_screen.dart';
import 'widgets/erros_show.dart';
import 'widgets/FormError.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});
  static const routeName = "/CompleteProfileScreen";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: newAppBar(context),
        body: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [
                  Text(
                    "Complete Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Complete your details or continue\nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  CompleteProfileForm(args: args),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  const Text(
                    "By continuing your confirm that you agree with our Term and Condition",
                    style: TextStyle(color: kTextColor),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: SizeConfig.screenHeight * 0.04),
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

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key, required this.args});

  final Map<String, String> args;
  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String name = '';
  String phoneNumber = '';
  String adress = '';
  bool isLoading = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _adressFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _adressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: SizeConfig.screenHeight * 0.63,
        child: Column(
          children: [
            buildNameField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPhoneNumberField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildAdressField(),
            SizedBox(height: getProportionateScreenHeight(20)),
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
                      if (_formKey.currentState!.validate()) {
                        if (errors.isEmpty) {
                          _formKey.currentState?.save();
                          try {
                            await RepositoryProvider.of<AuthRepositiry>(context,
                                    listen: false)
                                .signup({
                              'email': widget.args['email'] as String,
                              'password': widget.args['password'] as String,
                              'name': name,
                              'phoneNumber': phoneNumber,
                              'adress': adress,
                            });
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
                              Navigator.of(context).pushReplacementNamed(
                                  LoginSuccessScreen.routeName);
                            }
                          }
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }

  TextFormField buildAdressField() {
    return TextFormField(
      focusNode: _adressFocusNode,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          "Adress",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your adress",
        suffixIcon:
            CustomSuffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
      onSaved: (newValue) {
        adress = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kAddressNullError)) {
          setState(() {
            errors.remove(kAddressNullError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kAddressNullError)) {
          setState(() {
            errors.add(kAddressNullError);
          });
        }
        return null;
      },
    );
  }

  TextFormField buildPhoneNumberField() {
    return TextFormField(
      focusNode: _phoneFocusNode,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(13),
      ],
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          "Phone number",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your phone number",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      onSaved: (newValue) {
        phoneNumber = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPhoneNumberNullError)) {
          setState(() {
            errors.remove(kPhoneNumberNullError);
          });
        } else if (phoneValidatorRegExp.hasMatch(value) &&
            errors.contains(kInvalidPhoneNumberError)) {
          setState(() {
            errors.remove(kInvalidPhoneNumberError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kPhoneNumberNullError)) {
          setState(() {
            errors.add(kPhoneNumberNullError);
          });
        } else if (!phoneValidatorRegExp.hasMatch(value) &&
            !errors.contains(kInvalidPhoneNumberError)) {
          setState(() {
            errors.add(kInvalidPhoneNumberError);
          });
        }
        return null;
      },
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        focusedBorder: Theme.of(context)
            .inputDecorationTheme
            .border
            ?.copyWith(borderSide: const BorderSide(color: kPrimaryColor)),
        label: Text(
          "Full Name",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your name",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      onSaved: (newValue) {
        name = newValue!;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kNamelNullError)) {
          setState(() {
            errors.remove(kNamelNullError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty && !errors.contains(kNamelNullError)) {
          setState(() {
            errors.add(kNamelNullError);
          });
        }
        return null;
      },
    );
  }
}
