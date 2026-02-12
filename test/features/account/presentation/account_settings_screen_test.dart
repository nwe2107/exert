import 'dart:async';

import 'package:exert/app/app.dart';
import 'package:exert/application/app_providers.dart';
import 'package:exert/application/theme_preference.dart';
import 'package:exert/data/local/theme_preference_store.dart';
import 'package:exert/data/models/exercise_entry_model.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:exert/domain/repositories/auth_repository.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/domain/repositories/workout_repository.dart';
import 'package:exert/features/account/presentation/account_screen.dart';
import 'package:exert/features/account/presentation/account_settings_screen.dart';
import 'package:exert/features/auth/presentation/login_screen.dart';
import 'package:exert/features/today/presentation/today_screen.dart';
import 'package:exert/features/workout/presentation/workout_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

void main() {
  testWidgets('canceling delete keeps account session and local data intact', (
    tester,
  ) async {
    final authRepository = _TestAuthRepository();
    final workoutRepository = _FakeWorkoutRepository();
    final userProfileRepository = _FakeUserProfileRepository();
    addTearDown(authRepository.dispose);
    addTearDown(userProfileRepository.dispose);

    await _pumpAuthenticatedApp(
      tester,
      authRepository: authRepository,
      workoutRepository: workoutRepository,
      userProfileRepository: userProfileRepository,
    );
    await _openSettingsFromToday(tester);

    await tester.tap(find.byKey(settingsDeleteAccountButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'This action is permanent and cannot be undone. Your account will be deleted and local workout data on this device will be removed.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(settingsDeleteAccountCancelKey));
    await tester.pumpAndSettle();

    expect(authRepository.deleteAccountCallCount, 0);
    expect(workoutRepository.clearAllUserDataCallCount, 0);
    expect(userProfileRepository.clearProfileCallCount, 0);
    expect(authRepository.currentSession, isNotNull);
    expect(find.byKey(settingsDeleteAccountButtonKey), findsOneWidget);
  });

  testWidgets('signing out routes back to login without deleting data', (
    tester,
  ) async {
    final authRepository = _TestAuthRepository();
    final workoutRepository = _FakeWorkoutRepository();
    final userProfileRepository = _FakeUserProfileRepository();
    addTearDown(authRepository.dispose);
    addTearDown(userProfileRepository.dispose);

    await _pumpAuthenticatedApp(
      tester,
      authRepository: authRepository,
      workoutRepository: workoutRepository,
      userProfileRepository: userProfileRepository,
    );
    await _openSettingsFromToday(tester);

    await tester.tap(find.byKey(settingsSignOutButtonKey));
    await tester.pumpAndSettle();

    expect(authRepository.signOutCallCount, 1);
    expect(authRepository.currentSession, isNull);
    expect(workoutRepository.clearAllUserDataCallCount, 0);
    expect(userProfileRepository.clearProfileCallCount, 0);
    expect(find.byKey(loginSubmitButtonKey), findsOneWidget);
  });

  testWidgets(
    'confirming delete removes account, clears user data, and routes to login',
    (tester) async {
      final authRepository = _TestAuthRepository();
      final workoutRepository = _FakeWorkoutRepository();
      final userProfileRepository = _FakeUserProfileRepository();
      addTearDown(authRepository.dispose);
      addTearDown(userProfileRepository.dispose);

      await _pumpAuthenticatedApp(
        tester,
        authRepository: authRepository,
        workoutRepository: workoutRepository,
        userProfileRepository: userProfileRepository,
      );
      await _openSettingsFromToday(tester);

      await tester.tap(find.byKey(settingsDeleteAccountButtonKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(settingsDeleteAccountConfirmKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'password');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(authRepository.deleteAccountCallCount, 1);
      expect(workoutRepository.clearAllUserDataCallCount, 1);
      expect(userProfileRepository.clearProfileCallCount, 1);
      expect(authRepository.currentSession, isNull);
      expect(find.byKey(loginSubmitButtonKey), findsOneWidget);
    },
  );

  testWidgets('delete failure shows error and keeps account/data intact', (
    tester,
  ) async {
    final authRepository = _TestAuthRepository(
      deleteError: const AuthException('Delete account failed.'),
    );
    final workoutRepository = _FakeWorkoutRepository();
    final userProfileRepository = _FakeUserProfileRepository();
    addTearDown(authRepository.dispose);
    addTearDown(userProfileRepository.dispose);

    await _pumpAuthenticatedApp(
      tester,
      authRepository: authRepository,
      workoutRepository: workoutRepository,
      userProfileRepository: userProfileRepository,
    );
    await _openSettingsFromToday(tester);

    await tester.tap(find.byKey(settingsDeleteAccountButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(settingsDeleteAccountConfirmKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(authRepository.deleteAccountCallCount, 1);
    expect(workoutRepository.clearAllUserDataCallCount, 0);
    expect(userProfileRepository.clearProfileCallCount, 0);
    expect(authRepository.currentSession, isNotNull);
    expect(find.text('Delete account failed.'), findsOneWidget);
    expect(find.byKey(settingsDeleteAccountButtonKey), findsOneWidget);
    expect(find.byKey(loginSubmitButtonKey), findsNothing);
  });

  testWidgets('theme toggle switches between dark/light/time of day', (
    tester,
  ) async {
    final authRepository = _TestAuthRepository();
    final workoutRepository = _FakeWorkoutRepository();
    final userProfileRepository = _FakeUserProfileRepository();
    final themeStore = _InMemoryThemePreferenceStore(ThemePreference.timeOfDay);
    addTearDown(authRepository.dispose);
    addTearDown(userProfileRepository.dispose);

    await _pumpAuthenticatedApp(
      tester,
      authRepository: authRepository,
      workoutRepository: workoutRepository,
      userProfileRepository: userProfileRepository,
      themePreferenceStore: themeStore,
    );
    await _openSettingsFromToday(tester);

    expect(find.byKey(settingsThemeToggleKey), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(_currentThemeMode(tester), ThemeMode.dark);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(_currentThemeMode(tester), ThemeMode.light);

    await tester.tap(find.text('Time of day'));
    await tester.pumpAndSettle();
    expect(_currentThemeMode(tester), _expectedTimeOfDayThemeMode());
  });
}

Future<void> _pumpAuthenticatedApp(
  WidgetTester tester, {
  required _TestAuthRepository authRepository,
  required _FakeWorkoutRepository workoutRepository,
  required _FakeUserProfileRepository userProfileRepository,
  ThemePreferenceStore themePreferenceStore =
      const _InMemoryThemePreferenceStore(),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        workoutRepositoryProvider.overrideWithValue(workoutRepository),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepository),
        themePreferenceStoreProvider.overrideWithValue(themePreferenceStore),
        todayProvider.overrideWithValue(DateTime(2026, 2, 9)),
        allSessionsProvider.overrideWith(
          (ref) => Stream.value(<WorkoutSessionModel>[]),
        ),
        allTemplatesProvider.overrideWith(
          (ref) => Stream.value(<ExerciseTemplateModel>[]),
        ),
        allEntriesProvider.overrideWith(
          (ref) => Stream.value(<ExerciseEntryModel>[]),
        ),
        sessionForDateProvider.overrideWith(
          (ref, date) => Stream<WorkoutSessionModel?>.value(null),
        ),
      ],
      child: const ExertApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openSettingsFromToday(WidgetTester tester) async {
  await tester.tap(find.byKey(todayAccountButtonKey));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(accountSettingsButtonKey));
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(settingsDeleteAccountButtonKey),
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();

  expect(find.byKey(settingsDeleteAccountButtonKey), findsOneWidget);
}

ThemeMode _currentThemeMode(WidgetTester tester) {
  final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
  return app.themeMode ?? ThemeMode.system;
}

ThemeMode _expectedTimeOfDayThemeMode() {
  return resolveThemeModeForPreference(
    ThemePreference.timeOfDay,
    DateTime.now(),
  );
}

class _TestAuthRepository implements AuthRepository {
  _TestAuthRepository({this.deleteError})
    : _session = AuthSession(
        userId: 'test-user',
        email: 'test@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      );

  final AuthException? deleteError;
  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _session;
  int deleteAccountCallCount = 0;
  int signOutCallCount = 0;

  @override
  AuthSession? get currentSession => _session;

  @override
  Stream<AuthSession?> watchSession() async* {
    yield _session;
    yield* _sessionController.stream;
  }

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _session!;
  }

  @override
  Future<AuthSession> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _session!;
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    deleteAccountCallCount += 1;

    if (deleteError != null) {
      throw deleteError!;
    }

    _session = null;
    _sessionController.add(null);
  }

  @override
  Future<void> signOut() async {
    signOutCallCount += 1;
    _session = null;
    _sessionController.add(null);
  }

  void dispose() {
    _sessionController.close();
  }
}

class _FakeWorkoutRepository implements WorkoutRepository {
  int clearAllUserDataCallCount = 0;

  @override
  Stream<List<WorkoutSessionModel>> watchSessions() {
    return Stream.value(const <WorkoutSessionModel>[]);
  }

  @override
  Stream<List<WorkoutSessionModel>> watchSessionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return Stream.value(const <WorkoutSessionModel>[]);
  }

  @override
  Future<List<WorkoutSessionModel>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return const <WorkoutSessionModel>[];
  }

  @override
  Future<WorkoutSessionModel?> getSessionByDate(DateTime date) async {
    return null;
  }

  @override
  Stream<WorkoutSessionModel?> watchSessionByDate(DateTime date) {
    return Stream<WorkoutSessionModel?>.value(null);
  }

  @override
  Future<Id> saveSession(WorkoutSessionModel session) async {
    return session.id;
  }

  @override
  Future<void> deleteSession(Id sessionId) async {}

  @override
  Stream<List<ExerciseEntryModel>> watchEntriesForSession(Id sessionId) {
    return Stream.value(const <ExerciseEntryModel>[]);
  }

  @override
  Future<List<ExerciseEntryModel>> getEntriesForSession(Id sessionId) async {
    return const <ExerciseEntryModel>[];
  }

  @override
  Stream<List<ExerciseEntryModel>> watchAllEntries() {
    return Stream.value(const <ExerciseEntryModel>[]);
  }

  @override
  Future<List<ExerciseEntryModel>> getAllEntries() async {
    return const <ExerciseEntryModel>[];
  }

  @override
  Future<Id> saveEntry(ExerciseEntryModel entry) async {
    return entry.id;
  }

  @override
  Future<void> deleteEntry(Id entryId) async {}

  @override
  Future<void> deleteEntriesForSession(Id sessionId) async {}

  @override
  Future<void> clearAllUserData() async {
    clearAllUserDataCallCount += 1;
  }
}

class _FakeUserProfileRepository implements UserProfileRepository {
  final StreamController<UserProfileModel?> _profileController =
      StreamController<UserProfileModel?>.broadcast();
  UserProfileModel? _profile = UserProfileModel()
    ..age = 30
    ..height = 178
    ..weight = 80
    ..gender = UserGender.male;

  int clearProfileCallCount = 0;

  @override
  Stream<UserProfileModel?> watchProfile() async* {
    yield _profile;
    yield* _profileController.stream;
  }

  @override
  Future<UserProfileModel?> getProfile() async {
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    _profile = profile;
    _profileController.add(profile);
  }

  @override
  Future<void> clearProfile() async {
    clearProfileCallCount += 1;
    _profile = null;
    _profileController.add(null);
  }

  void dispose() {
    _profileController.close();
  }
}

class _InMemoryThemePreferenceStore implements ThemePreferenceStore {
  const _InMemoryThemePreferenceStore([
    this._preference = ThemePreference.timeOfDay,
  ]);

  final ThemePreference _preference;

  @override
  Future<ThemePreference> loadPreference() async {
    return _preference;
  }

  @override
  Future<void> savePreference(ThemePreference preference) async {}
}
