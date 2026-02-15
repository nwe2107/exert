import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../application/app_providers.dart';
import '../../../data/local/saved_workout_template_store.dart';
import '../../../data/models/exercise_entry_model.dart';
import '../../../data/models/workout_session_model.dart';

final sessionForDateProvider =
    StreamProvider.family<WorkoutSessionModel?, DateTime>((ref, date) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchSessionByDate(date);
    });

final entriesForSessionProvider =
    StreamProvider.family<List<ExerciseEntryModel>, Id>((ref, sessionId) {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.watchEntriesForSession(sessionId);
    });

final entriesForDateProvider =
    FutureProvider.family<List<ExerciseEntryModel>, DateTime>((
      ref,
      date,
    ) async {
      final session = await ref.watch(sessionForDateProvider(date).future);
      if (session == null) {
        return const [];
      }

      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getEntriesForSession(session.id);
    });

final savedWorkoutTemplatesProvider =
    FutureProvider<List<SavedWorkoutTemplate>>((ref) {
      final store = ref.watch(savedWorkoutTemplateStoreProvider);
      return store.loadTemplates();
    });
