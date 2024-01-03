import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants.dart';
import '../../../../../widgets/default_button.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<String> otpNumber = List.generate(4, (index) => "");
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  Future<void> onTap() async {}

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(focusNodes.length, (index) {
                return SizedBox(
                  width: 55.w,
                  child: TextField(
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    style: TextStyle(fontSize: 20.sp),
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      otpNumber[index] = value;
                      if (index == focusNodes.length - 1) {
                        focusNodes.last.unfocus();
                      } else {
                        if (otpNumber[index + 1] == "") {
                          nextField(
                              value: value, focusNode: focusNodes[index + 1]);
                        }
                      }
                    },
                  ),
                );
              }),
            ],
          ),
          const Spacer(),
          DefaultButton(
            text: "Continue",
            press: onTap,
          ),
        ],
      ),
    );
  }
}

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15.w),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.w),
    borderSide: const BorderSide(color: kBorderColor),
  );
}
