import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> notifictionAuthCheck() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('userData')) {
    return false;
  } else {
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    } else {
      return true;
    }
  }
}
