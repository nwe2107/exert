import 'package:exert/app/auth_redirect.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redirects unauthenticated users to login from protected routes', () {
    final redirect = authRedirect(
      session: null,
      matchedLocation: todayRoutePath,
      isPersonalInfoKnown: false,
      hasCompletedPersonalInfo: false,
    );

    expect(redirect, loginRoutePath);
  });

  test('keeps unauthenticated users on login route', () {
    final redirect = authRedirect(
      session: null,
      matchedLocation: loginRoutePath,
      isPersonalInfoKnown: false,
      hasCompletedPersonalInfo: false,
    );

    expect(redirect, isNull);
  });

  test('redirects authenticated users with complete info away from login', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: loginRoutePath,
      isPersonalInfoKnown: true,
      hasCompletedPersonalInfo: true,
    );

    expect(redirect, todayRoutePath);
  });

  test('redirects authenticated users with incomplete info to onboarding', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: '/progress',
      isPersonalInfoKnown: true,
      hasCompletedPersonalInfo: false,
    );

    expect(redirect, getStartedRoutePath);
  });

  test('keeps authenticated users on protected routes after onboarding', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: '/progress',
      isPersonalInfoKnown: true,
      hasCompletedPersonalInfo: true,
    );

    expect(redirect, isNull);
  });

  test('keeps authenticated users on onboarding when not complete', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: getStartedRoutePath,
      isPersonalInfoKnown: true,
      hasCompletedPersonalInfo: false,
    );

    expect(redirect, isNull);
  });

  test('redirects authenticated users away from onboarding when complete', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: getStartedRoutePath,
      isPersonalInfoKnown: true,
      hasCompletedPersonalInfo: true,
    );

    expect(redirect, todayRoutePath);
  });

  test('does not redirect while personal info state is loading', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: '/progress',
      isPersonalInfoKnown: false,
      hasCompletedPersonalInfo: false,
    );

    expect(redirect, isNull);
  });
}
