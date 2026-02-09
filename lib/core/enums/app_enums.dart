enum SessionStatus { success, partial, fail, rest }

enum SchemeType { standard, superset, easyMode }

enum DifficultyLevel { easy, moderate, hard }

enum MediaType { photo, video, link }

enum EquipmentType {
  bodyweight,
  dumbbell,
  barbell,
  kettlebell,
  machine,
  cable,
  band,
  medicineBall,
  other,
}

enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  legs,
  glutes,
  core,
  cardio,
  mobility,
  fullBody,
}

enum SpecificMuscle {
  // Chest
  upperChest,
  midChest,
  lowerChest,

  // Back
  lats,
  rhomboids,
  traps,
  lowerBack,

  // Shoulders
  frontDelts,
  sideDelts,
  rearDelts,

  // Arms
  biceps,
  triceps,
  forearms,

  // Legs
  quads,
  hamstrings,
  calves,
  adductors,

  // Glutes
  gluteMax,
  gluteMed,

  // Core
  abs,
  obliques,
  spinalErectors,

  // Cardio
  aerobic,
  anaerobic,

  // Mobility
  hips,
  thoracic,
  ankles,

  // Full body fallback
  fullBody,
}

const Map<MuscleGroup, List<SpecificMuscle>> specificMusclesByGroup = {
  MuscleGroup.chest: [
    SpecificMuscle.upperChest,
    SpecificMuscle.midChest,
    SpecificMuscle.lowerChest,
  ],
  MuscleGroup.back: [
    SpecificMuscle.lats,
    SpecificMuscle.rhomboids,
    SpecificMuscle.traps,
    SpecificMuscle.lowerBack,
  ],
  MuscleGroup.shoulders: [
    SpecificMuscle.frontDelts,
    SpecificMuscle.sideDelts,
    SpecificMuscle.rearDelts,
  ],
  MuscleGroup.arms: [
    SpecificMuscle.biceps,
    SpecificMuscle.triceps,
    SpecificMuscle.forearms,
  ],
  MuscleGroup.legs: [
    SpecificMuscle.quads,
    SpecificMuscle.hamstrings,
    SpecificMuscle.calves,
    SpecificMuscle.adductors,
  ],
  MuscleGroup.glutes: [
    SpecificMuscle.gluteMax,
    SpecificMuscle.gluteMed,
  ],
  MuscleGroup.core: [
    SpecificMuscle.abs,
    SpecificMuscle.obliques,
    SpecificMuscle.spinalErectors,
  ],
  MuscleGroup.cardio: [
    SpecificMuscle.aerobic,
    SpecificMuscle.anaerobic,
  ],
  MuscleGroup.mobility: [
    SpecificMuscle.hips,
    SpecificMuscle.thoracic,
    SpecificMuscle.ankles,
  ],
  MuscleGroup.fullBody: [SpecificMuscle.fullBody],
};

extension EnumLabels on Enum {
  String get label {
    final parts = name.replaceAllMapped(
      RegExp('([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return parts[0].toUpperCase() + parts.substring(1);
  }
}
