import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color kPrimaryColor = Color(0xFFFF7643);
const Color kgeneralTextColor = Color(0xFFA7A6A6);

const Color kbackgroundColorDark = Color(0xFF252525);
const Color ksurfaceColorDark = Color(0xFF3B3B3B);

const Color ksurfaceColorLight = Color(0xFFF2F2F2);

const kSecondaryColor = Color(0xFF979797);

const Color kBorderColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 250);

InputDecoration get roundInputDecoration {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28).r,
    borderSide: const BorderSide(color: kBorderColor),
    gapPadding: 10,
  );
  return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 30, vertical: 20).r,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder);
}

BoxShadow themedBoxShadow(Brightness brightness) {
  if (brightness == Brightness.light) {
    return const BoxShadow(
      color: Color(0x87000000),
      blurRadius: 3,
      spreadRadius: 0,
    );
  } else {
    return BoxShadow(
      color: Colors.white.withOpacity(0.7),
      blurRadius: 3,
      spreadRadius: 0,
    );
  }
}

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,13}$');
const String kEmailEmptyError = "Please enter your email";
const String kInvalidEmailError = "Please enter valid email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kInvalidPhoneNumberError = "Please enter valid phone number";
const String kAddressNullError = "Please enter your address";

const cartNotificationKey = "cart_notifications";
const generalNotificationKey = "general_notifications";

const String userDataKey = "userData";
const String appSettingsKey = "appSettings";
