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
}
