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

    if (normalizedEmail != demoEmail || normalizedPassword != demoPassword) {
      throw const AuthException('Invalid email or password.');
    }

    final session = AuthSession(
      userId: 'demo-user',
      email: demoEmail,
      signedInAt: DateTime.now(),
    );
    _currentSession = session;
    _sessionController.add(session);
    return session;
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
