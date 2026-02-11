import 'dart:async';

import '../../domain/repositories/account_profile_repository.dart';
import '../models/account_profile_model.dart';

class InMemoryAccountProfileRepository implements AccountProfileRepository {
  final Map<String, AccountProfileModel> _profilesByUid = {};
  final Map<String, StreamController<AccountProfileModel?>> _controllers = {};

  StreamController<AccountProfileModel?> _controllerFor(String uid) {
    return _controllers.putIfAbsent(
      uid,
      () => StreamController<AccountProfileModel?>.broadcast(),
    );
  }

  @override
  Stream<AccountProfileModel?> watchProfile(String uid) async* {
    yield _profilesByUid[uid];
    yield* _controllerFor(uid).stream;
  }

  @override
  Future<AccountProfileModel?> getProfile(String uid) async {
    return _profilesByUid[uid];
  }

  @override
  Future<void> saveProfile(AccountProfileModel profile) async {
    _profilesByUid[profile.uid] = profile;
    _controllerFor(profile.uid).add(profile);
  }

  @override
  Future<void> deleteProfile(String uid) async {
    _profilesByUid.remove(uid);
    _controllerFor(uid).add(null);
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
  }
}
