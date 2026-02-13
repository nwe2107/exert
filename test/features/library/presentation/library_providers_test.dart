import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/features/library/presentation/library_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('filters library templates by specific muscle', () {
    final templates = [
      _template(
        id: 1,
        name: 'Crunches',
        group: MuscleGroup.core,
        muscle: SpecificMuscle.abs,
      ),
      _template(
        id: 2,
        name: 'Plank',
        group: MuscleGroup.core,
        muscle: SpecificMuscle.abs,
      ),
      _template(
        id: 3,
        name: 'Russian Twists',
        group: MuscleGroup.core,
        muscle: SpecificMuscle.obliques,
      ),
    ];

    final result = applyLibraryFilters(
      templates: templates,
      query: '',
      group: MuscleGroup.core,
      specificMuscle: SpecificMuscle.abs,
    );

    expect(result.map((template) => template.name), ['Crunches', 'Plank']);
  });

  test(
    'keeps muscle group filter behavior when specific muscle is not set',
    () {
      final templates = [
        _template(
          id: 1,
          name: 'Crunches',
          group: MuscleGroup.core,
          muscle: SpecificMuscle.abs,
        ),
        _template(
          id: 2,
          name: 'Russian Twists',
          group: MuscleGroup.core,
          muscle: SpecificMuscle.obliques,
        ),
        _template(
          id: 3,
          name: 'Squats',
          group: MuscleGroup.legs,
          muscle: SpecificMuscle.quads,
        ),
      ];

      final result = applyLibraryFilters(
        templates: templates,
        query: '',
        group: MuscleGroup.core,
        specificMuscle: null,
      );

      expect(result.map((template) => template.name), [
        'Crunches',
        'Russian Twists',
      ]);
    },
  );

  test('applies query matching alongside muscle filters', () {
    final templates = [
      _template(
        id: 1,
        name: 'Russian Twists',
        group: MuscleGroup.core,
        muscle: SpecificMuscle.obliques,
      ),
      _template(
        id: 2,
        name: 'Side Plank',
        group: MuscleGroup.core,
        muscle: SpecificMuscle.obliques,
      ),
    ];

    final result = applyLibraryFilters(
      templates: templates,
      query: 'twist',
      group: MuscleGroup.core,
      specificMuscle: SpecificMuscle.obliques,
    );

    expect(result.map((template) => template.name), ['Russian Twists']);
  });

  test('matches templates when filter targets a secondary muscle', () {
    final templates = [
      _template(
        id: 1,
        name: 'Push-Up',
        group: MuscleGroup.chest,
        muscle: SpecificMuscle.midChest,
        specificMuscles: const [
          SpecificMuscle.midChest,
          SpecificMuscle.triceps,
        ],
      ),
      _template(
        id: 2,
        name: 'Barbell Curl',
        group: MuscleGroup.arms,
        muscle: SpecificMuscle.biceps,
      ),
    ];

    final result = applyLibraryFilters(
      templates: templates,
      query: '',
      group: MuscleGroup.arms,
      specificMuscle: SpecificMuscle.triceps,
    );

    expect(result.map((template) => template.name), ['Push-Up']);
  });
}

ExerciseTemplateModel _template({
  required int id,
  required String name,
  required MuscleGroup group,
  required SpecificMuscle muscle,
  List<SpecificMuscle>? specificMuscles,
}) {
  final now = DateTime(2026, 2, 12);
  final resolvedSpecificMuscles = specificMuscles ?? <SpecificMuscle>[muscle];
  final resolvedGroups = <MuscleGroup>[];
  for (final specific in resolvedSpecificMuscles) {
    final targetGroup = _groupForSpecificMuscle(specific);
    if (!resolvedGroups.contains(targetGroup)) {
      resolvedGroups.add(targetGroup);
    }
  }

  return ExerciseTemplateModel()
    ..id = id
    ..name = name
    ..muscleGroup = group
    ..specificMuscle = muscle
    ..muscleGroups = resolvedGroups
    ..specificMuscles = resolvedSpecificMuscles
    ..defaultDifficulty = DifficultyLevel.moderate
    ..createdAt = now
    ..updatedAt = now;
}

MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
  for (final entry in specificMusclesByGroup.entries) {
    if (entry.value.contains(muscle)) {
      return entry.key;
    }
  }
  return MuscleGroup.fullBody;
}
