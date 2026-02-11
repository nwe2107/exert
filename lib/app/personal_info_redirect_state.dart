import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/user_profile_model.dart';

class PersonalInfoRedirectState extends ChangeNotifier {
  PersonalInfoRedirectState(Stream<UserProfileModel?> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (profile) {
        _isKnown = true;
        _hasCompletedPersonalInfo = profile?.isComplete ?? false;
        notifyListeners();
      },
      onError: (_) {
        _isKnown = true;
        _hasCompletedPersonalInfo = false;
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<UserProfileModel?> _subscription;

  bool _isKnown = false;
  bool _hasCompletedPersonalInfo = false;

  bool get isKnown => _isKnown;

  bool get hasCompletedPersonalInfo => _hasCompletedPersonalInfo;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
