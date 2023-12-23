import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.text,
    required this.press,
    this.buttonText = "See More",
  }) : super(key: key);

  final String text, buttonText;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return RPadding(
      padding: EdgeInsets.only(left: 20.r, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16.sp),
          ),
          TextButton(
            onPressed: press,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
