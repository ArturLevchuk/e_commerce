// ignore_for_file: use_build_context_synchronously

import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/core_modules/user_settings_module/vm/user_settings_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';
import '../../../apis/models/user_information.dart';
import '../../../widgets/alert_dialog_with_pic.dart';
import '../../../widgets/CustomSuffixIcon.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/back_appbar_button.dart';
import '../../authorization/screens/widgets/error_form.dart';
import '../../authorization/screens/widgets/errors_show.dart';

class UserInformationEditScreen extends StatefulWidget {
  const UserInformationEditScreen({super.key});
  static const routeName = '/UserInformationEditScreen';

  @override
  State<UserInformationEditScreen> createState() =>
      _UserInformationEditScreenState();
}

class _UserInformationEditScreenState extends State<UserInformationEditScreen> {
  late UserInformation userInformation =
      context.read<UserSettingsController>().state.userInformation;

  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
  bool isInfUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: RPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 30.w),
                  buildNameField(),
                  SizedBox(height: 30.w),
                  buildPhoneNumberField(),
                  SizedBox(height: 30.w),
                  buildAdressField(),
                  SizedBox(height: 30.w),
                  FormError(errors: errors),
                ],
              )),
        ),
      ),
      bottomNavigationBar: RPadding(
        padding: const EdgeInsets.all(20),
        child: isInfUpdating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary),
                ],
              )
            : DefaultButton(
                text: "Update Information",
                press: () async {
                  try {
                    setState(() {
                      isInfUpdating = true;
                    });
                    final authController = context.read<AuthController>();
                    final userId = authController.state.id;
                    final token = authController.state.token;
                    await context
                        .read<UserSettingsController>()
                        .updateUserInformation(
                          userInformation: userInformation,
                          token: token,
                          userId: userId,
                        );
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialogTextWithPic(
                        text: "User information succefuly updated!",
                        svgSrc: "assets/icons/Check mark rounde.svg",
                      ),
                    );
                  } catch (err) {
                    await showErrorDialog(
                      context: context,
                      err: err.toString(),
                    );
                  } finally {
                    setState(() {
                      isInfUpdating = false;
                    });
                  }
                },
              ),
      ),
    );
  }

  TextFormField buildAdressField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      decoration: roundInputDecoration.copyWith(
        labelText: "Adress",
        suffixIcon:
            const CustomSuffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
      maxLines: 5,
      initialValue: userInformation.adress,
      onSaved: (newValue) {
        userInformation = userInformation.copyWith(adress: newValue!);
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
      decoration: roundInputDecoration.copyWith(
        labelText: "Phone number",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      initialValue: userInformation.phoneNumber,
      onSaved: (newValue) {
        userInformation = userInformation.copyWith(phoneNumber: newValue!);
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
      decoration: roundInputDecoration.copyWith(
        labelText: "Full Name",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      initialValue: userInformation.name,
      onSaved: (newValue) {
        userInformation = userInformation.copyWith(name: newValue!);
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

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      title: Text(
        "User Information",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      leading: backAppBarButton(context),
    );
  }
}
