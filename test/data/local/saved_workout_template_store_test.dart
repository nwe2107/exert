import 'dart:io';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/local/saved_workout_template_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileSavedWorkoutTemplateStore', () {
    late Directory tempDirectory;
    late FileSavedWorkoutTemplateStore store;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'saved-workout-store-test-',
      );
      store = FileSavedWorkoutTemplateStore(
        baseDirectoryResolver: () async => tempDirectory,
      );
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('saves and loads templates sorted by newest update', () async {
      final older = _template(
        id: 'older',
        name: 'Push Day',
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      final newer = _template(
        id: 'newer',
        name: 'Leg Day',
        updatedAt: DateTime.utc(2026, 1, 3),
      );

      await store.saveTemplate(older);
      await store.saveTemplate(newer);

      final loaded = await store.loadTemplates();

      expect(loaded.map((item) => item.id), ['newer', 'older']);
      expect(loaded.first.entries.single.sets.single.reps, 8);
    });

    test('saveTemplate replaces template with matching id', () async {
      final first = _template(
        id: 'template-1',
        name: 'Workout A',
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      final updated = _template(
        id: 'template-1',
        name: 'Workout A - updated',
        updatedAt: DateTime.utc(2026, 1, 2),
      );

      await store.saveTemplate(first);
      await store.saveTemplate(updated);

      final loaded = await store.loadTemplates();

      expect(loaded.length, 1);
      expect(loaded.single.name, 'Workout A - updated');
      expect(loaded.single.updatedAt, DateTime.utc(2026, 1, 2));
    });

    test('deleteTemplate removes existing template', () async {
      await store.saveTemplate(
        _template(
          id: 'template-1',
          name: 'Workout A',
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );
      await store.saveTemplate(
        _template(
          id: 'template-2',
          name: 'Workout B',
          updatedAt: DateTime.utc(2026, 1, 2),
        ),
      );

      await store.deleteTemplate('template-1');
      final loaded = await store.loadTemplates();

      expect(loaded.length, 1);
      expect(loaded.single.id, 'template-2');
    });
  });
}

SavedWorkoutTemplate _template({
  required String id,
  required String name,
  required DateTime updatedAt,
}) {
  return SavedWorkoutTemplate(
    id: id,
    name: name,
    status: SessionStatus.success,
    durationMinutes: 40,
    notes: 'Template notes',
    entries: const [
      SavedWorkoutEntryTemplate(
        exerciseTemplateId: 101,
        schemeType: SchemeType.standard,
        feltDifficulty: DifficultyLevel.moderate,
        sets: [SavedWorkoutSetTemplate(reps: 8)],
      ),
    ],
    createdAt: DateTime.utc(2025, 12, 31),
    updatedAt: updatedAt,
  );
}
