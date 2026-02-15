import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';
import '../../domain/repositories/workout_repository.dart';
import '../models/exercise_entry_model.dart';
import '../models/workout_session_model.dart';

class FirestoreWorkoutRepository implements WorkoutRepository {
  FirestoreWorkoutRepository(this._firestore, this._userId);

  final FirebaseFirestore _firestore;
  final String _userId;

  CollectionReference<Map<String, dynamic>> get _sessions =>
      _firestore.collection('users').doc(_userId).collection('sessions');

  CollectionReference<Map<String, dynamic>> _entriesForSession(Id sessionId) =>
      _sessions.doc(sessionId.toString()).collection('entries');

  @override
  Stream<List<WorkoutSessionModel>> watchSessions() {
    return _sessions.snapshots().map(
      (snapshot) => snapshot.docs
          .map(_sessionFromDoc)
          .whereType<WorkoutSessionModel>()
          .toList(),
    );
  }

  @override
  Stream<List<WorkoutSessionModel>> watchSessionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return _sessions
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(_sessionFromDoc)
              .whereType<WorkoutSessionModel>()
              .toList(),
        );
  }

  @override
  Future<List<WorkoutSessionModel>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _sessions
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toIso8601String())
        .get();
    return snapshot.docs
        .map(_sessionFromDoc)
        .whereType<WorkoutSessionModel>()
        .toList();
  }

  @override
  Future<WorkoutSessionModel?> getSessionByDate(DateTime date) async {
    final id = _sessionIdFromDate(date);
    final doc = await _sessions.doc(id.toString()).get();
    if (!doc.exists) return null;
    return _sessionFromDoc(doc);
  }

  @override
  Stream<WorkoutSessionModel?> watchSessionByDate(DateTime date) {
    final id = _sessionIdFromDate(date);
    return _sessions.doc(id.toString()).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _sessionFromDoc(doc);
    });
  }

  @override
  Future<Id> saveSession(WorkoutSessionModel session) async {
    final now = DateTime.now();
    DateTime createdAt;
    try {
      createdAt = session.createdAt;
    } catch (_) {
      createdAt = now;
      session.createdAt = createdAt;
    }
    session.updatedAt = now;

    final id = session.id == 0 || session.id == Isar.autoIncrement
        ? _sessionIdFromDate(session.date)
        : session.id;

    final data = {
      'id': id,
      'date': session.date.toIso8601String(),
      'status': session.status.name,
      'durationMinutes': session.durationMinutes,
      'notes': session.notes,
      'updatedAt': now.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'deletedAt': session.deletedAt?.toIso8601String(),
    };

    await _sessions.doc(id.toString()).set(data, SetOptions(merge: true));
    return id;
  }

  @override
  Future<void> deleteSession(Id sessionId) async {
    await deleteEntriesForSession(sessionId);
    await _sessions.doc(sessionId.toString()).delete();
  }

  @override
  Stream<List<ExerciseEntryModel>> watchEntriesForSession(Id sessionId) {
    return _entriesForSession(sessionId).snapshots().map((snapshot) {
      return snapshot.docs
          .map(_entryFromDoc)
          .whereType<ExerciseEntryModel>()
          .toList();
    });
  }

  @override
  Future<List<ExerciseEntryModel>> getEntriesForSession(Id sessionId) async {
    final snapshot = await _entriesForSession(sessionId).get();
    return snapshot.docs
        .map(_entryFromDoc)
        .whereType<ExerciseEntryModel>()
        .toList();
  }

  @override
  Stream<List<ExerciseEntryModel>> watchAllEntries() {
    return _sessions.snapshots().asyncExpand((sessionSnap) async* {
      final entries = <ExerciseEntryModel>[];
      for (final sessionDoc in sessionSnap.docs) {
        final subSnap = await _entriesForSession(
          (sessionDoc.data()['id'] as num).toInt(),
        ).get();
        entries.addAll(
          subSnap.docs.map(_entryFromDoc).whereType<ExerciseEntryModel>(),
        );
      }
      yield entries;
    });
  }

  @override
  Future<List<ExerciseEntryModel>> getAllEntries() async {
    final sessionSnap = await _sessions.get();
    final entries = <ExerciseEntryModel>[];
    for (final sessionDoc in sessionSnap.docs) {
      final subSnap = await _entriesForSession(
        (sessionDoc.data()['id'] as num).toInt(),
      ).get();
      entries.addAll(
        subSnap.docs.map(_entryFromDoc).whereType<ExerciseEntryModel>(),
      );
    }
    return entries;
  }

  @override
  Future<Id> saveEntry(ExerciseEntryModel entry) async {
    final now = DateTime.now();
    DateTime createdAt;
    try {
      createdAt = entry.createdAt;
    } catch (_) {
      createdAt = now;
      entry.createdAt = createdAt;
    }
    entry.updatedAt = now;

    final id = entry.id == 0 || entry.id == Isar.autoIncrement
        ? _generateId()
        : entry.id;

    final data = _entryToMap(entry)
      ..addAll({
        'id': id,
        'updatedAt': now.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      });

    await _entriesForSession(
      entry.workoutSessionId,
    ).doc(id.toString()).set(data, SetOptions(merge: true));
    return id;
  }

  @override
  Future<void> deleteEntry(Id entryId, {Id? sessionId}) async {
    if (sessionId != null) {
      await _entriesForSession(sessionId).doc(entryId.toString()).delete();
      return;
    }

    // Backward-compatible fallback when the caller has only entryId.
    final sessionSnapshot = await _sessions.get();
    for (final sessionDoc in sessionSnapshot.docs) {
      final candidate = _entriesForSession(
        (sessionDoc.data()['id'] as num).toInt(),
      ).doc(entryId.toString());
      final exists = await candidate.get();
      if (exists.exists) {
        await candidate.delete();
        return;
      }
    }
  }

  @override
  Future<void> deleteEntriesForSession(Id sessionId) async {
    final snapshot = await _entriesForSession(sessionId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> clearAllUserData() async {
    final sessionSnap = await _sessions.get();
    for (final sessionDoc in sessionSnap.docs) {
      final entriesSnap = await _entriesForSession(
        (sessionDoc.data()['id'] as num).toInt(),
      ).get();
      for (final entry in entriesSnap.docs) {
        await entry.reference.delete();
      }
      await sessionDoc.reference.delete();
    }
  }

  WorkoutSessionModel? _sessionFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) return null;
    try {
      final session = WorkoutSessionModel()
        ..id = (data['id'] as num?)?.toInt() ?? int.parse(doc.id)
        ..date = DateTime.parse(data['date'] as String)
        ..status =
            _parseEnum<SessionStatus>(data['status'], SessionStatus.values) ??
            SessionStatus.rest
        ..durationMinutes = (data['durationMinutes'] as num?)?.toInt()
        ..notes = data['notes'] as String?
        ..createdAt = DateTime.parse(
          data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        )
        ..updatedAt = DateTime.parse(
          data['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
        )
        ..deletedAt = data['deletedAt'] != null
            ? DateTime.parse(data['deletedAt'] as String)
            : null;
      return session;
    } catch (_) {
      return null;
    }
  }

  ExerciseEntryModel? _entryFromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) return null;
    try {
      final parsedMuscleGroups = _parseEnumList<MuscleGroup>(
        data['muscleGroups'],
        MuscleGroup.values,
      );
      final parsedSpecificMuscles = _parseEnumList<SpecificMuscle>(
        data['specificMuscles'],
        SpecificMuscle.values,
      );
      final primarySpecific =
          _parseEnum<SpecificMuscle>(
            data['specificMuscle'],
            SpecificMuscle.values,
          ) ??
          (parsedSpecificMuscles.isNotEmpty
              ? parsedSpecificMuscles.first
              : SpecificMuscle.fullBody);
      final resolvedSpecificMuscles = parsedSpecificMuscles.isNotEmpty
          ? parsedSpecificMuscles
          : <SpecificMuscle>[primarySpecific];
      final primaryGroup =
          _parseEnum<MuscleGroup>(data['muscleGroup'], MuscleGroup.values) ??
          (parsedMuscleGroups.isNotEmpty
              ? parsedMuscleGroups.first
              : _groupForSpecificMuscle(primarySpecific));
      final resolvedMuscleGroups = parsedMuscleGroups.isNotEmpty
          ? parsedMuscleGroups
          : resolvedSpecificMuscles
                .map(_groupForSpecificMuscle)
                .toSet()
                .toList(growable: false);
      final entry = ExerciseEntryModel()
        ..id = (data['id'] as num?)?.toInt() ?? int.parse(doc.id)
        ..workoutSessionId = (data['workoutSessionId'] as num).toInt()
        ..exerciseTemplateId = (data['exerciseTemplateId'] as num).toInt()
        ..schemeType =
            _parseEnum<SchemeType>(data['schemeType'], SchemeType.values) ??
            SchemeType.standard
        ..supersetGroupId = data['supersetGroupId'] as String?
        ..feltDifficulty =
            _parseEnum<DifficultyLevel>(
              data['feltDifficulty'],
              DifficultyLevel.values,
            ) ??
            DifficultyLevel.easy
        ..restSeconds = (data['restSeconds'] as num?)?.toInt()
        ..notes = data['notes'] as String?
        ..sets = _parseSets(data['sets'])
        ..muscleGroup = primaryGroup
        ..specificMuscle = primarySpecific
        ..muscleGroups = resolvedMuscleGroups
        ..specificMuscles = resolvedSpecificMuscles
        ..createdAt = DateTime.parse(
          data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        )
        ..updatedAt = DateTime.parse(
          data['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
        )
        ..deletedAt = data['deletedAt'] != null
            ? DateTime.parse(data['deletedAt'] as String)
            : null;
      return entry;
    } catch (_) {
      return null;
    }
  }

  Map<String, Object?> _entryToMap(ExerciseEntryModel entry) {
    final resolvedMuscleGroups = entry.resolveMuscleGroups();
    final resolvedSpecificMuscles = entry.resolveSpecificMuscles();
    return {
      'workoutSessionId': entry.workoutSessionId,
      'exerciseTemplateId': entry.exerciseTemplateId,
      'schemeType': entry.schemeType.name,
      'supersetGroupId': entry.supersetGroupId,
      'feltDifficulty': entry.feltDifficulty.name,
      'restSeconds': entry.restSeconds,
      'notes': entry.notes,
      'sets': entry.sets
          .map(
            (set) => {
              'setNumber': set.setNumber,
              'reps': set.reps,
              'weight': set.weight,
              'durationSeconds': set.durationSeconds,
              'rpe': set.rpe,
            },
          )
          .toList(),
      'muscleGroup': entry.muscleGroup.name,
      'specificMuscle': entry.specificMuscle.name,
      'muscleGroups': resolvedMuscleGroups
          .map((group) => group.name)
          .toList(growable: false),
      'specificMuscles': resolvedSpecificMuscles
          .map((muscle) => muscle.name)
          .toList(growable: false),
      'deletedAt': entry.deletedAt?.toIso8601String(),
    };
  }

  List<SetItemModel> _parseSets(Object? raw) {
    if (raw is Iterable) {
      return raw.map((item) {
        if (item is Map<String, dynamic>) {
          return SetItemModel()
            ..setNumber = (item['setNumber'] as num?)?.toInt() ?? 1
            ..reps = (item['reps'] as num?)?.toInt()
            ..weight = (item['weight'] as num?)?.toDouble()
            ..durationSeconds = (item['durationSeconds'] as num?)?.toInt()
            ..rpe = (item['rpe'] as num?)?.toDouble();
        }
        return SetItemModel();
      }).toList();
    }
    return [];
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

  MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
    for (final entry in specificMusclesByGroup.entries) {
      if (entry.value.contains(muscle)) {
        return entry.key;
      }
    }
    return MuscleGroup.fullBody;
  }

  int _sessionIdFromDate(DateTime date) {
    return int.parse(DateFormat('yyyyMMdd').format(date));
  }

  int _generateId() {
    final now = DateTime.now().toUtc();
    return int.parse(DateFormat('yyyyMMddHHmmssSSS').format(now));
  }
}
