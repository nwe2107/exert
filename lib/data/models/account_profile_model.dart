import 'package:cloud_firestore/cloud_firestore.dart';

class AccountProfileModel {
  const AccountProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.onboardingComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final bool onboardingComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountProfileModel copyWith({
    String? displayName,
    bool? onboardingComplete,
    DateTime? updatedAt,
  }) {
    return AccountProfileModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static AccountProfileModel fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    final createdAtValue = data['createdAt'];
    final updatedAtValue = data['updatedAt'];

    return AccountProfileModel(
      uid: data['uid'] as String? ?? snapshot.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      createdAt: _decodeTimestamp(createdAtValue),
      updatedAt: _decodeTimestamp(updatedAtValue),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'onboardingComplete': onboardingComplete,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static DateTime _decodeTimestamp(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
