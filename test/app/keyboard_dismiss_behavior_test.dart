import 'package:exert/app/app.dart';
import 'package:exert/application/app_providers.dart';
import 'package:exert/application/theme_preference.dart';
import 'package:exert/data/local/theme_preference_store.dart';
import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:exert/domain/repositories/auth_repository.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping blank space dismisses focused text field', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _UnauthenticatedAuthRepository(),
          ),
          userProfileRepositoryProvider.overrideWithValue(
            const _EmptyUserProfileRepository(),
          ),
          themePreferenceStoreProvider.overrideWithValue(
            const _InMemoryThemePreferenceStore(),
          ),
        ],
        child: const ExertApp(),
      ),
    );
    await tester.pumpAndSettle();

    final emailField = find.byKey(loginEmailFieldKey);
    expect(emailField, findsOneWidget);

    await tester.tap(emailField);
    await tester.pumpAndSettle();

    final editableFinder = find.descendant(
      of: emailField,
      matching: find.byType(EditableText),
    );
    final editable = tester.widget<EditableText>(editableFinder);
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(editable.focusNode.hasFocus, isFalse);
  });

  testWidgets('dragging a scroll view dismisses keyboard focus', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _UnauthenticatedAuthRepository(),
          ),
          userProfileRepositoryProvider.overrideWithValue(
            const _EmptyUserProfileRepository(),
          ),
          themePreferenceStoreProvider.overrideWithValue(
            const _InMemoryThemePreferenceStore(),
          ),
        ],
        child: const ExertApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(loginSignUpModeButtonKey));
    await tester.pumpAndSettle();

    final passwordField = find.byKey(loginPasswordFieldKey);
    await tester.tap(passwordField);
    await tester.pumpAndSettle();

    final editableFinder = find.descendant(
      of: passwordField,
      matching: find.byType(EditableText),
    );
    final editable = tester.widget<EditableText>(editableFinder);
    expect(editable.focusNode.hasFocus, isTrue);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -220),
    );
    await tester.pumpAndSettle();

    expect(editable.focusNode.hasFocus, isFalse);
  });
}

class _UnauthenticatedAuthRepository implements AuthRepository {
  const _UnauthenticatedAuthRepository();

  @override
  AuthSession? get currentSession => null;

  @override
  Stream<AuthSession?> watchSession() {
    return Stream<AuthSession?>.value(null);
  }

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount({String? password}) async {}

  @override
  Future<void> signOut() async {}
}

class _EmptyUserProfileRepository implements UserProfileRepository {
  const _EmptyUserProfileRepository();

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
  Future<void> clearProfile() async {}
}

class _InMemoryThemePreferenceStore implements ThemePreferenceStore {
  const _InMemoryThemePreferenceStore();

  @override
  Future<ThemePreference> loadPreference() async {
    return ThemePreference.timeOfDay;
  }

  @override
  Future<void> savePreference(ThemePreference preference) async {}
}
