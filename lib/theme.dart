import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

// Light theme
ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        surface: ksurfaceColorLight,
      ),
      fontFamily: "Muli",
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: kgeneralTextColor,
          fontSize: 16.sp,
        ),
      ),
      dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.transparent,
      ),
      indicatorColor: kPrimaryColor,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const MaterialStatePropertyAll(kgeneralTextColor),
          textStyle: MaterialStatePropertyAll(
            TextStyle(fontSize: 13.sp),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10).r),
          ),
          overlayColor: MaterialStatePropertyAll(kPrimaryColor.withOpacity(.1)),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

// Dark theme
ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: kPrimaryColor,
        background: kbackgroundColorDark,
        surface: ksurfaceColorDark,
      ),
      fontFamily: "Muli",
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: kbackgroundColorDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: kgeneralTextColor,
          fontSize: 16.sp,
        ),
      ),
      dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.transparent,
      ),
      indicatorColor: kPrimaryColor,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const MaterialStatePropertyAll(kgeneralTextColor),
          textStyle: MaterialStatePropertyAll(
            TextStyle(fontSize: 13.sp),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10).r),
          ),
          overlayColor: MaterialStatePropertyAll(kPrimaryColor.withOpacity(.1)),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

