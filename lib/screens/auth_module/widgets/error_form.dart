import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
              errors.length, (index) => formErrorText(err: errors[index])),
        ),
      ),
    );
  }

  Row formErrorText({required String err}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: 14.w,
          width: 14.w,
        ),
        SizedBox(width: 10.w),
        Text(err),
      ],
    );
  }
}
