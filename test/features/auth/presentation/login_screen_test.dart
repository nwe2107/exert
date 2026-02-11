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

  testWidgets('creates account from sign up mode', (tester) async {
    final repository = _FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.tap(find.byKey(loginSignUpModeButtonKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(loginEmailFieldKey), 'new@exert.app');
    await tester.enterText(find.byKey(loginPasswordFieldKey), 'newpass123');
    await tester.enterText(
      find.byKey(loginConfirmPasswordFieldKey),
      'newpass123',
    );
    await tester.tap(find.byKey(loginSubmitButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.text('An account already exists for this email.'),
      findsNothing,
    );
    expect(repository.currentSession?.email, 'new@exert.app');
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository();

  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _currentSession;
  final Map<String, String> _accounts = {'demo@exert.app': 'exert1234'};

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

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();
    final storedPassword = _accounts[normalizedEmail];
    if (storedPassword == null || storedPassword != normalizedPassword) {
      throw const AuthException('Invalid email or password.');
    }

    final session = AuthSession(
      userId: 'fake-user',
      email: normalizedEmail,
      signedInAt: DateTime.now(),
    );
    _currentSession = session;
    _sessionController.add(session);
    return session;
  }

  @override
  Future<AuthSession> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (_accounts.containsKey(normalizedEmail)) {
      throw const AuthException('An account already exists for this email.');
    }
    if (normalizedPassword.length < 6) {
      throw const AuthException('Password should be at least 6 characters.');
    }

    _accounts[normalizedEmail] = normalizedPassword;
    final session = AuthSession(
      userId: 'fake-user-signup',
      email: normalizedEmail,
      signedInAt: DateTime.now(),
    );
    _currentSession = session;
    _sessionController.add(session);
    return session;
  }

  @override
  Future<void> deleteAccount({String? password}) async {
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
