import 'package:flutter_test/flutter_test.dart';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/features/workout/domain/compound_exercise_template_expander.dart';

void main() {
  test('returns selected template when it is not compound', () {
    final selected = _template(
      id: 1,
      name: 'Crunch',
      group: MuscleGroup.core,
      specific: SpecificMuscle.abs,
    );

    final result = expandTemplateForLogging(
      selected,
      templatesById: {selected.id: selected},
    );

    expect(result.map((template) => template.id).toList(), [1]);
  });

  test('expands direct compound components in configured order', () {
    final selected = _template(
      id: 1,
      name: '7 Minute Abs',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [2, 3],
    );
    final crunch = _template(
      id: 2,
      name: 'Crunch',
      group: MuscleGroup.core,
      specific: SpecificMuscle.abs,
    );
    final plank = _template(
      id: 3,
      name: 'Plank',
      group: MuscleGroup.core,
      specific: SpecificMuscle.spinalErectors,
    );

    final result = expandTemplateForLogging(
      selected,
      templatesById: {
        selected.id: selected,
        crunch.id: crunch,
        plank.id: plank,
      },
    );

    expect(result.map((template) => template.id).toList(), [2, 3]);
  });

  test('expands nested compounds to leaf exercises', () {
    final selected = _template(
      id: 1,
      name: 'Core Circuit',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [2, 3],
    );
    final nestedCompound = _template(
      id: 2,
      name: 'Abs Pair',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [4],
    );
    final sidePlank = _template(
      id: 3,
      name: 'Side Plank',
      group: MuscleGroup.core,
      specific: SpecificMuscle.obliques,
    );
    final crunch = _template(
      id: 4,
      name: 'Crunch',
      group: MuscleGroup.core,
      specific: SpecificMuscle.abs,
    );

    final result = expandTemplateForLogging(
      selected,
      templatesById: {
        selected.id: selected,
        nestedCompound.id: nestedCompound,
        sidePlank.id: sidePlank,
        crunch.id: crunch,
      },
    );

    expect(result.map((template) => template.id).toList(), [4, 3]);
  });

  test('falls back to selected template when all components are missing', () {
    final selected = _template(
      id: 1,
      name: 'Broken Compound',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [999],
    );

    final result = expandTemplateForLogging(
      selected,
      templatesById: {selected.id: selected},
    );

    expect(result.map((template) => template.id).toList(), [1]);
  });

  test('falls back to selected template when compounds form a cycle', () {
    final first = _template(
      id: 1,
      name: 'Cycle A',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [2],
    );
    final second = _template(
      id: 2,
      name: 'Cycle B',
      group: MuscleGroup.fullBody,
      specific: SpecificMuscle.fullBody,
      isCompound: true,
      componentIds: [1],
    );

    final result = expandTemplateForLogging(
      first,
      templatesById: {first.id: first, second.id: second},
    );

    expect(result.map((template) => template.id).toList(), [1]);
  });
}

ExerciseTemplateModel _template({
  required int id,
  required String name,
  required MuscleGroup group,
  required SpecificMuscle specific,
  bool isCompound = false,
  List<int> componentIds = const <int>[],
}) {
  final now = DateTime.now();
  return ExerciseTemplateModel()
    ..id = id
    ..name = name
    ..muscleGroup = group
    ..specificMuscle = specific
    ..defaultDifficulty = DifficultyLevel.moderate
    ..isCompound = isCompound
    ..compoundExerciseTemplateIds = componentIds
    ..createdAt = now
    ..updatedAt = now;
}
