import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../repositories/models/user_information.dart';
import '../../size_config.dart';
import '../../utils/HttpException.dart';
import '../../widgets/AlertDialogTextWithPic.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/DefaultButton.dart';
import '../sign_in_up_screens/widgets/FormError.dart';
import '../sign_in_up_screens/widgets/erros_show.dart';

class UserInformationEditScreen extends StatefulWidget {
  const UserInformationEditScreen({super.key});
  static const routeName = '/UserInformationEditScreen';

  @override
  State<UserInformationEditScreen> createState() =>
      _UserInformationEditScreenState();
}

class _UserInformationEditScreenState extends State<UserInformationEditScreen> {
  @override
  void didChangeDependencies() async {
    if (userInformation == null) {
      setState(() {
        isLoading = true;
      });
      try {
        userInformation =
            await context.read<AuthRepositiry>().getUserInformation();
      } on HttpException catch (err) {
        showErrorDialog(context, err).then((_) {
          Navigator.of(context).pop();
        });
      } catch (err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.toString())));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
  String name = '';
  String phoneNumber = '';
  String adress = '';
  UserInformation? userInformation;
  bool isLoading = false;
  bool isInfUpdating = false;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            backgroundColor: const Color(0xfff5f6f9),
            appBar: customAppBar(context),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    const Spacer(),
                    buildNameField(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    buildPhoneNumberField(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    buildAdressField(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    FormError(errors: errors),
                    const Spacer(flex: 5),
                    isInfUpdating
                        ? const CircularProgressIndicator(color: kPrimaryColor)
                        : DefaultButton(
                            text: "Update Information",
                            press: () async {
                              setState(() {
                                isInfUpdating = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                if (errors.isEmpty) {
                                  _formKey.currentState?.save();
                                  try {
                                    await context
                                        .read<AuthRepositiry>()
                                        .updateUserInformation(UserInformation(
                                          adress: adress,
                                          name: name,
                                          phoneNumber: phoneNumber,
                                        ));
                                  } on HttpException catch (err) {
                                    showErrorDialog(context, err);
                                  } catch (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(err.toString())));
                                  } finally {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const AlertDialogTextWithPic(
                                        text:
                                            "User information succefuly updated!",
                                        svgSrc:
                                            "assets/icons/Check mark rounde.svg",
                                      ),
                                    );
                                  }
                                }
                              }
                              setState(() {
                                isInfUpdating = false;
                              });
                            },
                          ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )
        : const LoadingScreen();
  }

  TextFormField buildAdressField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      decoration: const InputDecoration(
        label: Text(
          "Adress",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your adress",
        suffixIcon:
            CustomSuffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
      initialValue: userInformation?.adress,
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
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(13),
      ],
      decoration: const InputDecoration(
        label: Text(
          "Phone number",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your phone number",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      initialValue: userInformation?.phoneNumber,
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
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        label: Text(
          "Full Name",
          style: TextStyle(color: kTextColor),
        ),
        hintText: "Enter your name",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      initialValue: userInformation?.name,
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

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      title: Text(
        "User Information",
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenWidth(18),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        splashRadius: getProportionateScreenWidth(25),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
