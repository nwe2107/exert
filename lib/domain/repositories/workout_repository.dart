import 'package:isar/isar.dart';

import '../../data/models/exercise_entry_model.dart';
import '../../data/models/workout_session_model.dart';

abstract class WorkoutRepository {
  Stream<List<WorkoutSessionModel>> watchSessions();

  Stream<List<WorkoutSessionModel>> watchSessionsInRange(
    DateTime start,
    DateTime end,
  );

  Future<List<WorkoutSessionModel>> getSessionsInRange(
    DateTime start,
    DateTime end,
  );

  Future<WorkoutSessionModel?> getSessionByDate(DateTime date);

  Stream<WorkoutSessionModel?> watchSessionByDate(DateTime date);

  Future<Id> saveSession(WorkoutSessionModel session);

  Future<void> deleteSession(Id sessionId);

  Stream<List<ExerciseEntryModel>> watchEntriesForSession(Id sessionId);

  Future<List<ExerciseEntryModel>> getEntriesForSession(Id sessionId);

  Stream<List<ExerciseEntryModel>> watchAllEntries();

  Future<List<ExerciseEntryModel>> getAllEntries();

  Future<Id> saveEntry(ExerciseEntryModel entry);

  Future<void> deleteEntry(Id entryId);

  Future<void> deleteEntriesForSession(Id sessionId);
}
