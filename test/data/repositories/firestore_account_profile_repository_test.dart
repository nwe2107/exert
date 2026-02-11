import 'package:exert/data/models/account_profile_model.dart';
import 'package:exert/data/repositories/firestore_account_profile_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreAccountProfileRepository', () {
    test('creates and reads a profile document', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = FirestoreAccountProfileRepository(firestore);
      final profile = AccountProfileModel(
        uid: 'user_1',
        email: 'user1@example.com',
        displayName: 'User One',
        onboardingComplete: false,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      await repository.saveProfile(profile);

      final snapshot = await firestore.collection('users').doc('user_1').get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['displayName'], 'User One');

      final fetched = await repository.getProfile('user_1');
      expect(fetched, isNotNull);
      expect(fetched!.uid, 'user_1');
      expect(fetched.displayName, 'User One');
      expect(fetched.email, 'user1@example.com');
    });

    test('watchProfile emits updates', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = FirestoreAccountProfileRepository(firestore);
      final updates = <AccountProfileModel?>[];

      final sub = repository.watchProfile('user_2').listen(updates.add);

      await repository.saveProfile(
        AccountProfileModel(
          uid: 'user_2',
          email: 'user2@example.com',
          displayName: 'User Two',
          onboardingComplete: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await repository.saveProfile(
        AccountProfileModel(
          uid: 'user_2',
          email: 'user2@example.com',
          displayName: 'Updated',
          onboardingComplete: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));
      await sub.cancel();

      expect(updates.whereType<AccountProfileModel>().length, greaterThan(0));
      expect(updates.last!.displayName, 'Updated');
      expect(updates.last!.onboardingComplete, isTrue);
    });
  });
}
