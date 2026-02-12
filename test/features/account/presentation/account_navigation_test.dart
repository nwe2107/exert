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
import 'package:exert/domain/repositories/account_profile_repository.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/data/models/account_profile_model.dart';
import 'package:exert/features/account/presentation/account_screen.dart';
import 'package:exert/features/account/presentation/account_settings_screen.dart';
import 'package:exert/features/account/presentation/account_profile_form_screen.dart';
import 'package:exert/features/today/presentation/today_screen.dart';
import 'package:exert/features/workout/presentation/workout_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets(
    'navigates Today -> Account -> Profile/Settings and returns to Today',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _AuthenticatedAuthRepository(),
            ),
            accountProfileRepositoryProvider.overrideWithValue(
              _FakeAccountProfileRepository(),
            ),
            userProfileRepositoryProvider.overrideWithValue(
              _FakeUserProfileRepository(),
            ),
            themePreferenceStoreProvider.overrideWithValue(
              const _InMemoryThemePreferenceStore(),
            ),
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

      final todayAccountButton = find.byKey(todayAccountButtonKey);
      expect(todayAccountButton, findsOneWidget);

      await tester.tap(todayAccountButton);
      await tester.pumpAndSettle();

      final profileButton = find.byKey(accountProfileButtonKey);
      expect(profileButton, findsOneWidget);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();
      expect(find.byKey(accountProfileSaveButtonKey), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      final settingsButton = find.byKey(accountSettingsButtonKey);
      expect(settingsButton, findsOneWidget);

      await tester.tap(settingsButton);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(settingsDeleteAccountButtonKey),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(settingsDeleteAccountButtonKey), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      final backToTodayButton = find.byKey(accountBackButtonKey);
      expect(backToTodayButton, findsOneWidget);
      await tester.tap(backToTodayButton);
      await tester.pumpAndSettle();

      expect(find.byKey(todayAccountButtonKey), findsOneWidget);
      expect(find.byKey(settingsDeleteAccountButtonKey), findsNothing);
    },
  );
}

class _AuthenticatedAuthRepository implements AuthRepository {
  _AuthenticatedAuthRepository()
    : _session = AuthSession(
        userId: 'test-user',
        email: 'test@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      );

  final AuthSession _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  Stream<AuthSession?> watchSession() => Stream<AuthSession?>.value(_session);

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _session;
  }

  @override
  Future<AuthSession> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _session;
  }

  @override
  Future<void> deleteAccount({String? password}) async {}

  @override
  Future<void> signOut() async {}
}

class _FakeAccountProfileRepository implements AccountProfileRepository {
  @override
  Stream<AccountProfileModel?> watchProfile(String uid) {
    return Stream<AccountProfileModel?>.value(
      AccountProfileModel(
        uid: uid,
        email: 'test@exert.app',
        displayName: 'Test User',
        onboardingComplete: true,
        createdAt: DateTime(2026, 2, 1),
        updatedAt: DateTime(2026, 2, 1),
      ),
    );
  }

  @override
  Future<AccountProfileModel?> getProfile(String uid) async {
    return AccountProfileModel(
      uid: uid,
      email: 'test@exert.app',
      displayName: 'Test User',
      onboardingComplete: true,
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 2, 1),
    );
  }

  @override
  Future<void> saveProfile(AccountProfileModel profile) async {}

  @override
  Future<void> deleteProfile(String uid) async {}
}

class _FakeUserProfileRepository implements UserProfileRepository {
  final UserProfileModel _profile = UserProfileModel()
    ..age = 30
    ..height = 175
    ..weight = 75
    ..gender = UserGender.male;

  @override
  Stream<UserProfileModel?> watchProfile() {
    return Stream<UserProfileModel?>.value(_profile);
  }

  @override
  Future<UserProfileModel?> getProfile() async {
    return _profile;
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {}

  @override
  Future<void> clearProfile() async {}
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
