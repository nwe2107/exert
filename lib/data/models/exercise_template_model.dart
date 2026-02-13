import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';

part 'exercise_template_model.g.dart';

@embedded
class ProgressionSettingsModel {
  int? minReps;
  int? maxReps;
  double? progressionStep;
  int? targetSets;
}

@Collection(accessor: 'exerciseTemplates')
class ExerciseTemplateModel {
  ExerciseTemplateModel();

  Id id = Isar.autoIncrement;

  late String name;

  @Enumerated(EnumType.name)
  MediaType? mediaType;

  String? mediaUrl;

  @Enumerated(EnumType.name)
  late MuscleGroup muscleGroup;

  @Enumerated(EnumType.name)
  late SpecificMuscle specificMuscle;

  @Enumerated(EnumType.name)
  List<MuscleGroup> muscleGroups = [];

  @Enumerated(EnumType.name)
  List<SpecificMuscle> specificMuscles = [];

  @Enumerated(EnumType.name)
  late DifficultyLevel defaultDifficulty;

  @Enumerated(EnumType.name)
  EquipmentType? equipment;

  String? notes;

  bool isCompound = false;

  List<int> compoundExerciseTemplateIds = [];

  ProgressionSettingsModel? progressionSettings;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;

  @Index()
  String get lowercaseName => name.toLowerCase();

  List<SpecificMuscle> resolveSpecificMuscles() {
    if (specificMuscles.isNotEmpty) {
      return _dedupeEnums(specificMuscles);
    }
    return <SpecificMuscle>[specificMuscle];
  }

  List<MuscleGroup> resolveMuscleGroups() {
    final fromSpecific = resolveSpecificMuscles()
        .map(_groupForSpecificMuscle)
        .toList(growable: false);
    if (fromSpecific.isNotEmpty) {
      return _dedupeEnums(fromSpecific);
    }
    if (muscleGroups.isNotEmpty) {
      return _dedupeEnums(muscleGroups);
    }
    return <MuscleGroup>[muscleGroup];
  }

  List<ExerciseTarget> resolveTargets() {
    return resolveSpecificMuscles()
        .map(
          (specific) => (
            muscleGroup: _groupForSpecificMuscle(specific),
            specificMuscle: specific,
          ),
        )
        .toList(growable: false);
  }

  static MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
    for (final entry in specificMusclesByGroup.entries) {
      if (entry.value.contains(muscle)) {
        return entry.key;
      }
    }
    return MuscleGroup.fullBody;
  }

  static List<T> _dedupeEnums<T>(Iterable<T> values) {
    final unique = <T>{};
    final ordered = <T>[];
    for (final value in values) {
      if (unique.add(value)) {
        ordered.add(value);
      }
    }
    return ordered;
  }
}

typedef ExerciseTarget = ({
  MuscleGroup muscleGroup,
  SpecificMuscle specificMuscle,
});
