import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function() press;
  final bool isActive;
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.w,
      child: TextButton(
        onPressed: isActive ? press : null,
        style: ButtonStyle(
          backgroundColor: isActive
              ? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
              : MaterialStateProperty.all(kSecondaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20).r,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
