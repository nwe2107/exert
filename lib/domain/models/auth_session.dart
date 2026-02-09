class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.signedInAt,
  });

  final String userId;
  final String email;
  final DateTime signedInAt;
}
