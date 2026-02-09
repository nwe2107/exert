import 'package:isar/isar.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/repositories/workout_repository.dart';
import '../models/exercise_entry_model.dart';
import '../models/workout_session_model.dart';

class IsarWorkoutRepository implements WorkoutRepository {
  IsarWorkoutRepository(this._isar);

  final Isar _isar;

  @override
  Stream<List<WorkoutSessionModel>> watchSessions() {
    return _isar.workoutSessions
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => _getAllSessions());
  }

  @override
  Stream<List<WorkoutSessionModel>> watchSessionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return _isar.workoutSessions
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getSessionsInRange(start, end));
  }

  @override
  Future<List<WorkoutSessionModel>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final from = normalizeLocalDate(start);
    final to = normalizeLocalDate(end);

    final all = await _getAllSessions();
    return all
        .where((session) {
          final date = normalizeLocalDate(session.date);
          return !date.isBefore(from) && !date.isAfter(to);
        })
        .toList();
  }

  @override
  Future<WorkoutSessionModel?> getSessionByDate(DateTime date) async {
    final day = normalizeLocalDate(date);
    final all = await _getAllSessions();

    for (final session in all) {
      if (normalizeLocalDate(session.date) == day) {
        return session;
      }
    }
    return null;
  }

  @override
  Stream<WorkoutSessionModel?> watchSessionByDate(DateTime date) {
    return _isar.workoutSessions
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getSessionByDate(date));
  }

  @override
  Future<Id> saveSession(WorkoutSessionModel session) async {
    final now = DateTime.now();
    session.date = normalizeLocalDate(session.date);

    final existingById = session.id == Isar.autoIncrement
        ? null
        : await _isar.workoutSessions.get(session.id);

    final existingByDate = await getSessionByDate(session.date);
    final existing = existingById ?? existingByDate;

    if (existing != null) {
      session.id = existing.id;
      session.createdAt = existing.createdAt;
    } else {
      session.createdAt = now;
    }

    session.updatedAt = now;

    late Id id;
    await _isar.writeTxn(() async {
      id = await _isar.workoutSessions.put(session);
    });
    return id;
  }

  @override
  Future<void> deleteSession(Id sessionId) async {
    final session = await _isar.workoutSessions.get(sessionId);
    if (session == null || session.deletedAt != null) {
      return;
    }

    final now = DateTime.now();
    session.deletedAt = now;
    session.updatedAt = now;

    await _isar.writeTxn(() async {
      await _isar.workoutSessions.put(session);
    });

    final entries = await getEntriesForSession(sessionId);
    if (entries.isEmpty) {
      return;
    }

    await _isar.writeTxn(() async {
      for (final entry in entries) {
        entry.deletedAt = now;
        entry.updatedAt = now;
      }
      await _isar.exerciseEntries.putAll(entries);
    });
  }

  @override
  Stream<List<ExerciseEntryModel>> watchEntriesForSession(Id sessionId) {
    return _isar.exerciseEntries
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getEntriesForSession(sessionId));
  }

  @override
  Stream<List<ExerciseEntryModel>> watchAllEntries() {
    return _isar.exerciseEntries
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getAllEntries());
  }

  @override
  Future<List<ExerciseEntryModel>> getEntriesForSession(Id sessionId) async {
    final all = await getAllEntries();
    final entries = all
        .where(
          (entry) => entry.workoutSessionId == sessionId,
        )
        .toList();

    entries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return entries;
  }

  @override
  Future<List<ExerciseEntryModel>> getAllEntries() async {
    final all = await _isar.exerciseEntries.where().findAll();
    final entries = all.where((entry) => entry.deletedAt == null).toList();
    entries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return entries;
  }

  @override
  Future<Id> saveEntry(ExerciseEntryModel entry) async {
    final now = DateTime.now();
    final existing = entry.id == Isar.autoIncrement
        ? null
        : await _isar.exerciseEntries.get(entry.id);

    entry.createdAt = existing?.createdAt ?? now;
    entry.updatedAt = now;

    late Id id;
    await _isar.writeTxn(() async {
      id = await _isar.exerciseEntries.put(entry);
    });
    return id;
  }

  @override
  Future<void> deleteEntry(Id entryId) async {
    final entry = await _isar.exerciseEntries.get(entryId);
    if (entry == null || entry.deletedAt != null) {
      return;
    }

    entry.deletedAt = DateTime.now();
    entry.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.exerciseEntries.put(entry);
    });
  }

  @override
  Future<void> deleteEntriesForSession(Id sessionId) async {
    final entries = await getEntriesForSession(sessionId);
    if (entries.isEmpty) {
      return;
    }

    final now = DateTime.now();
    await _isar.writeTxn(() async {
      for (final entry in entries) {
        entry.deletedAt = now;
        entry.updatedAt = now;
      }
      await _isar.exerciseEntries.putAll(entries);
    });
  }

  Future<List<WorkoutSessionModel>> _getAllSessions() async {
    final all = await _isar.workoutSessions.where().findAll();
    final active = all.where((session) => session.deletedAt == null).toList();
    active.sort((a, b) => a.date.compareTo(b.date));
    return active;
  }
}
