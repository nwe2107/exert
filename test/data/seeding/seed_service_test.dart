import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/data/seeding/seed_service.dart';
import 'package:exert/domain/repositories/exercise_template_repository.dart';

void main() {
  group('SeedService', () {
    test('seeds built-ins and remains idempotent across reruns', () async {
      final repository = _InMemoryExerciseTemplateRepository();
      final service = SeedService(repository);

      await service.seedIfNeeded();
      final firstRunTemplates = await repository.getAll();

      expect(firstRunTemplates.length, 47);
      expect(_hasDuplicateNames(firstRunTemplates), isFalse);

      await service.seedIfNeeded();
      final secondRunTemplates = await repository.getAll();

      expect(secondRunTemplates.length, 47);
      expect(_hasDuplicateNames(secondRunTemplates), isFalse);
    });

    test(
      'backfills missing built-ins for existing users without duplicates',
      () async {
        final repository = _InMemoryExerciseTemplateRepository();
        final service = SeedService(repository);

        await repository.save(
          _testTemplate(
            name: 'my custom drill',
            muscleGroup: MuscleGroup.fullBody,
            specificMuscle: SpecificMuscle.fullBody,
          ),
        );
        await repository.save(
          _testTemplate(
            name: 'push-up',
            muscleGroup: MuscleGroup.chest,
            specificMuscle: SpecificMuscle.midChest,
          ),
        );

        await service.seedIfNeeded();
        final templates = await repository.getAll();

        expect(templates.length, 48);
        expect(_countByNormalizedName(templates, 'my custom drill'), 1);
        expect(_countByNormalizedName(templates, 'push-up'), 1);
        expect(_hasDuplicateNames(templates), isFalse);
      },
    );

    test('maps requested new exercises to expected muscle targets', () async {
      final repository = _InMemoryExerciseTemplateRepository();
      final service = SeedService(repository);

      await service.seedIfNeeded();
      final templates = await repository.getAll();
      final byName = {
        for (final template in templates) template.name.toLowerCase(): template,
      };

      for (final entry in _expectedNewMappings.entries) {
        final template = byName[entry.key.toLowerCase()];
        expect(template, isNotNull, reason: 'Missing template: ${entry.key}');
        expect(
          template!.muscleGroup,
          entry.value.group,
          reason: 'Wrong muscle group for ${entry.key}',
        );
        expect(
          template.specificMuscle,
          entry.value.muscle,
          reason: 'Wrong specific muscle for ${entry.key}',
        );
      }
    });
  });
}

typedef _ExpectedMuscle = ({MuscleGroup group, SpecificMuscle muscle});

const Map<String, _ExpectedMuscle> _expectedNewMappings = {
  'Crunches': (group: MuscleGroup.core, muscle: SpecificMuscle.abs),
  'Reverse Crunches': (group: MuscleGroup.core, muscle: SpecificMuscle.abs),
  'Bicycle Crunches': (
    group: MuscleGroup.core,
    muscle: SpecificMuscle.obliques,
  ),
  'Vertical Leg Crunches': (
    group: MuscleGroup.core,
    muscle: SpecificMuscle.abs,
  ),
  'Long Arm Crunches': (group: MuscleGroup.core, muscle: SpecificMuscle.abs),
  'Oblique Crunches': (
    group: MuscleGroup.core,
    muscle: SpecificMuscle.obliques,
  ),
  'Rolling Wheel Abs Workout': (
    group: MuscleGroup.core,
    muscle: SpecificMuscle.abs,
  ),
  'Modified Candlestick': (group: MuscleGroup.core, muscle: SpecificMuscle.abs),
  'Standing Ring Pull-Ups (Chest Height)': (
    group: MuscleGroup.back,
    muscle: SpecificMuscle.rhomboids,
  ),
  'Standing Ring Pull-Ups (Waist Height)': (
    group: MuscleGroup.back,
    muscle: SpecificMuscle.lats,
  ),
  'Parallel Bar Chest Dips': (
    group: MuscleGroup.chest,
    muscle: SpecificMuscle.midChest,
  ),
  'Parallel Bar Triceps Dips': (
    group: MuscleGroup.arms,
    muscle: SpecificMuscle.triceps,
  ),
  'Bodyweight Squats': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Lunges': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Glute Bridges': (group: MuscleGroup.glutes, muscle: SpecificMuscle.gluteMax),
  'Calf Raises': (group: MuscleGroup.legs, muscle: SpecificMuscle.calves),
  'Wall Sits': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Pistol Squats': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Bulgarian Split Squats': (
    group: MuscleGroup.legs,
    muscle: SpecificMuscle.quads,
  ),
  'Shrimp Squats': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Cossack Squats': (group: MuscleGroup.legs, muscle: SpecificMuscle.adductors),
  'Nordic Curls': (group: MuscleGroup.legs, muscle: SpecificMuscle.hamstrings),
  'Single-Leg Romanian Deadlift': (
    group: MuscleGroup.legs,
    muscle: SpecificMuscle.hamstrings,
  ),
  'Reverse Nordics': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Jump Squats': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Box Jumps': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Jumping Lunges': (group: MuscleGroup.legs, muscle: SpecificMuscle.quads),
  'Wide Push-Ups': (group: MuscleGroup.chest, muscle: SpecificMuscle.midChest),
  'Decline Push-Ups': (
    group: MuscleGroup.chest,
    muscle: SpecificMuscle.upperChest,
  ),
  'Archer Push-Ups': (
    group: MuscleGroup.chest,
    muscle: SpecificMuscle.midChest,
  ),
  'Inverted Rows': (group: MuscleGroup.back, muscle: SpecificMuscle.rhomboids),
  'Chin-Ups': (group: MuscleGroup.back, muscle: SpecificMuscle.lats),
  'Superman': (group: MuscleGroup.back, muscle: SpecificMuscle.spinalErectors),
  'Scapular Shrugs': (group: MuscleGroup.back, muscle: SpecificMuscle.traps),
  'Diamond Push-Ups': (group: MuscleGroup.arms, muscle: SpecificMuscle.triceps),
  'Bench Dips': (group: MuscleGroup.arms, muscle: SpecificMuscle.triceps),
  'Seated Hammer Curls': (
    group: MuscleGroup.arms,
    muscle: SpecificMuscle.forearms,
  ),
};

