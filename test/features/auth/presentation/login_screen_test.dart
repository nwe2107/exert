import 'dart:async';

import 'package:exert/application/app_providers.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:exert/domain/repositories/auth_repository.dart';
import 'package:exert/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows failure message for invalid credentials', (tester) async {
    final repository = _FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.byKey(loginEmailFieldKey), 'demo@exert.app');
    await tester.enterText(find.byKey(loginPasswordFieldKey), 'wrong-password');
    await tester.tap(find.byKey(loginSubmitButtonKey));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Invalid email or password.'), findsOneWidget);
    expect(repository.currentSession, isNull);
  });

  testWidgets('signs in and clears error state on valid credentials', (
    tester,
  ) async {
    final repository = _FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.enterText(find.byKey(loginEmailFieldKey), 'wrong@example.com');
    await tester.enterText(find.byKey(loginPasswordFieldKey), 'wrong-password');
    await tester.tap(find.byKey(loginSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget);

    await tester.enterText(find.byKey(loginEmailFieldKey), 'demo@exert.app');
    await tester.enterText(find.byKey(loginPasswordFieldKey), 'exert1234');
    await tester.tap(find.byKey(loginSubmitButtonKey));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsNothing);
    expect(repository.currentSession, isNotNull);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository();

  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _currentSession;

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  Stream<AuthSession?> watchSession() async* {
    yield _currentSession;
    yield* _sessionController.stream;
  }

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (email.trim().toLowerCase() != 'demo@exert.app' ||
        password.trim() != 'exert1234') {
      throw const AuthException('Invalid email or password.');
    }

    final session = AuthSession(
      userId: 'fake-user',
      email: email.trim().toLowerCase(),
      signedInAt: DateTime.now(),
    );
    _currentSession = session;
    _sessionController.add(session);
    return session;
  }

  @override
  Future<void> deleteAccount() async {
    _currentSession = null;
    _sessionController.add(null);
  }

  @override
  Future<void> signOut() async {
    _currentSession = null;
    _sessionController.add(null);
  }

  void dispose() {
    _sessionController.close();
  }
}
