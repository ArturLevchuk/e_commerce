import '/constants.dart';
import '/services/abstracts/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

part '../model/app_settings.dart';

class AppSettingsController extends Disposable {
  final LocalStorageService _localStorageService;
  AppSettingsController(this._localStorageService);

  final BehaviorSubject<AppSettings> _streamController = BehaviorSubject.seeded(
    const AppSettings(),
  );

  Stream<AppSettings> get stream => _streamController.stream;
  AppSettings get state => _streamController.value;

  Future<void> init() async {
    try {
      final mapOfSettings = await _localStorageService.get(key: appSettingsKey);
      if (mapOfSettings.isNotEmpty) {
        _streamController.add(AppSettings.fromMap(mapOfSettings));
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    try {
      _streamController.add(state.copyWith(
        themeMode: themeMode,
      ));
      _localStorageService.set(key: appSettingsKey, value: state.toMap());
    } catch (err) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
