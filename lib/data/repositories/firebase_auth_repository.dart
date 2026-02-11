import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  AuthSession? get currentSession => _mapUser(_firebaseAuth.currentUser);

  @override
  Stream<AuthSession?> watchSession() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('Sign in failed. Please try again.');
      }

      await _upsertUserAccount(user);
      return _mapUser(user)!;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseAuthError(error));
    } catch (_) {
      throw const AuthException('Sign in failed. Please try again.');
    }
  }

  @override
  Future<AuthSession> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException('Sign up failed. Please try again.');
      }

      await _upsertUserAccount(user);
      return _mapUser(user)!;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseAuthError(error));
    } catch (_) {
      throw const AuthException('Sign up failed. Please try again.');
    }
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException('No active account to delete.');
    }

    try {
      // Attempt delete directly; if recent auth is required we handle below.
      await user.delete();
      await _firestore.collection('users').doc(user.uid).delete();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        if (password == null || (user.email ?? '').isEmpty) {
          throw const AuthException(
            'Please re-enter your password to delete your account.',
          );
        }

        try {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
          await user.delete();
          await _firestore.collection('users').doc(user.uid).delete();
        } on FirebaseAuthException catch (reauthError) {
          throw AuthException(_mapFirebaseAuthError(reauthError));
        }
      } else {
        throw AuthException(_mapFirebaseAuthError(error));
      }
    } catch (_) {
      throw const AuthException('Failed to delete account. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _upsertUserAccount(User user) async {
    final now = FieldValue.serverTimestamp();
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDocRef.get();
    final data = <String, Object?>{
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'updatedAt': now,
    };

    if (!snapshot.exists) {
      data['onboardingComplete'] = false;
      data['createdAt'] = now;
    }

    await userDocRef.set(data, SetOptions(merge: true));
  }

  AuthSession? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthSession(
      userId: user.uid,
      email: user.email ?? '',
      signedInAt: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'invalid-email':
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'requires-recent-login':
        return 'Please sign in again before deleting your account.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
