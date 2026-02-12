import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../application/theme_preference.dart';

abstract class ThemePreferenceStore {
  Future<ThemePreference> loadPreference();

  Future<void> savePreference(ThemePreference preference);
}

class FileThemePreferenceStore implements ThemePreferenceStore {
  static const String _settingsFileName = 'app_settings.json';
  static const String _themePreferenceKey = 'theme_preference';

  @override
  Future<ThemePreference> loadPreference() async {
    final file = await _resolveSettingsFile();
    if (!await file.exists()) {
      return ThemePreference.timeOfDay;
    }

    try {
      final data = jsonDecode(await file.readAsString());
      if (data is! Map<String, dynamic>) {
        return ThemePreference.timeOfDay;
      }

      final rawPreference = data[_themePreferenceKey];
      if (rawPreference is! String) {
        return ThemePreference.timeOfDay;
      }

      return ThemePreference.values.firstWhere(
        (value) => value.name == rawPreference,
        orElse: () => ThemePreference.timeOfDay,
      );
    } catch (_) {
      return ThemePreference.timeOfDay;
    }
  }

  @override
  Future<void> savePreference(ThemePreference preference) async {
    final file = await _resolveSettingsFile();
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    await file.writeAsString(
      jsonEncode(<String, String>{_themePreferenceKey: preference.name}),
      flush: true,
    );
  }

  Future<File> _resolveSettingsFile() async {
    final baseDirectory = await _resolveBaseDirectory();
    return File(
      '${baseDirectory.path}${Platform.pathSeparator}$_settingsFileName',
    );
  }

  Future<Directory> _resolveBaseDirectory() async {
    try {
      return await getApplicationSupportDirectory();
    } on MissingPluginException {
      return Directory.systemTemp;
    } catch (_) {
      return Directory.systemTemp;
    }
  }
}
