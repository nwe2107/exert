import 'package:flutter_test/flutter_test.dart';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_entry_model.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/domain/services/heatmap_service.dart';

void main() {
  group('HeatmapService', () {
    test('marks all muscles from a multi-target entry as trained', () {
      final service = HeatmapService();
      final sessions = [_session(id: 10, date: DateTime(2026, 2, 12))];
      final entries = [
        _entry(
          id: 100,
          sessionId: 10,
          templateId: 1,
          primaryMuscle: SpecificMuscle.midChest,
          allMuscles: const [SpecificMuscle.midChest, SpecificMuscle.triceps],
        ),
      ];
      final templatesById = <int, ExerciseTemplateModel>{
        1: _template(
          id: 1,
          name: 'Push-Up',
          primaryMuscle: SpecificMuscle.midChest,
          allMuscles: const [SpecificMuscle.midChest, SpecificMuscle.triceps],
        ),
      };

      final items = service.build(
        today: DateTime(2026, 2, 13),
        sessions: sessions,
        entries: entries,
        templatesById: templatesById,
      );

      final chestItem = _itemFor(items, SpecificMuscle.midChest);
      final tricepsItem = _itemFor(items, SpecificMuscle.triceps);

      expect(chestItem.daysSinceLastTrained, 1);
      expect(tricepsItem.daysSinceLastTrained, 1);
      expect(chestItem.exercisesOnLastTrainedDate, contains('Push-Up'));
      expect(tricepsItem.exercisesOnLastTrainedDate, contains('Push-Up'));
    });

    test('keeps compatibility with older single-target entries', () {
      final service = HeatmapService();
      final sessions = [_session(id: 20, date: DateTime(2026, 2, 12))];
      final entries = [
        _entry(
          id: 200,
          sessionId: 20,
          templateId: 2,
          primaryMuscle: SpecificMuscle.quads,
          allMuscles: const [],
        ),
      ];
      final templatesById = <int, ExerciseTemplateModel>{
        2: _template(
          id: 2,
          name: 'Back Squat',
          primaryMuscle: SpecificMuscle.quads,
          allMuscles: const [],
        ),
      };

      final items = service.build(
        today: DateTime(2026, 2, 13),
        sessions: sessions,
        entries: entries,
        templatesById: templatesById,
      );

      final quadsItem = _itemFor(items, SpecificMuscle.quads);
      final hamstringsItem = _itemFor(items, SpecificMuscle.hamstrings);

      expect(quadsItem.daysSinceLastTrained, 1);
      expect(quadsItem.exercisesOnLastTrainedDate, contains('Back Squat'));
      expect(hamstringsItem.daysSinceLastTrained, isNull);
      expect(hamstringsItem.exercisesOnLastTrainedDate, isEmpty);
    });

    test('ignores future logged sessions for recency calculations', () {
      final service = HeatmapService();
      final sessions = [_session(id: 30, date: DateTime(2026, 2, 15))];
      final entries = [
        _entry(
          id: 300,
          sessionId: 30,
          templateId: 3,
          primaryMuscle: SpecificMuscle.abs,
          allMuscles: const [SpecificMuscle.abs],
        ),
      ];
      final templatesById = <int, ExerciseTemplateModel>{
        3: _template(
          id: 3,
          name: 'Crunches',
          primaryMuscle: SpecificMuscle.abs,
          allMuscles: const [SpecificMuscle.abs],
        ),
      };

      final items = service.build(
        today: DateTime(2026, 2, 13),
        sessions: sessions,
        entries: entries,
        templatesById: templatesById,
      );

      final absItem = _itemFor(items, SpecificMuscle.abs);

      expect(absItem.daysSinceLastTrained, isNull);
      expect(absItem.exercisesOnLastTrainedDate, isEmpty);
    });
  });
}

WorkoutSessionModel _session({required int id, required DateTime date}) {
  final now = DateTime(2026, 2, 13);
  return WorkoutSessionModel()
    ..id = id
    ..date = date
    ..status = SessionStatus.success
    ..createdAt = now
    ..updatedAt = now;
}

ExerciseEntryModel _entry({
  required int id,
  required int sessionId,
  required int templateId,
  required SpecificMuscle primaryMuscle,
  required List<SpecificMuscle> allMuscles,
}) {
  final now = DateTime(2026, 2, 13);
  final primaryGroup = _groupForSpecificMuscle(primaryMuscle);
  final resolvedMuscles = allMuscles.isEmpty
      ? <SpecificMuscle>[primaryMuscle]
      : allMuscles;
  final resolvedGroups = resolvedMuscles
      .map(_groupForSpecificMuscle)
      .toSet()
      .toList(growable: false);

  return ExerciseEntryModel()
    ..id = id
    ..workoutSessionId = sessionId
    ..exerciseTemplateId = templateId
    ..schemeType = SchemeType.standard
    ..feltDifficulty = DifficultyLevel.moderate
    ..sets = <SetItemModel>[]
    ..muscleGroup = primaryGroup
    ..specificMuscle = primaryMuscle
    ..muscleGroups = allMuscles.isEmpty ? <MuscleGroup>[] : resolvedGroups
    ..specificMuscles = allMuscles
    ..createdAt = now
    ..updatedAt = now;
}

ExerciseTemplateModel _template({
  required int id,
  required String name,
  required SpecificMuscle primaryMuscle,
  required List<SpecificMuscle> allMuscles,
}) {
  final now = DateTime(2026, 2, 13);
  final primaryGroup = _groupForSpecificMuscle(primaryMuscle);
  final resolvedMuscles = allMuscles.isEmpty
      ? <SpecificMuscle>[primaryMuscle]
      : allMuscles;
  final resolvedGroups = resolvedMuscles
      .map(_groupForSpecificMuscle)
      .toSet()
      .toList(growable: false);

  return ExerciseTemplateModel()
    ..id = id
    ..name = name
    ..muscleGroup = primaryGroup
    ..specificMuscle = primaryMuscle
    ..muscleGroups = allMuscles.isEmpty ? <MuscleGroup>[] : resolvedGroups
    ..specificMuscles = allMuscles
    ..defaultDifficulty = DifficultyLevel.moderate
    ..createdAt = now
    ..updatedAt = now;
}

MuscleHeatmapItem _itemFor(
  List<MuscleHeatmapItem> items,
  SpecificMuscle muscle,
) {
  return items.firstWhere((item) => item.specificMuscle == muscle);
}

MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
  for (final entry in specificMusclesByGroup.entries) {
    if (entry.value.contains(muscle)) {
      return entry.key;
    }
  }
  return MuscleGroup.fullBody;
}
