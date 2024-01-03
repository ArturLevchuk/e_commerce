import 'dart:developer';

import '/services/abstracts/notification_service.dart';

import '/apis/abstract/auth_api.dart';
import '/services/abstracts/local_storage_service.dart';
import '/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../constants.dart';

part '../model/auth_info.dart';

class AuthController extends Disposable {
  final AuthApi _authApi;
  final LocalStorageService _localStorageService;
  final NotificationService _notificationService;
  TimerService? _timerService;
  AuthController(
      this._authApi, this._localStorageService, this._notificationService);

  final BehaviorSubject<AuthInfo> _streamController =
      BehaviorSubject.seeded(const AuthInfo());

  Stream<AuthInfo> get stream => _streamController.stream;
  AuthInfo get state => _streamController.value;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final authInfo = await _authApi.login(email: email, password: password);
      if (rememberMe) {
        await _localStorageService.set(key: userDataKey, value: {
          'token': authInfo.token,
          'userId': authInfo.userId,
          'expiryDate': authInfo.expiryDate.toIso8601String(),
        });
      }
      _timerService?.stopTimer();
      _timerService = TimerService(
        onTimer: () async {
          await logout();
        },
      );
      _timerService?.startTimer(
        duration: Duration(
          seconds: (authInfo.expiryDate.difference(DateTime.now())).inSeconds,
        ),
      );
      _streamController.add(
        state.copyWith(
          token: authInfo.token,
          id: authInfo.userId,
          authStatus: AuthStatus.authenticated,
        ),
      );
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> register(Map<String, String> args) async {
    try {
      final authInfo = await _authApi.signUp(args);
      await _localStorageService.set(key: userDataKey, value: {
        'token': authInfo.token,
        'userId': authInfo.userId,
        'expiryDate': authInfo.expiryDate.toIso8601String(),
      });
      _timerService?.stopTimer();
      _timerService = TimerService(
        onTimer: () async {
          await logout();
        },
      );
      _timerService?.startTimer(
        duration: Duration(
            seconds:
                (authInfo.expiryDate.difference(DateTime.now())).inSeconds),
      );
      _streamController.add(
        state.copyWith(
          token: authInfo.token,
          id: authInfo.userId,
          authStatus: AuthStatus.authenticated,
        ),
      );
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _timerService?.stopTimer();
      _timerService = null;
      _localStorageService.remove(key: userDataKey);
      _streamController
          .add(state.copyWith(authStatus: AuthStatus.unauthenticated));
      await _notificationService.cancelAllNotifications();
      Modular.to.navigate('/authorization/');
      _notificationService.createNotification(
        title: "Session is over",
        body: "Login to continue shopping",
        timeOut: const Duration(seconds: 6),
      );
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> tryAutoLogin() async {
    try {
      final prefs = await _localStorageService.get(key: userDataKey);
      if (prefs.isEmpty) {
        _streamController
            .add(state.copyWith(authStatus: AuthStatus.unauthenticated));
        return;
      }
      final DateTime expiryDate = DateTime.parse(prefs['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) {
        _streamController
            .add(state.copyWith(authStatus: AuthStatus.unauthenticated));
        return;
      }
      _timerService?.stopTimer();
      _timerService = TimerService(
        onTimer: () async {
          await logout();
        },
      );
      _timerService?.startTimer(
          duration: Duration(
        seconds: (expiryDate.difference(DateTime.now())).inSeconds,
      ));
      final String token = prefs['token'];
      final String userId = prefs['userId'];
      _streamController.add(state.copyWith(
        token: token,
        id: userId,
        authStatus: AuthStatus.authenticated,
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
