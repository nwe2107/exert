import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';

part 'exercise_entry_model.g.dart';

@embedded
class SetItemModel {
  int setNumber = 1;
  int? reps;
  double? weight;
  int? durationSeconds;
  double? rpe;
}

@Collection(accessor: 'exerciseEntries')
class ExerciseEntryModel {
  ExerciseEntryModel();

  Id id = Isar.autoIncrement;

  @Index()
  late int workoutSessionId;

  @Index()
  late int exerciseTemplateId;

  @Enumerated(EnumType.name)
  late SchemeType schemeType;

  String? supersetGroupId;

  @Enumerated(EnumType.name)
  late DifficultyLevel feltDifficulty;

  int? restSeconds;

  String? notes;

  late List<SetItemModel> sets;

  // Denormalized for heatmap + analytics queries.
  @Enumerated(EnumType.name)
  late MuscleGroup muscleGroup;

  @Enumerated(EnumType.name)
  late SpecificMuscle specificMuscle;

  @Enumerated(EnumType.name)
  List<MuscleGroup> muscleGroups = [];

  @Enumerated(EnumType.name)
  List<SpecificMuscle> specificMuscles = [];

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;

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
