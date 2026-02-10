import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../core/utils/date_utils.dart';
import '../data/models/exercise_entry_model.dart';
import '../data/models/exercise_template_model.dart';
import '../data/models/user_profile_model.dart';
import '../data/models/workout_session_model.dart';
import '../data/repositories/in_memory_auth_repository.dart';
import '../data/repositories/isar_exercise_template_repository.dart';
import '../data/repositories/isar_user_profile_repository.dart';
import '../data/repositories/isar_workout_repository.dart';
import '../domain/models/auth_session.dart';
import '../domain/models/auth_status.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/exercise_template_repository.dart';
import '../domain/repositories/user_profile_repository.dart';
import '../domain/repositories/workout_repository.dart';
import '../domain/services/day_status_service.dart';
import '../domain/services/heatmap_service.dart';
import '../domain/services/progress_service.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden at startup.');
});

final exerciseTemplateRepositoryProvider = Provider<ExerciseTemplateRepository>(
  (ref) {
    return IsarExerciseTemplateRepository(ref.watch(isarProvider));
  },
);

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return IsarWorkoutRepository(ref.watch(isarProvider));
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return IsarUserProfileRepository(ref.watch(isarProvider));
});

final dayStatusServiceProvider = Provider<DayStatusService>((ref) {
  return DayStatusService();
});

final heatmapServiceProvider = Provider<HeatmapService>((ref) {
  return HeatmapService();
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

final todayProvider = Provider<DateTime>((ref) {
  return normalizeLocalDate(DateTime.now());
});

final allTemplatesProvider = StreamProvider<List<ExerciseTemplateModel>>((ref) {
  final repository = ref.watch(exerciseTemplateRepositoryProvider);
  return repository.watchAll();
});

final allSessionsProvider = StreamProvider<List<WorkoutSessionModel>>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.watchSessions();
});

final allEntriesProvider = StreamProvider<List<ExerciseEntryModel>>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.watchAllEntries();
});

final templatesByIdProvider =
    Provider<AsyncValue<Map<Id, ExerciseTemplateModel>>>((ref) {
      final templatesAsync = ref.watch(allTemplatesProvider);
      return templatesAsync.whenData((templates) {
        return {for (final template in templates) template.id: template};
      });
    });

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = InMemoryAuthRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final authSessionProvider = StreamProvider<AuthSession?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.watchSession();
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  final sessionAsync = ref.watch(authSessionProvider);
  return sessionAsync.when(
    data: (session) {
      return session == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
    },
    loading: () => AuthStatus.loading,
    error: (error, stackTrace) => AuthStatus.unauthenticated,
  );
});

final userProfileProvider = StreamProvider<UserProfileModel?>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchProfile();
});
