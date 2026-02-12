import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';

import 'theme_preference.dart';
import '../core/utils/date_utils.dart';
import '../data/local/theme_preference_store.dart';
import '../data/models/account_profile_model.dart';
import '../data/models/exercise_entry_model.dart';
import '../data/models/exercise_template_model.dart';
import '../data/models/user_profile_model.dart';
import '../data/models/workout_session_model.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/in_memory_auth_repository.dart';
import '../data/repositories/isar_exercise_template_repository.dart';
import '../data/repositories/isar_user_profile_repository.dart';
import '../data/repositories/isar_workout_repository.dart';
import '../data/repositories/firestore_exercise_template_repository.dart';
import '../data/repositories/firestore_workout_repository.dart';
import '../data/repositories/firestore_account_profile_repository.dart';
import '../data/repositories/in_memory_account_profile_repository.dart';
import '../domain/models/auth_session.dart';
import '../domain/models/auth_status.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/exercise_template_repository.dart';
import '../domain/repositories/account_profile_repository.dart';
import '../domain/repositories/user_profile_repository.dart';
import '../domain/repositories/workout_repository.dart';
import '../domain/services/day_status_service.dart';
import '../domain/services/heatmap_service.dart';
import '../domain/services/progress_service.dart';
import '../data/seeding/seed_service.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden at startup.');
});

final firebaseAppProvider = Provider<FirebaseApp?>((ref) {
  return null;
});

final exerciseTemplateRepositoryProvider = Provider<ExerciseTemplateRepository>(
  (ref) {
    final firebaseApp = ref.watch(firebaseAppProvider);
    final session = ref.watch(authSessionProvider).value;
    final firebaseUser = firebaseApp != null
        ? FirebaseAuth.instanceFor(app: firebaseApp).currentUser
        : null;

    final userId = session?.userId ?? firebaseUser?.uid;

    if (firebaseApp != null && userId != null) {
      return FirestoreExerciseTemplateRepository(
        FirebaseFirestore.instanceFor(app: firebaseApp),
        userId,
      );
    }

    return IsarExerciseTemplateRepository(ref.watch(isarProvider));
  },
);

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final firebaseApp = ref.watch(firebaseAppProvider);
  final session = ref.watch(authSessionProvider).value;
  final firebaseUser = firebaseApp != null
      ? FirebaseAuth.instanceFor(app: firebaseApp).currentUser
      : null;

  final userId = session?.userId ?? firebaseUser?.uid;

  if (firebaseApp != null && userId != null) {
    return FirestoreWorkoutRepository(
      FirebaseFirestore.instanceFor(app: firebaseApp),
      userId,
    );
  }

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

final themePreferenceStoreProvider = Provider<ThemePreferenceStore>((ref) {
  return FileThemePreferenceStore();
});

final themePreferenceProvider =
    AsyncNotifierProvider<ThemePreferenceNotifier, ThemePreference>(
      ThemePreferenceNotifier.new,
    );

class ThemePreferenceNotifier extends AsyncNotifier<ThemePreference> {
  @override
  Future<ThemePreference> build() async {
    return ref.read(themePreferenceStoreProvider).loadPreference();
  }

  Future<void> setPreference(ThemePreference preference) async {
    final previousPreference = state.valueOrNull ?? ThemePreference.timeOfDay;
    state = AsyncData(preference);

    try {
      await ref.read(themePreferenceStoreProvider).savePreference(preference);
    } catch (_) {
      state = AsyncData(previousPreference);
      rethrow;
    }
  }
}

final themeClockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream<DateTime>.periodic(
    const Duration(minutes: 1),
    (_) => DateTime.now(),
  );
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final preference =
      ref.watch(themePreferenceProvider).valueOrNull ??
      ThemePreference.timeOfDay;
  final now = ref.watch(themeClockProvider).valueOrNull ?? DateTime.now();
  return resolveThemeModeForPreference(preference, now);
});

final allTemplatesProvider = StreamProvider<List<ExerciseTemplateModel>>((ref) {
  final firebaseApp = ref.watch(firebaseAppProvider);
  final sessionAsync = ref.watch(authSessionProvider);
  final repository = ref.watch(exerciseTemplateRepositoryProvider);

  return sessionAsync.when(
    data: (session) {
      if (firebaseApp != null && session != null) {
        final firestoreRepo = FirestoreExerciseTemplateRepository(
          FirebaseFirestore.instanceFor(app: firebaseApp),
          session.userId,
        );
        return firestoreRepo.watchAll();
      }
      return repository.watchAll();
    },
    loading: () => const Stream<List<ExerciseTemplateModel>>.empty(),
    error: (_, _) => repository.watchAll(),
  );
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
  final firebaseApp = ref.watch(firebaseAppProvider);
  if (firebaseApp != null) {
    return FirebaseAuthRepository(
      firebaseAuth: FirebaseAuth.instanceFor(app: firebaseApp),
      firestore: FirebaseFirestore.instanceFor(app: firebaseApp),
    );
  }

  final fallbackRepository = InMemoryAuthRepository();
  ref.onDispose(fallbackRepository.dispose);
  return fallbackRepository;
});

final authSessionProvider = StreamProvider<AuthSession?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.watchSession();
});

/// Ensure default exercises are seeded for the authenticated user.
/// Safe to call repeatedly; SeedService skips if names already exist.
final ensureExerciseSeededProvider = FutureProvider<void>((ref) async {
  final firebaseApp = ref.watch(firebaseAppProvider);
  final session = ref.watch(authSessionProvider).value;
  final firebaseUser = firebaseApp != null
      ? FirebaseAuth.instanceFor(app: firebaseApp).currentUser
      : null;
  final userId = session?.userId ?? firebaseUser?.uid;

  if (userId == null) {
    return;
  }
  final repo = ref.read(exerciseTemplateRepositoryProvider);
  await SeedService(repo).seedIfNeeded();
});

final accountProfileRepositoryProvider = Provider<AccountProfileRepository>((
  ref,
) {
  final firebaseApp = ref.watch(firebaseAppProvider);
  if (firebaseApp != null) {
    return FirestoreAccountProfileRepository(
      FirebaseFirestore.instanceFor(app: firebaseApp),
    );
  }
  return InMemoryAccountProfileRepository();
});

final accountProfileProvider = StreamProvider<AccountProfileModel?>((ref) {
  final repository = ref.watch(accountProfileRepositoryProvider);
  final sessionAsync = ref.watch(authSessionProvider);

  return sessionAsync.when(
    data: (session) {
      if (session == null) {
        return Stream<AccountProfileModel?>.value(null);
      }
      return repository.watchProfile(session.userId);
    },
    loading: () => Stream<AccountProfileModel?>.value(null),
    error: (_, _) => Stream<AccountProfileModel?>.value(null),
  );
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

final usingFirebaseAuthProvider = Provider<bool>((ref) {
  return ref.watch(firebaseAppProvider) != null;
});

final userProfileProvider = StreamProvider<UserProfileModel?>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return repository.watchProfile();
});
