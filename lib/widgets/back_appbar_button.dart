import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget backAppBarButton(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      splashRadius: 20.w,
      onPressed: () {
        Modular.to.pop();
      },
    );
