import 'dart:async';

import 'package:exert/application/app_providers.dart';
import 'package:exert/data/models/account_profile_model.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:exert/domain/repositories/account_profile_repository.dart';
import 'package:exert/features/account/presentation/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows incomplete profile prompt when profile is missing', (
    tester,
  ) async {
    final repository = _FakeAccountProfileRepository(initialProfile: null);
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountProfileRepositoryProvider.overrideWithValue(repository),
          authSessionProvider.overrideWith((ref) => Stream.value(_testSession)),
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status: Missing'), findsOneWidget);
    expect(find.text('Edit Account Profile'), findsOneWidget);
  });

  testWidgets('shows complete profile state and edit entry point', (
    tester,
  ) async {
    final repository = _FakeAccountProfileRepository(
      initialProfile: AccountProfileModel(
        uid: 'user_1',
        email: 'test@exert.app',
        displayName: 'Test User',
        onboardingComplete: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountProfileRepositoryProvider.overrideWithValue(repository),
          authSessionProvider.overrideWith((ref) => Stream.value(_testSession)),
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status: Loaded'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Edit Account Profile'), findsOneWidget);
  });
}

final _testSession = AuthSession(
  userId: 'user_1',
  email: 'test@exert.app',
  signedInAt: DateTime(2026, 2, 9),
);

class _FakeAccountProfileRepository implements AccountProfileRepository {
  _FakeAccountProfileRepository({AccountProfileModel? initialProfile})
    : _profile = initialProfile;

  final StreamController<AccountProfileModel?> _profileController =
      StreamController<AccountProfileModel?>.broadcast();
  AccountProfileModel? _profile;

  @override
  Stream<AccountProfileModel?> watchProfile(String uid) async* {
    yield _profile;
    yield* _profileController.stream;
  }

  @override
  Future<AccountProfileModel?> getProfile(String uid) async {
    return _profile;
  }

  @override
  Future<void> saveProfile(AccountProfileModel profile) async {
    _profile = profile;
    _profileController.add(profile);
  }

  @override
  Future<void> deleteProfile(String uid) async {
    _profile = null;
    _profileController.add(null);
  }

  void dispose() {
    _profileController.close();
  }
}
