import '../../data/models/user_profile_model.dart';

abstract class UserProfileRepository {
  Stream<UserProfileModel?> watchProfile();

  Future<UserProfileModel?> getProfile();

  Future<void> saveProfile(UserProfileModel profile);

  Future<void> clearProfile();
}
