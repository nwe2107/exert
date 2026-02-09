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

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
