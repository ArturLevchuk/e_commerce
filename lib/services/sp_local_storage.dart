import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'abstracts/local_storage_service.dart';

class SPLocalStorageService implements LocalStorageService {
  @override
  Future<void> set(
      {required String key, required Map<String, dynamic> value}) async {
    try {
      await SharedPreferences.getInstance().then((prefs) {
        final userData = json.encode(value);
        prefs.setString(key, userData);
      });
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> get({required String key}) async {
    try {
      Map<String, dynamic> data = {};
      await SharedPreferences.getInstance().then((prefs) {
        if (!prefs.containsKey(key)) {
          return data;
        }
        data = json.decode(prefs.getString(key)!) as Map<String, dynamic>;
      });
      return data;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> remove({required String key}) async {
    try {
      await SharedPreferences.getInstance().then((prefs) {
        prefs.remove(key);
      });
    } catch (err) {
      rethrow;
    }
  }
}
