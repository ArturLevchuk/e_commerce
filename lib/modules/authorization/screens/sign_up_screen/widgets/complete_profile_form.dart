import '/modules/authorization/screens/widgets/form_fields_rounded.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants.dart';
import '../../../../../widgets/default_button.dart';
import '../../widgets/error_form.dart';
import '../../widgets/errors_show.dart';

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

  Future<void> onTap() async {
    if (_formKey.currentState!.validate()) {
      if (errors.isNotEmpty) {
        return;
      }
      _formKey.currentState?.save();
      try {
        setState(() {
          isLoading = true;
        });
        await context.read<AuthController>().register({
          'email': widget.args['email'] as String,
          'password': widget.args['password'] as String,
          'name': name,
          'phoneNumber': phoneNumber,
          'adress': adress,
        }).then((_) {
          Modular.to.navigate("/shop/");
        });
      } catch (err) {
        // ignore: use_build_context_synchronously
        showErrorDialog(
          context: context,
          err: err.toString(),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldRounded(
            text: "Name",
            onSaved: (newValue) {
              adress = newValue!;
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
            icon: Icons.person_outline,
          ),
          SizedBox(height: 15.w),
          TextFormFieldRounded(
            text: "Phone Number",
            icon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
            ],
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
              }
              if (!phoneValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidPhoneNumberError) &&
                  !errors.contains(kPhoneNumberNullError)) {
                setState(() {
                  errors.add(kInvalidPhoneNumberError);
                });
              }
              return null;
            },
          ),
          SizedBox(height: 15.w),
          TextFormFieldRounded(
            text: "Adress",
            icon: Icons.location_on_outlined,
            keyboardType: TextInputType.streetAddress,
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
          ),
          SizedBox(height: 15.w),
          Expanded(child: FormError(errors: errors)),
          SizedBox(height: 10.w),
          isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary)
              : DefaultButton(
                  text: "Continue",
                  press: () async {
                    await onTap();
                  },
                ),
        ],
      ),
    );
  }
}
