import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget backAppBarButton(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    splashRadius: 20.w,
    onPressed: () {
      Navigator.of(context).pop();
    });
