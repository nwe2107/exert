import '../../../data/models/exercise_template_model.dart';

List<ExerciseTemplateModel> expandTemplateForLogging(
  ExerciseTemplateModel selected, {
  required Map<int, ExerciseTemplateModel> templatesById,
}) {
  if (!selected.isCompound || selected.compoundExerciseTemplateIds.isEmpty) {
    return <ExerciseTemplateModel>[selected];
  }

  final expanded = <ExerciseTemplateModel>[];
  final visitedCompounds = <int>{};

  void collect(ExerciseTemplateModel template) {
    if (!template.isCompound || template.compoundExerciseTemplateIds.isEmpty) {
      expanded.add(template);
      return;
    }

    if (!visitedCompounds.add(template.id)) {
      return;
    }

    for (final childId in template.compoundExerciseTemplateIds) {
      final child = templatesById[childId];
      if (child == null) {
        continue;
      }
      collect(child);
    }
  }

  collect(selected);

  if (expanded.isEmpty) {
    return <ExerciseTemplateModel>[selected];
  }

  return expanded;
}
