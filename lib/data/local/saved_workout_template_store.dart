import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/enums/app_enums.dart';

class SavedWorkoutSetTemplate {
  const SavedWorkoutSetTemplate({
    this.reps,
    this.weight,
    this.durationSeconds,
    this.rpe,
  });

  final int? reps;
  final double? weight;
  final int? durationSeconds;
  final double? rpe;

  factory SavedWorkoutSetTemplate.fromJson(Map<String, dynamic> json) {
    return SavedWorkoutSetTemplate(
      reps: (json['reps'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      rpe: (json['rpe'] as num?)?.toDouble(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'durationSeconds': durationSeconds,
      'rpe': rpe,
    };
  }
}

class SavedWorkoutEntryTemplate {
  const SavedWorkoutEntryTemplate({
    required this.exerciseTemplateId,
    required this.schemeType,
    required this.feltDifficulty,
    required this.sets,
    this.supersetGroupId,
    this.restSeconds,
    this.notes,
  });

  final int exerciseTemplateId;
  final SchemeType schemeType;
  final DifficultyLevel feltDifficulty;
  final String? supersetGroupId;
  final int? restSeconds;
  final String? notes;
  final List<SavedWorkoutSetTemplate> sets;

  factory SavedWorkoutEntryTemplate.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'];
    final sets = <SavedWorkoutSetTemplate>[];
    if (rawSets is Iterable) {
      for (final item in rawSets) {
        if (item is Map<String, dynamic>) {
          sets.add(SavedWorkoutSetTemplate.fromJson(item));
        } else if (item is Map) {
          sets.add(
            SavedWorkoutSetTemplate.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return SavedWorkoutEntryTemplate(
      exerciseTemplateId: (json['exerciseTemplateId'] as num?)?.toInt() ?? 0,
      schemeType: _parseEnum<SchemeType>(
        json['schemeType'],
        SchemeType.values,
        SchemeType.standard,
      ),
      feltDifficulty: _parseEnum<DifficultyLevel>(
        json['feltDifficulty'],
        DifficultyLevel.values,
        DifficultyLevel.moderate,
      ),
      supersetGroupId: json['supersetGroupId'] as String?,
      restSeconds: (json['restSeconds'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      sets: sets,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'exerciseTemplateId': exerciseTemplateId,
      'schemeType': schemeType.name,
      'feltDifficulty': feltDifficulty.name,
      'supersetGroupId': supersetGroupId,
      'restSeconds': restSeconds,
      'notes': notes,
      'sets': sets.map((item) => item.toJson()).toList(growable: false),
    };
  }
}

class SavedWorkoutTemplate {
  const SavedWorkoutTemplate({
    required this.id,
    required this.name,
    required this.status,
    required this.entries,
    required this.createdAt,
    required this.updatedAt,
    this.durationMinutes,
    this.notes,
  });

  final String id;
  final String name;
  final SessionStatus status;
  final int? durationMinutes;
  final String? notes;
  final List<SavedWorkoutEntryTemplate> entries;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory SavedWorkoutTemplate.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final rawEntries = json['entries'];
    final entries = <SavedWorkoutEntryTemplate>[];
    if (rawEntries is Iterable) {
      for (final item in rawEntries) {
        if (item is Map<String, dynamic>) {
          entries.add(SavedWorkoutEntryTemplate.fromJson(item));
        } else if (item is Map) {
          entries.add(
            SavedWorkoutEntryTemplate.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return SavedWorkoutTemplate(
      id: json['id'] as String? ?? generateSavedWorkoutTemplateId(),
      name: json['name'] as String? ?? 'Saved workout',
      status: _parseEnum<SessionStatus>(
        json['status'],
        SessionStatus.values,
        SessionStatus.success,
      ),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      entries: entries,
      createdAt: _parseDate(json['createdAt'], now),
      updatedAt: _parseDate(json['updatedAt'], now),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
      'durationMinutes': durationMinutes,
      'notes': notes,
      'entries': entries.map((item) => item.toJson()).toList(growable: false),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SavedWorkoutTemplate copyWith({
    String? id,
    String? name,
    SessionStatus? status,
    int? durationMinutes,
    String? notes,
    List<SavedWorkoutEntryTemplate>? entries,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedWorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      entries: entries ?? this.entries,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

abstract class SavedWorkoutTemplateStore {
  Future<List<SavedWorkoutTemplate>> loadTemplates();

  Future<void> saveTemplate(SavedWorkoutTemplate template);

  Future<void> deleteTemplate(String templateId);
}

class FileSavedWorkoutTemplateStore implements SavedWorkoutTemplateStore {
  FileSavedWorkoutTemplateStore({
    Future<Directory> Function()? baseDirectoryResolver,
  }) : _baseDirectoryResolver = baseDirectoryResolver ?? _resolveBaseDirectory;

  static const String _storageFileName = 'saved_workouts.json';
  static const String _templatesKey = 'saved_workouts';

  final Future<Directory> Function() _baseDirectoryResolver;

  @override
  Future<List<SavedWorkoutTemplate>> loadTemplates() async {
    final file = await _resolveStorageFile();
    if (!await file.exists()) {
      return const [];
    }

    try {
      final raw = jsonDecode(await file.readAsString());
      if (raw is! Map<String, dynamic>) {
        return const [];
      }

      final rawTemplates = raw[_templatesKey];
      if (rawTemplates is! Iterable) {
        return const [];
      }

      final templates = <SavedWorkoutTemplate>[];
      for (final item in rawTemplates) {
        if (item is Map<String, dynamic>) {
          templates.add(SavedWorkoutTemplate.fromJson(item));
        } else if (item is Map) {
          templates.add(
            SavedWorkoutTemplate.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }

      templates.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return templates;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveTemplate(SavedWorkoutTemplate template) async {
    final templates = await loadTemplates();
    final next = templates.where((item) => item.id != template.id).toList();
    next.add(template);
    next.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _writeTemplates(next);
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    final templates = await loadTemplates();
    final next = templates
        .where((item) => item.id != templateId)
        .toList(growable: false);
    if (next.length == templates.length) {
      return;
    }
    await _writeTemplates(next);
  }

  Future<void> _writeTemplates(List<SavedWorkoutTemplate> templates) async {
    final file = await _resolveStorageFile();
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final jsonPayload = {
      _templatesKey: templates
          .map((template) => template.toJson())
          .toList(growable: false),
    };
    await file.writeAsString(jsonEncode(jsonPayload), flush: true);
  }

  Future<File> _resolveStorageFile() async {
    final baseDirectory = await _baseDirectoryResolver();
    return File(
      '${baseDirectory.path}${Platform.pathSeparator}$_storageFileName',
    );
  }

  static Future<Directory> _resolveBaseDirectory() async {
    try {
      return await getApplicationSupportDirectory();
    } on MissingPluginException {
      return Directory.systemTemp;
    } catch (_) {
      return Directory.systemTemp;
    }
  }
}

String generateSavedWorkoutTemplateId() {
  final now = DateTime.now().toUtc();
  return 'saved-${now.microsecondsSinceEpoch}';
}

T _parseEnum<T extends Enum>(Object? raw, List<T> values, T fallback) {
  final rawName = raw?.toString();
  if (rawName == null) {
    return fallback;
  }

  for (final value in values) {
    if (value.name == rawName) {
      return value;
    }
  }
  return fallback;
}

DateTime _parseDate(Object? raw, DateTime fallback) {
  if (raw is String) {
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return parsed;
    }
  }
  return fallback;
}
