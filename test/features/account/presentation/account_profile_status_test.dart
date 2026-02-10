import 'dart:async';

import 'package:exert/application/app_providers.dart';
import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/features/account/presentation/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows incomplete profile prompt when profile is missing', (
    tester,
  ) async {
    final repository = _FakeUserProfileRepository(initialProfile: null);
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status: Incomplete'), findsOneWidget);
    expect(find.text('Complete Personal Info'), findsOneWidget);
  });

  testWidgets('shows complete profile state and edit entry point', (
    tester,
  ) async {
    final repository = _FakeUserProfileRepository(
      initialProfile: UserProfileModel()
        ..weight = 70
        ..height = 175
        ..age = 29
        ..gender = UserGender.male
        ..weightUnit = WeightUnit.kg
        ..heightUnit = HeightUnit.cm
        ..createdAt = DateTime(2026, 1, 1)
        ..updatedAt = DateTime(2026, 1, 1),
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status: Complete'), findsOneWidget);
    expect(find.text('Edit Personal Info'), findsOneWidget);
  });
}

class _FakeUserProfileRepository implements UserProfileRepository {
  _FakeUserProfileRepository({UserProfileModel? initialProfile})
    : _profile = initialProfile;

  final StreamController<UserProfileModel?> _profileController =
      StreamController<UserProfileModel?>.broadcast();
  UserProfileModel? _profile;

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
    _profile = null;
    _profileController.add(null);
  }

  void dispose() {
    _profileController.close();
  }
}
