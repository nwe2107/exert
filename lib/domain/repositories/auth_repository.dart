import '../models/auth_session.dart';

abstract class AuthRepository {
  AuthSession? get currentSession;

  Stream<AuthSession?> watchSession();

  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