bool _hasDuplicateNames(List<ExerciseTemplateModel> templates) {
  final names = templates
      .map((template) => _normalizeName(template.name))
      .toList();
  return names.length != names.toSet().length;
}

int _countByNormalizedName(List<ExerciseTemplateModel> templates, String name) {
  final normalized = _normalizeName(name);
  return templates
      .where((template) => _normalizeName(template.name) == normalized)
      .length;
}

String _normalizeName(String name) {
  return name.trim().toLowerCase();
}

ExerciseTemplateModel _testTemplate({
  required String name,
  required MuscleGroup muscleGroup,
  required SpecificMuscle specificMuscle,
}) {
  final now = DateTime.now();
  final progression = ProgressionSettingsModel()
    ..minReps = 6
    ..maxReps = 12
    ..progressionStep = 1.0
    ..targetSets = 3;

  return ExerciseTemplateModel()
    ..name = name
    ..muscleGroup = muscleGroup
    ..specificMuscle = specificMuscle
    ..muscleGroups = <MuscleGroup>[muscleGroup]
    ..specificMuscles = <SpecificMuscle>[specificMuscle]
    ..defaultDifficulty = DifficultyLevel.moderate
    ..equipment = EquipmentType.bodyweight
    ..progressionSettings = progression
    ..createdAt = now
    ..updatedAt = now;
}

class _InMemoryExerciseTemplateRepository
    implements ExerciseTemplateRepository {
  final List<ExerciseTemplateModel> _store = [];
  int _nextId = 1;

  @override
  Future<List<ExerciseTemplateModel>> getAll() async {
    final active = _store
        .where((template) => template.deletedAt == null)
        .toList();
    active.sort((a, b) => a.lowercaseName.compareTo(b.lowercaseName));
    return active.map(_cloneTemplate).toList();
  }

  @override
  Future<ExerciseTemplateModel?> getById(Id id) async {
    for (final template in _store) {
      if (template.id == id && template.deletedAt == null) {
        return _cloneTemplate(template);
      }
    }
    return null;
  }

  @override
  Future<Id> save(ExerciseTemplateModel template) async {
    if (template.id == Isar.autoIncrement || !_existsById(template.id)) {
      final saved = _cloneTemplate(template)..id = _nextId++;
      _store.add(saved);
      return saved.id;
    }

    final saved = _cloneTemplate(template);
    final index = _store.indexWhere((item) => item.id == saved.id);
    _store[index] = saved;
    return saved.id;
  }

  @override
  Future<void> seedIfEmpty(List<ExerciseTemplateModel> templates) async {
    final active = await getAll();
    if (active.isNotEmpty) {
      return;
    }

    for (final template in templates) {
      await save(template);
    }
  }

  @override
  Future<void> softDelete(Id id) async {
    final index = _store.indexWhere((template) => template.id == id);
    if (index < 0) {
      return;
    }

    final deleted = _cloneTemplate(_store[index])
      ..deletedAt = DateTime.now()
      ..updatedAt = DateTime.now();
    _store[index] = deleted;
  }

  @override
  Stream<List<ExerciseTemplateModel>> watchAll() async* {
    yield await getAll();
  }

  bool _existsById(Id id) {
    return _store.any((template) => template.id == id);
  }
}

ExerciseTemplateModel _cloneTemplate(ExerciseTemplateModel source) {
  final model = ExerciseTemplateModel()
    ..id = source.id
    ..name = source.name
    ..mediaType = source.mediaType
    ..mediaUrl = source.mediaUrl
    ..muscleGroup = source.muscleGroup
    ..specificMuscle = source.specificMuscle
    ..muscleGroups = source.muscleGroups.toList(growable: false)
    ..specificMuscles = source.specificMuscles.toList(growable: false)
    ..defaultDifficulty = source.defaultDifficulty
    ..equipment = source.equipment
    ..notes = source.notes
    ..isCompound = source.isCompound
    ..compoundExerciseTemplateIds = source.compoundExerciseTemplateIds.toList(
      growable: false,
    )
    ..createdAt = source.createdAt
    ..updatedAt = source.updatedAt
    ..deletedAt = source.deletedAt;

  final progression = source.progressionSettings;
  if (progression != null) {
    model.progressionSettings = ProgressionSettingsModel()
      ..minReps = progression.minReps
      ..maxReps = progression.maxReps
      ..progressionStep = progression.progressionStep
      ..targetSets = progression.targetSets;
  }

  return model;
}
