import 'dart:async';

import 'package:exert/app/app.dart';
import 'package:exert/application/app_providers.dart';
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

  testWidgets(
    'confirming delete removes account, clears user data, and routes to login',
    (tester) async {
      final authRepository = _TestAuthRepository();
      final workoutRepository = _FakeWorkoutRepository();
      final userProfileRepository = _FakeUserProfileRepository();
      addTearDown(authRepository.dispose);

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
}

Future<void> _pumpAuthenticatedApp(
  WidgetTester tester, {
  required _TestAuthRepository authRepository,
  required _FakeWorkoutRepository workoutRepository,
  required _FakeUserProfileRepository userProfileRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        workoutRepositoryProvider.overrideWithValue(workoutRepository),
        userProfileRepositoryProvider.overrideWithValue(userProfileRepository),
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

  expect(find.byKey(settingsDeleteAccountButtonKey), findsOneWidget);
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
  Future<void> deleteAccount() async {
    deleteAccountCallCount += 1;

    if (deleteError != null) {
      throw deleteError!;
    }

    _session = null;
    _sessionController.add(null);
  }

  @override
  Future<void> signOut() async {
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
  int clearProfileCallCount = 0;

  @override
  Stream<UserProfileModel?> watchProfile() {
    return Stream<UserProfileModel?>.value(null);
  }

  @override
  Future<UserProfileModel?> getProfile() async {
    return null;
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {}

  @override
  Future<void> clearProfile() async {
    clearProfileCallCount += 1;
  }
}
