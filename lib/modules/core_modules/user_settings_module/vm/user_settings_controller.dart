import 'dart:developer';

import '/apis/abstract/user_settings_api.dart';
import '../../../../apis/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

part '../model/user_info.dart';

class UserSettingsController extends Disposable {
  final UserSettingsApi _userSettingsApi;
  UserSettingsController(this._userSettingsApi);

  final BehaviorSubject<UserInfo> _streamController =
      BehaviorSubject.seeded(const UserInfo());

  Stream<UserInfo> get stream => _streamController.stream;
  UserInfo get state => _streamController.value;

  Future<void> init({
    required String userId,
    required String token,
  }) async {
    try {
      final userInformation = await _userSettingsApi.getUserInformation(
          token: token, userId: userId);
      _streamController.add(state.copyWith(
        userInfoStatus: UserInfoStatus.loaded,
        userInformation: userInformation,
      ));
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> updateUserInformation({
    required UserInformation userInformation,
    required String token,
    required String userId,
  }) async {
    try {
      await _userSettingsApi.updateUserInformation(
        userInformation: userInformation,
        token: token,
        userId: userId,
      );
      _streamController.add(state.copyWith(
        userInformation: userInformation,
      ));
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
