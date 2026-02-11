import 'dart:async';

import 'package:exert/application/app_providers.dart';
import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/domain/repositories/user_profile_repository.dart';
import 'package:exert/features/onboarding/presentation/get_started_questionnaire_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('collects onboarding answers and saves profile', (tester) async {
    final repository = _FakeUserProfileRepository();
    addTearDown(repository.dispose);

    final router = GoRouter(
      initialLocation: '/get-started',
      routes: [
        GoRoute(
          path: '/get-started',
          builder: (context, state) => const GetStartedQuestionnaireScreen(),
        ),
        GoRoute(
          path: '/today',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Today placeholder'))),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(onboardingNextButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Gender is required.'), findsOneWidget);

    await tester.tap(find.byKey(onboardingGenderFieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(onboardingNextButtonKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(onboardingAgeFieldKey), '12');
    await tester.tap(find.byKey(onboardingNextButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Age must be between 13 and 120.'), findsOneWidget);

    await tester.enterText(find.byKey(onboardingAgeFieldKey), '30');
    await tester.tap(find.byKey(onboardingNextButtonKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(onboardingHeightFieldKey), '176');
    await tester.tap(find.byKey(onboardingNextButtonKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(onboardingWeightFieldKey), '75');
    await tester.tap(find.byKey(onboardingFinishButtonKey));
    await tester.pumpAndSettle();

    expect(repository.lastSavedProfile, isNotNull);
    expect(repository.lastSavedProfile!.gender, UserGender.male);
    expect(repository.lastSavedProfile!.age, 30);
    expect(repository.lastSavedProfile!.height, 176);
    expect(repository.lastSavedProfile!.weight, 75);
    expect(find.text('Today placeholder'), findsOneWidget);
  });
}

class _FakeUserProfileRepository implements UserProfileRepository {
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
    _profile = profile;
    lastSavedProfile = profile;
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
