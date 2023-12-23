import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/loading_screen.dart';
import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';
import '../../repositories/models/user_information.dart';
import '../../size_config.dart';
import '../../utils/HttpException.dart';
import '../../widgets/alert_dialog_with_pic.dart';
import '../../widgets/CustomSuffixIcon.dart';
import '../../widgets/default_button.dart';
import '../../widgets/back_appbar_button.dart';
import '../auth_module/widgets/error_form.dart';
import '../auth_module/widgets/errors_show.dart';

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
    super.didChangeDependencies();
    if (userInformation != null) return;
    setState(() {
      isLoading = true;
    });
    try {
      userInformation =
          await context.read<AuthRepositiry>().getUserInformation();
    } on HttpException catch (err) {
      // ignore: use_build_context_synchronously
      showErrorDialog(context, err.toString()).then((_) {
        Navigator.of(context).pop();
      });
    } catch (err) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
    setState(() {
      isLoading = false;
    });
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
                              await showErrorDialog(context, err.toString());
                            } catch (err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(err.toString())));
                            } finally {
                              await showDialog(
                                context: context,
                                builder: (_) => const AlertDialogTextWithPic(
                                  text: "User information succefuly updated!",
                                  svgSrc: "assets/icons/Check mark rounde.svg",
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
            ),
          )
        : const LoadingScreen();
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
      decoration: roundInputDecoration.copyWith(
        labelText: "Phone number",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
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
      decoration: roundInputDecoration.copyWith(
        labelText: "Full Name",
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
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
