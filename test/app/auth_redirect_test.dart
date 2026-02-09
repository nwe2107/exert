import 'package:exert/app/auth_redirect.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redirects unauthenticated users to login from protected routes', () {
    final redirect = authRedirect(
      session: null,
      matchedLocation: todayRoutePath,
    );

    expect(redirect, loginRoutePath);
  });

  test('keeps unauthenticated users on login route', () {
    final redirect = authRedirect(
      session: null,
      matchedLocation: loginRoutePath,
    );

    expect(redirect, isNull);
  });

  test('redirects authenticated users away from login route', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: loginRoutePath,
    );

    expect(redirect, todayRoutePath);
  });

  test('keeps authenticated users on protected routes', () {
    final redirect = authRedirect(
      session: AuthSession(
        userId: 'user-1',
        email: 'demo@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      ),
      matchedLocation: '/progress',
    );

    expect(redirect, isNull);
  });
}
