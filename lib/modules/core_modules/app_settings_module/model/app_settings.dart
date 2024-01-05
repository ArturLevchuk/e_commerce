part of '../vm/app_settings_controller.dart';

@immutable
class AppSettings {
  final ThemeMode themeMode;

  const AppSettings({this.themeMode = ThemeMode.system});

  AppSettings copyWith({ThemeMode? themeMode}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    ThemeMode strToThemeMode(String name) {
      switch (name) {
        case 'system':
          return ThemeMode.system;
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    }

    return AppSettings(
      themeMode: strToThemeMode(map['themeMode']),
    );
  }
}
