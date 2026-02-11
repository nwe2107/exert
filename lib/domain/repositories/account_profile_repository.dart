import '../../data/models/account_profile_model.dart';

abstract class AccountProfileRepository {
  Stream<AccountProfileModel?> watchProfile(String uid);

  Future<AccountProfileModel?> getProfile(String uid);

  Future<void> saveProfile(AccountProfileModel profile);

  Future<void> deleteProfile(String uid);
}

class AccountProfileException implements Exception {
  const AccountProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}
