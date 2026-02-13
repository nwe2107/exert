import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';
import '../../domain/repositories/exercise_template_repository.dart';
import '../models/exercise_template_model.dart';

class FirestoreExerciseTemplateRepository
    implements ExerciseTemplateRepository {
  FirestoreExerciseTemplateRepository(this._firestore, this._userId);

  final FirebaseFirestore _firestore;
  final String _userId;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_userId).collection('exercises');

  @override
  Stream<List<ExerciseTemplateModel>> watchAll() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(_fromDoc)
          .whereType<ExerciseTemplateModel>()
          .toList();
    });
  }

  @override
  Future<List<ExerciseTemplateModel>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(_fromDoc)
        .whereType<ExerciseTemplateModel>()
        .toList();
  }

  @override
  Future<ExerciseTemplateModel?> getById(Id id) async {
    final doc = await _collection.doc(id.toString()).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  @override
  Future<Id> save(ExerciseTemplateModel template) async {
    final now = DateTime.now();
    DateTime createdAt;
    try {
      createdAt = template.createdAt;
    } catch (_) {
      createdAt = now;
      template.createdAt = createdAt;
    }
    template.updatedAt = now;

    final newId = template.id == Isar.autoIncrement || template.id == 0
        ? _generateId()
        : template.id;

    final data = _toMap(template)
      ..addAll({
        'id': newId,
        'updatedAt': now.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      });

    await _collection.doc(newId.toString()).set(data, SetOptions(merge: true));
    return newId;
  }

  @override
  Future<void> softDelete(Id id) async {
    await _collection.doc(id.toString()).set({
      'deletedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> seedIfEmpty(List<ExerciseTemplateModel> templates) async {
    final existing = await _collection.limit(1).get();
    if (existing.size > 0) return;

    final batch = _firestore.batch();
    for (final template in templates) {
      final id = template.id == 0 || template.id == Isar.autoIncrement
          ? _generateId()
          : template.id;
      final data = _toMap(template)
        ..addAll({
          'id': id,
          'createdAt': template.createdAt.toIso8601String(),
          'updatedAt': template.updatedAt.toIso8601String(),
        });
      batch.set(_collection.doc(id.toString()), data);
    }
    await batch.commit();
  }

  ExerciseTemplateModel? _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return null;

    final model = ExerciseTemplateModel();
    model.id = _asInt(data['id']) ?? int.tryParse(doc.id) ?? 0;
    model.name = (data['name'] as String?)?.trim() ?? '';
    model.mediaType = _parseEnum<MediaType>(
      data['mediaType'],
      MediaType.values,
    );
    model.mediaUrl = data['mediaUrl'] as String?;
    final parsedMuscleGroups = _parseEnumList<MuscleGroup>(
      data['muscleGroups'],
      MuscleGroup.values,
    );
    final parsedSpecificMuscles = _parseEnumList<SpecificMuscle>(
      data['specificMuscles'],
      SpecificMuscle.values,
    );

    model.muscleGroup =
        _parseEnum<MuscleGroup>(data['muscleGroup'], MuscleGroup.values) ??
        (parsedMuscleGroups.isNotEmpty
            ? parsedMuscleGroups.first
            : MuscleGroup.fullBody);
    model.specificMuscle =
        _parseEnum<SpecificMuscle>(
          data['specificMuscle'],
          SpecificMuscle.values,
        ) ??
        (parsedSpecificMuscles.isNotEmpty
            ? parsedSpecificMuscles.first
            : SpecificMuscle.fullBody);
    model.specificMuscles = parsedSpecificMuscles.isNotEmpty
        ? parsedSpecificMuscles
        : <SpecificMuscle>[model.specificMuscle];
    model.muscleGroups = model.specificMuscles
        .map(_groupForSpecificMuscle)
        .toSet()
        .toList(growable: false);
    model.defaultDifficulty =
        _parseEnum<DifficultyLevel>(
          data['defaultDifficulty'],
          DifficultyLevel.values,
        ) ??
        DifficultyLevel.easy;
    model.equipment = _parseEnum<EquipmentType>(
      data['equipment'],
      EquipmentType.values,
    );
    model.notes = data['notes'] as String?;
    model.isCompound = data['isCompound'] == true;
    model.compoundExerciseTemplateIds = _parseIntList(
      data['compoundExerciseTemplateIds'],
    );
    model.progressionSettings = _parseProgression(data['progressionSettings']);
    model.createdAt = _parseDate(data['createdAt']);
    model.updatedAt = _parseDate(data['updatedAt']);
    model.deletedAt = data['deletedAt'] != null
        ? _parseDate(data['deletedAt'])
        : null;
    return model;
  }

  Map<String, Object?> _toMap(ExerciseTemplateModel model) {
    final resolvedMuscleGroups = model.resolveMuscleGroups();
    final resolvedSpecificMuscles = model.resolveSpecificMuscles();
    return {
      'name': model.name,
      'mediaType': model.mediaType?.name,
      'mediaUrl': model.mediaUrl,
      'muscleGroup': model.muscleGroup.name,
      'specificMuscle': model.specificMuscle.name,
      'muscleGroups': resolvedMuscleGroups
          .map((group) => group.name)
          .toList(growable: false),
      'specificMuscles': resolvedSpecificMuscles
          .map((muscle) => muscle.name)
          .toList(growable: false),
      'defaultDifficulty': model.defaultDifficulty.name,
      'equipment': model.equipment?.name,
      'notes': model.notes,
      'isCompound': model.isCompound,
      'compoundExerciseTemplateIds': model.compoundExerciseTemplateIds,
      'progressionSettings': model.progressionSettings == null
          ? null
          : {
              'minReps': model.progressionSettings?.minReps,
              'maxReps': model.progressionSettings?.maxReps,
              'progressionStep': model.progressionSettings?.progressionStep,
              'targetSets': model.progressionSettings?.targetSets,
            },
      'deletedAt': model.deletedAt?.toIso8601String(),
    };
  }

  ProgressionSettingsModel? _parseProgression(Object? value) {
    if (value is Map<String, dynamic>) {
      return ProgressionSettingsModel()
        ..minReps = (value['minReps'] as num?)?.toInt()
        ..maxReps = (value['maxReps'] as num?)?.toInt()
        ..progressionStep = (value['progressionStep'] as num?)?.toDouble()
        ..targetSets = (value['targetSets'] as num?)?.toInt();
    }
    return null;
  }

  T? _parseEnum<T>(Object? raw, List<T> values) {
    if (raw == null) return null;
    final rawStr = raw.toString().split('.').last;
    for (final value in values) {
      final valueName = value.toString().split('.').last;
      if (valueName == rawStr) {
        return value;
      }
    }
    return null;
  }

  int _generateId() {
    final now = DateTime.now().toUtc();
    return int.parse(DateFormat('yyyyMMddHHmmssSSS').format(now));
  }

  MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
    for (final entry in specificMusclesByGroup.entries) {
      if (entry.value.contains(muscle)) {
        return entry.key;
      }
    }
    return MuscleGroup.fullBody;
  }

  DateTime _parseDate(Object? raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is DateTime) {
      return raw;
    }
    if (raw is String) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  int? _asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  List<int> _parseIntList(Object? raw) {
    if (raw is! Iterable) {
      return const [];
    }
    final parsed = raw.map(_asInt).whereType<int>().toList(growable: false);
    return parsed;
  }

  List<T> _parseEnumList<T>(Object? raw, List<T> values) {
    if (raw is! Iterable) {
      return const [];
    }

    final seen = <T>{};
    final parsed = <T>[];
    for (final item in raw) {
      final value = _parseEnum<T>(item, values);
      if (value != null && seen.add(value)) {
        parsed.add(value);
      }
    }
    return parsed;
  }
}
