import '../../core/enums/app_enums.dart';
import '../../domain/repositories/exercise_template_repository.dart';
import '../models/exercise_template_model.dart';

class SeedService {
  SeedService(this._repository);

  final ExerciseTemplateRepository _repository;

  Future<void> seedIfNeeded() async {
    final now = DateTime.now();
    final existing = await _repository.getAll();
    final existingNames = existing
        .map((template) => _normalizeName(template.name))
        .toSet();

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
      _template(
        name: 'Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Reverse Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Bicycle Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.obliques,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Vertical Leg Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Long Arm Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Oblique Crunches',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.obliques,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Rolling Wheel Abs Workout',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.other,
        createdAt: now,
      ),
      _template(
        name: 'Modified Candlestick',
        muscleGroup: MuscleGroup.core,
        specificMuscle: SpecificMuscle.abs,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Standing Ring Pull-Ups (Chest Height)',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.rhomboids,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Standing Ring Pull-Ups (Waist Height)',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.lats,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Parallel Bar Chest Dips',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.midChest,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Parallel Bar Triceps Dips',
        muscleGroup: MuscleGroup.arms,
        specificMuscle: SpecificMuscle.triceps,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Bodyweight Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Lunges',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Glute Bridges',
        muscleGroup: MuscleGroup.glutes,
        specificMuscle: SpecificMuscle.gluteMax,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Calf Raises',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.calves,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Wall Sits',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Pistol Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Bulgarian Split Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Shrimp Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Cossack Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.adductors,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Nordic Curls',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.hamstrings,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Single-Leg Romanian Deadlift',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.hamstrings,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Reverse Nordics',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Jump Squats',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Box Jumps',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.other,
        createdAt: now,
      ),
      _template(
        name: 'Jumping Lunges',
        muscleGroup: MuscleGroup.legs,
        specificMuscle: SpecificMuscle.quads,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Wide Push-Ups',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.midChest,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Decline Push-Ups',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.upperChest,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Archer Push-Ups',
        muscleGroup: MuscleGroup.chest,
        specificMuscle: SpecificMuscle.midChest,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Inverted Rows',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.rhomboids,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Chin-Ups',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.lats,
        difficulty: DifficultyLevel.hard,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Superman',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.spinalErectors,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Scapular Shrugs',
        muscleGroup: MuscleGroup.back,
        specificMuscle: SpecificMuscle.traps,
        difficulty: DifficultyLevel.easy,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Diamond Push-Ups',
        muscleGroup: MuscleGroup.arms,
        specificMuscle: SpecificMuscle.triceps,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Bench Dips',
        muscleGroup: MuscleGroup.arms,
        specificMuscle: SpecificMuscle.triceps,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.bodyweight,
        createdAt: now,
      ),
      _template(
        name: 'Seated Hammer Curls',
        muscleGroup: MuscleGroup.arms,
        specificMuscle: SpecificMuscle.forearms,
        difficulty: DifficultyLevel.moderate,
        equipment: EquipmentType.dumbbell,
        createdAt: now,
      ),
    ];

    final missingTemplates = templates.where((template) {
      final normalizedName = _normalizeName(template.name);
      return !existingNames.contains(normalizedName);
    });

    for (final template in missingTemplates) {
      await _repository.save(template);
    }
  }

  String _normalizeName(String value) {
    return value.trim().toLowerCase();
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
      ..muscleGroups = <MuscleGroup>[muscleGroup]
      ..specificMuscles = <SpecificMuscle>[specificMuscle]
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
