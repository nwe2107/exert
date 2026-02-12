import 'package:flutter/material.dart';

enum ThemePreference { light, dark, timeOfDay }

extension ThemePreferenceLabel on ThemePreference {
  String get label {
    switch (this) {
      case ThemePreference.light:
        return 'Light';
      case ThemePreference.dark:
        return 'Dark';
      case ThemePreference.timeOfDay:
        return 'Time of day';
    }
  }
}

ThemeMode resolveThemeModeForPreference(
  ThemePreference preference,
  DateTime now,
) {
  switch (preference) {
    case ThemePreference.light:
      return ThemeMode.light;
    case ThemePreference.dark:
      return ThemeMode.dark;
    case ThemePreference.timeOfDay:
      final hour = now.hour;
      final isDaytime = hour >= 6 && hour < 18;
      return isDaytime ? ThemeMode.light : ThemeMode.dark;
  }
}
