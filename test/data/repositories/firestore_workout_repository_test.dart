import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_entry_model.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/data/repositories/firestore_workout_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreWorkoutRepository', () {
    test(
      'deleteEntry with sessionId removes only the targeted entry',
      () async {
        final firestore = FakeFirebaseFirestore();
        final repository = FirestoreWorkoutRepository(firestore, 'user_1');

        final sessionA = WorkoutSessionModel()
          ..date = DateTime(2026, 2, 13)
          ..status = SessionStatus.success;
        final sessionAId = await repository.saveSession(sessionA);
        sessionA.id = sessionAId;

        final sessionB = WorkoutSessionModel()
          ..date = DateTime(2026, 2, 14)
          ..status = SessionStatus.rest;
        final sessionBId = await repository.saveSession(sessionB);
        sessionB.id = sessionBId;

        final removable = _entry(
          workoutSessionId: sessionAId,
          exerciseTemplateId: 10,
        );
        final keepA = _entry(
          workoutSessionId: sessionAId,
          exerciseTemplateId: 11,
        );
        final keepB = _entry(
          workoutSessionId: sessionBId,
          exerciseTemplateId: 12,
        );

        final removableId = await repository.saveEntry(removable);
        await repository.saveEntry(keepA);
        await repository.saveEntry(keepB);

        await repository.deleteEntry(removableId, sessionId: sessionAId);

        final entriesA = await repository.getEntriesForSession(sessionAId);
        final entriesB = await repository.getEntriesForSession(sessionBId);

        expect(entriesA.map((entry) => entry.exerciseTemplateId), [11]);
        expect(entriesB.map((entry) => entry.exerciseTemplateId), [12]);
      },
    );

    test(
      'deleteEntry without sessionId resolves the matching session and deletes',
      () async {
        final firestore = FakeFirebaseFirestore();
        final repository = FirestoreWorkoutRepository(firestore, 'user_1');

        final session = WorkoutSessionModel()
          ..date = DateTime(2026, 2, 15)
          ..status = SessionStatus.success;
        final sessionId = await repository.saveSession(session);
        session.id = sessionId;

        final entry = _entry(
          workoutSessionId: sessionId,
          exerciseTemplateId: 99,
        );
        final entryId = await repository.saveEntry(entry);

        await repository.deleteEntry(entryId);

        final entries = await repository.getEntriesForSession(sessionId);
        expect(entries, isEmpty);
      },
    );

    test('deleteEntry is a no-op when id is missing', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = FirestoreWorkoutRepository(firestore, 'user_1');

      await repository.deleteEntry(999999999);
    });
  });
}

ExerciseEntryModel _entry({
  required int workoutSessionId,
  required int exerciseTemplateId,
}) {
  final set = SetItemModel()
    ..setNumber = 1
    ..reps = 10;

  return ExerciseEntryModel()
    ..workoutSessionId = workoutSessionId
    ..exerciseTemplateId = exerciseTemplateId
    ..schemeType = SchemeType.standard
    ..feltDifficulty = DifficultyLevel.moderate
    ..sets = [set]
    ..muscleGroup = MuscleGroup.core
    ..specificMuscle = SpecificMuscle.abs
    ..muscleGroups = [MuscleGroup.core]
    ..specificMuscles = [SpecificMuscle.abs];
}
