import 'package:isar/isar.dart';

import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class IsarUserProfileRepository implements UserProfileRepository {
  IsarUserProfileRepository(this._isar);

  final Isar _isar;

  @override
  Stream<UserProfileModel?> watchProfile() {
    return _isar.userProfiles.watchObject(1, fireImmediately: true);
  }

  @override
  Future<UserProfileModel?> getProfile() async {
    return _isar.userProfiles.get(1);
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final now = DateTime.now();
    final existing = await _isar.userProfiles.get(1);

    profile
      ..id = 1
      ..createdAt = existing?.createdAt ?? now
      ..updatedAt = now;

    await _isar.writeTxn(() async {
      await _isar.userProfiles.put(profile);
    });
  }

  @override
  Future<void> clearProfile() async {
    await _isar.writeTxn(() async {
      await _isar.userProfiles.delete(1);
    });
  }
}
