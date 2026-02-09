import '../../core/enums/app_enums.dart';
import '../../domain/repositories/exercise_template_repository.dart';
import '../models/exercise_template_model.dart';

class SeedService {
  SeedService(this._repository);

  final ExerciseTemplateRepository _repository;

  Future<void> seedIfNeeded() async {
    final now = DateTime.now();

    final templates = <ExerciseTemplateModel>[
      _template(
        name: 'Push-Up',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.midChest,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        notes: 'Keep a rigid plank and full lockout each rep.',
        createdAt: now,
      ),
      _template(
        name: 'Incline Dumbbell Press',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.upperChest,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.dumbbell,
        createdAt: now,
      ),
      _template(
        name: 'Pull-Up',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.lats,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Seated Cable Row',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.rhomboids,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.cable,
        createdAt: now,
      ),
      _template(
        name: 'Back Squat',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.barbell,
        createdAt: now,
      ),
      _template(
        name: 'Romanian Deadlift',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.hamstrings,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.barbell,
        createdAt: now,
      ),
      _template(
        name: 'Walking Lunge',
        muscleGroup: MuscleGroup.glutes,
        specificMuscle: SpecificMuscle.gluteMax,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.dumbbell,
        createdAt: now,
      ),
      _template(
        name: 'Overhead Press',
        muscleGroup: MuscleGroup.shoulders,
        specificMuscle: SpecificMuscle.frontDelts,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.barbell,
        createdAt: now,
      ),
      _template(
        name: 'Plank',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Jump Rope',
        muscleGroup: MuscleGroup.cardio,
        specificMuscle: SpecificMuscle.aerobic,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.other,
        createdAt: now,
      ),
    ];

    await _repository.seedIfEmpty(templates);
  }

  ExerciseTemplateModel _template({
    required String name,
    required MuscleGroup muscleGroup,
    required SpecificMuscle specificMuscle,
    required DifficultyLevel difficulty,
    required DateTime createdAt,
    EquipmentType? equipment,
    String? notes,
  }) {
    final model = ExerciseTemplateModel()
      ..name = name
      ..muscleGroup = muscleGroup
      ..specificMuscle = specificMuscle
      ..defaultDifficulty = difficulty
      ..equipment = equipment
      ..notes = notes
      ..createdAt = createdAt
      ..updatedAt = createdAt;

    final progression = ProgressionSettingsModel()
      ..minReps = 6
      ..maxReps = 12
      ..progressionStep = 1.0
      ..targetSets = 3;
    model.progressionSettings = progression;

    return model;
  }
}
