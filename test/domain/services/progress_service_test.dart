import 'package:flutter_test/flutter_test.dart';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_entry_model.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/domain/services/progress_service.dart';

void main() {
  group('ProgressService.buildMuscleAnalysis', () {
    test('builds workout points and latest delta for selected muscle', () {
      final service = ProgressService();
      final sessions = [
        _session(id: 1, date: DateTime(2026, 2, 1)),
        _session(id: 2, date: DateTime(2026, 2, 5)),
        _session(id: 3, date: DateTime(2026, 2, 8)),
      ];
      final entries = [
        _entry(id: 1, sessionId: 1, muscle: SpecificMuscle.abs, reps: [10, 12]),
        _entry(
          id: 2,
          sessionId: 2,
          muscle: SpecificMuscle.abs,
          reps: [12, 12, 10],
        ),
        _entry(
          id: 3,
          sessionId: 3,
          muscle: SpecificMuscle.abs,
          reps: [15, 14, 12],
        ),
        _entry(
          id: 4,
          sessionId: 3,
          muscle: SpecificMuscle.quads,
          reps: [20, 18],
        ),
      ];

      final analysis = service.buildMuscleAnalysis(
        sessions: sessions,
        entries: entries,
        muscle: SpecificMuscle.abs,
        rangeDays: 30,
        today: DateTime(2026, 2, 9),
      );

      expect(analysis.workouts.length, 3);
      expect(analysis.workouts[0].totalReps, 22);
      expect(analysis.workouts[1].totalReps, 34);
      expect(analysis.workouts[2].totalReps, 41);
      expect(analysis.workouts[2].totalSets, 3);
      expect(analysis.workouts[2].averageRepsPerSet, closeTo(13.666, 0.01));

      final latestDelta = analysis.latestDelta;
      expect(latestDelta, isNotNull);
      expect(latestDelta!.deltaReps, 7);
      expect(latestDelta.deltaSets, 0);
      expect(latestDelta.deltaMaxReps, 3);
      expect(latestDelta.deltaWorkScore, 21);
    });

    test('respects selected date range', () {
      final service = ProgressService();
      final sessions = [
        _session(id: 1, date: DateTime(2026, 1, 20)),
        _session(id: 2, date: DateTime(2026, 2, 4)),
        _session(id: 3, date: DateTime(2026, 2, 8)),
      ];
      final entries = [
        _entry(id: 1, sessionId: 1, muscle: SpecificMuscle.abs, reps: [10, 10]),
        _entry(id: 2, sessionId: 2, muscle: SpecificMuscle.abs, reps: [10, 10]),
        _entry(id: 3, sessionId: 3, muscle: SpecificMuscle.abs, reps: [12, 10]),
      ];

      final analysis = service.buildMuscleAnalysis(
        sessions: sessions,
        entries: entries,
        muscle: SpecificMuscle.abs,
        rangeDays: 7,
        today: DateTime(2026, 2, 9),
      );

      expect(analysis.workouts.length, 2);
      expect(analysis.workouts.first.sessionId, 2);
      expect(analysis.workouts.last.sessionId, 3);
    });

    test('returns empty data when selected muscle has no entries', () {
      final service = ProgressService();
      final sessions = [_session(id: 1, date: DateTime(2026, 2, 8))];
      final entries = [
        _entry(
          id: 1,
          sessionId: 1,
          muscle: SpecificMuscle.quads,
          reps: [10, 10],
        ),
      ];

      final analysis = service.buildMuscleAnalysis(
        sessions: sessions,
        entries: entries,
        muscle: SpecificMuscle.abs,
        rangeDays: 30,
        today: DateTime(2026, 2, 9),
      );

      expect(analysis.workouts, isEmpty);
      expect(analysis.latestDelta, isNull);
    });
  });
}

WorkoutSessionModel _session({required int id, required DateTime date}) {
  final now = DateTime(2026, 2, 9);
  return WorkoutSessionModel()
    ..id = id
    ..date = date
    ..status = SessionStatus.success
    ..durationMinutes = 20
    ..createdAt = now
    ..updatedAt = now;
}

ExerciseEntryModel _entry({
  required int id,
  required int sessionId,
  required SpecificMuscle muscle,
  required List<int> reps,
}) {
  final now = DateTime(2026, 2, 9);
  final group = _groupForMuscle(muscle);
  return ExerciseEntryModel()
    ..id = id
    ..workoutSessionId = sessionId
    ..exerciseTemplateId = 100 + id
    ..schemeType = SchemeType.standard
    ..feltDifficulty = DifficultyLevel.moderate
    ..sets = reps
        .asMap()
        .entries
        .map(
          (entry) => SetItemModel()
            ..setNumber = entry.key + 1
            ..reps = entry.value,
        )
        .toList()
    ..muscleGroup = group
    ..specificMuscle = muscle
    ..createdAt = now
    ..updatedAt = now;
}

MuscleGroup _groupForMuscle(SpecificMuscle muscle) {
  for (final entry in specificMusclesByGroup.entries) {
    if (entry.value.contains(muscle)) {
      return entry.key;
    }
  }
  return MuscleGroup.fullBody;
}
