import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repositories/account_profile_repository.dart';
import '../models/account_profile_model.dart';

class FirestoreAccountProfileRepository implements AccountProfileRepository {
  FirestoreAccountProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Stream<AccountProfileModel?> watchProfile(String uid) {
    final docRef = _usersCollection.doc(uid);
    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return AccountProfileModel.fromDocument(snapshot);
    });
  }

  @override
  Future<AccountProfileModel?> getProfile(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return AccountProfileModel.fromDocument(snapshot);
  }

  @override
  Future<void> saveProfile(AccountProfileModel profile) async {
    try {
      final docRef = _usersCollection.doc(profile.uid);
      final snapshot = await docRef.get();

      final data = {
        'uid': profile.uid,
        'email': profile.email,
        'displayName': profile.displayName,
        'onboardingComplete': profile.onboardingComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!snapshot.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }

      await docRef.set(data, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw AccountProfileException(error.message ?? 'Profile update failed.');
    } catch (_) {
      throw const AccountProfileException('Profile update failed.');
    }
  }

  @override
  Future<void> deleteProfile(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } on FirebaseException catch (error) {
      throw AccountProfileException(error.message ?? 'Profile delete failed.');
    } catch (_) {
      throw const AccountProfileException('Profile delete failed.');
    }
  }
}
