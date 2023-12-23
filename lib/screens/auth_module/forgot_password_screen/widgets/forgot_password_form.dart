import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../widgets/default_button.dart';
import '../../otp_screen/otp_screen.dart';
import '../../widgets/error_form.dart';
import '../../widgets/form_fields_rounded.dart';

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
        EmailTextForm(
          onSaved: (newValue) {
            email = newValue!;
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
        ),
        SizedBox(height: 20.w),
        Expanded(
          child: FormError(errors: errors),
        ),
        SizedBox(height: 10.w),
        DefaultButton(
          text: "Continue",
          press: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState?.save();
              Navigator.of(context)
                  .pushNamed(OtpScreen.routeName, arguments: email);
            }
          },
        ),
      ]),
    );
  }
}
