import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/local/saved_workout_template_store.dart';
import 'package:exert/data/repositories/firestore_saved_workout_template_store.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreSavedWorkoutTemplateStore', () {
    test('save + load templates ordered by newest update', () async {
      final firestore = FakeFirebaseFirestore();
      final store = FirestoreSavedWorkoutTemplateStore(firestore, 'user_1');

      await store.saveTemplate(
        _template(
          id: 'template-a',
          name: 'A',
          updatedAt: DateTime.utc(2026, 2, 1),
          reps: 8,
        ),
      );
      await store.saveTemplate(
        _template(
          id: 'template-b',
          name: 'B',
          updatedAt: DateTime.utc(2026, 2, 2),
          reps: 10,
        ),
      );

      final loaded = await store.loadTemplates();

      expect(loaded.map((item) => item.id), ['template-b', 'template-a']);
      expect(loaded.first.entries.single.sets.single.reps, 10);
    });

    test('saveTemplate with same id overwrites existing template', () async {
      final firestore = FakeFirebaseFirestore();
      final store = FirestoreSavedWorkoutTemplateStore(firestore, 'user_1');

      await store.saveTemplate(
        _template(
          id: 'template-a',
          name: 'Old',
          updatedAt: DateTime.utc(2026, 2, 1),
          reps: 8,
        ),
      );
      await store.saveTemplate(
        _template(
          id: 'template-a',
          name: 'New',
          updatedAt: DateTime.utc(2026, 2, 3),
          reps: 12,
        ),
      );

      final loaded = await store.loadTemplates();

      expect(loaded.length, 1);
      expect(loaded.single.name, 'New');
      expect(loaded.single.entries.single.sets.single.reps, 12);
    });

    test('deleteTemplate removes template document', () async {
      final firestore = FakeFirebaseFirestore();
      final store = FirestoreSavedWorkoutTemplateStore(firestore, 'user_1');

      await store.saveTemplate(
        _template(
          id: 'template-a',
          name: 'Keep',
          updatedAt: DateTime.utc(2026, 2, 1),
          reps: 8,
        ),
      );
      await store.saveTemplate(
        _template(
          id: 'template-b',
          name: 'Remove',
          updatedAt: DateTime.utc(2026, 2, 2),
          reps: 10,
        ),
      );

      await store.deleteTemplate('template-b');
      final loaded = await store.loadTemplates();

      expect(loaded.length, 1);
      expect(loaded.single.id, 'template-a');
    });
  });
}

SavedWorkoutTemplate _template({
  required String id,
  required String name,
  required DateTime updatedAt,
  required int reps,
}) {
  return SavedWorkoutTemplate(
    id: id,
    name: name,
    status: SessionStatus.success,
    durationMinutes: 45,
    notes: 'Saved notes',
    entries: [
      SavedWorkoutEntryTemplate(
        exerciseTemplateId: 101,
        schemeType: SchemeType.standard,
        feltDifficulty: DifficultyLevel.moderate,
        sets: [SavedWorkoutSetTemplate(reps: reps)],
      ),
    ],
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: updatedAt,
  );
}
