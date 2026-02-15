import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/enums/app_enums.dart';
import '../local/saved_workout_template_store.dart';

class FirestoreSavedWorkoutTemplateStore implements SavedWorkoutTemplateStore {
  FirestoreSavedWorkoutTemplateStore(this._firestore, this._userId);

  final FirebaseFirestore _firestore;
  final String _userId;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_userId).collection('saved_workouts');

  @override
  Future<List<SavedWorkoutTemplate>> loadTemplates() async {
    final snapshot = await _collection
        .orderBy('updatedAt', descending: true)
        .get();
    final templates = snapshot.docs
        .map(_fromDoc)
        .whereType<SavedWorkoutTemplate>()
        .toList(growable: false);
    templates.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return templates;
  }

  @override
  Future<void> saveTemplate(SavedWorkoutTemplate template) async {
    final now = DateTime.now();
    final id = template.id.trim().isEmpty
        ? generateSavedWorkoutTemplateId()
        : template.id.trim();

    final normalized = SavedWorkoutTemplate(
      id: id,
      name: template.name,
      status: template.status,
      durationMinutes: template.durationMinutes,
      notes: template.notes,
      entries: template.entries,
      createdAt: template.createdAt,
      updatedAt: template.updatedAt.isBefore(template.createdAt)
          ? now
          : template.updatedAt,
    );

    await _collection.doc(id).set(_toMap(normalized), SetOptions(merge: true));
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    final id = templateId.trim();
    if (id.isEmpty) {
      return;
    }
    await _collection.doc(id).delete();
  }

  SavedWorkoutTemplate? _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }

    final rawEntries = data['entries'];
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

    final fallbackNow = DateTime.now();
    return SavedWorkoutTemplate(
      id: (data['id'] as String?)?.trim().isNotEmpty == true
          ? (data['id'] as String).trim()
          : doc.id,
      name: ((data['name'] as String?) ?? 'Saved workout').trim(),
      status: _parseEnum<SessionStatus>(
        data['status'],
        SessionStatus.values,
        SessionStatus.success,
      ),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
      notes: data['notes'] as String?,
      entries: entries,
      createdAt: _parseDate(data['createdAt'], fallbackNow),
      updatedAt: _parseDate(data['updatedAt'], fallbackNow),
    );
  }

  Map<String, Object?> _toMap(SavedWorkoutTemplate template) {
    return {
      'id': template.id,
      'name': template.name,
      'status': template.status.name,
      'durationMinutes': template.durationMinutes,
      'notes': template.notes,
      'entries': template.entries.map(_entryToMap).toList(growable: false),
      'createdAt': Timestamp.fromDate(template.createdAt.toUtc()),
      'updatedAt': Timestamp.fromDate(template.updatedAt.toUtc()),
    };
  }

  Map<String, Object?> _entryToMap(SavedWorkoutEntryTemplate entry) {
    return {
      'exerciseTemplateId': entry.exerciseTemplateId,
      'schemeType': entry.schemeType.name,
      'feltDifficulty': entry.feltDifficulty.name,
      'supersetGroupId': entry.supersetGroupId,
      'restSeconds': entry.restSeconds,
      'notes': entry.notes,
      'sets': entry.sets.map(_setToMap).toList(growable: false),
    };
  }

  Map<String, Object?> _setToMap(SavedWorkoutSetTemplate set) {
    return {
      'reps': set.reps,
      'weight': set.weight,
      'durationSeconds': set.durationSeconds,
      'rpe': set.rpe,
    };
  }

  T _parseEnum<T extends Enum>(Object? raw, List<T> values, T fallback) {
    final rawValue = raw?.toString();
    if (rawValue == null) {
      return fallback;
    }
    for (final value in values) {
      if (value.name == rawValue) {
        return value;
      }
    }
    return fallback;
  }

  DateTime _parseDate(Object? raw, DateTime fallback) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is DateTime) {
      return raw;
    }
    if (raw is String) {
      return DateTime.tryParse(raw) ?? fallback;
    }
    return fallback;
  }
}
