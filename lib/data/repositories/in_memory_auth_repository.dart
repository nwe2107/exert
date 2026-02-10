import 'dart:async';

import '../../domain/models/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository();

  static const String demoEmail = 'demo@exert.app';
  static const String demoPassword = 'exert1234';

  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _currentSession;
  final Map<String, _InMemoryAuthAccount> _accountsByEmail = {
    demoEmail: const _InMemoryAuthAccount(
      userId: 'demo-user',
      email: demoEmail,
      password: demoPassword,
    ),
  };
  int _nextLocalUserNumber = 1;

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
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    final account = _accountsByEmail[normalizedEmail];
    if (account == null || account.password != normalizedPassword) {
      throw const AuthException('Invalid email or password.');
    }

    final session = AuthSession(
      userId: account.userId,
      email: account.email,
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
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw const AuthException('Enter a valid email.');
    }

    if (normalizedPassword.length < 6) {
      throw const AuthException('Password should be at least 6 characters.');
    }

    if (_accountsByEmail.containsKey(normalizedEmail)) {
      throw const AuthException('An account already exists for this email.');
    }

    final account = _InMemoryAuthAccount(
      userId: 'local-user-${_nextLocalUserNumber++}',
      email: normalizedEmail,
      password: normalizedPassword,
    );
    _accountsByEmail[normalizedEmail] = account;

    final session = AuthSession(
      userId: account.userId,
      email: account.email,
      signedInAt: DateTime.now(),
    );
    _currentSession = session;
    _sessionController.add(session);
    return session;
  }

  @override
  Future<void> deleteAccount() async {
    if (_currentSession == null) {
      throw const AuthException('No active account to delete.');
    }

    _accountsByEmail.remove(_currentSession!.email.toLowerCase());
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

class _InMemoryAuthAccount {
  const _InMemoryAuthAccount({
    required this.userId,
    required this.email,
    required this.password,
  });

  final String userId;
  final String email;
  final String password;
}
