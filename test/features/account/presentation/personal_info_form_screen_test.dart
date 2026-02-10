import 'dart:async';

import 'package:exert/application/app_providers.dart';
import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/features/account/presentation/personal_info_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('validates required and out-of-range fields before saving', (
    tester,
  ) async {
    final repository = _FakeUserProfileRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: PersonalInfoFormScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await _scrollToSaveButton(tester);
    await tester.tap(find.byKey(profileSaveButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Weight is required.'), findsOneWidget);
    expect(find.text('Height is required.'), findsOneWidget);
    expect(find.text('Age is required.'), findsOneWidget);
    expect(find.text('Gender is required.'), findsOneWidget);

    await tester.enterText(find.byKey(profileWeightFieldKey), '10');
    await tester.enterText(find.byKey(profileHeightFieldKey), '90');
    await tester.enterText(find.byKey(profileAgeFieldKey), '9');
    await tester.tap(find.byKey(profileGenderFieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await _scrollToSaveButton(tester);
    await tester.tap(find.byKey(profileSaveButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Weight must be between 20 and 500 kg.'), findsOneWidget);
    expect(find.text('Height must be between 100 and 260 cm.'), findsOneWidget);
    expect(find.text('Age must be between 13 and 120.'), findsOneWidget);
    expect(repository.lastSavedProfile, isNull);
  });

  testWidgets('saves valid profile data and supports editing existing values', (
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
        child: const MaterialApp(home: PersonalInfoFormScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('70'), findsOneWidget);
    expect(find.text('175'), findsOneWidget);
    expect(find.text('29'), findsOneWidget);

    await tester.enterText(find.byKey(profileWeightFieldKey), '72');
    await tester.enterText(find.byKey(profileHeightFieldKey), '176');
    await tester.enterText(find.byKey(profileAgeFieldKey), '30');
    await _scrollToSaveButton(tester);
    await tester.tap(find.byKey(profileSaveButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(repository.lastSavedProfile, isNotNull);
    expect(repository.lastSavedProfile!.weight, 72);
    expect(repository.lastSavedProfile!.height, 176);
    expect(repository.lastSavedProfile!.age, 30);
    expect(repository.lastSavedProfile!.gender, UserGender.male);
    expect(find.text('Personal information saved.'), findsOneWidget);
    expect(find.text('Saved successfully'), findsOneWidget);
  });
}

Future<void> _scrollToSaveButton(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byKey(profileSaveButtonKey),
    240,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

class _FakeUserProfileRepository implements UserProfileRepository {
  _FakeUserProfileRepository({UserProfileModel? initialProfile})
    : _profile = initialProfile;

  final StreamController<UserProfileModel?> _profileController =
      StreamController<UserProfileModel?>.broadcast();

  UserProfileModel? _profile;
  UserProfileModel? lastSavedProfile;

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
    lastSavedProfile = profile;
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
