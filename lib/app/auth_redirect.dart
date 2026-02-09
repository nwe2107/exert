import '../domain/models/auth_session.dart';

const String loginRoutePath = '/login';
const String todayRoutePath = '/today';

String? authRedirect({
  required AuthSession? session,
  required String matchedLocation,
}) {
  final onLoginRoute = matchedLocation == loginRoutePath;
  final isAuthenticated = session != null;

  if (!isAuthenticated && !onLoginRoute) {
    return loginRoutePath;
  }

  if (isAuthenticated && onLoginRoute) {
    return todayRoutePath;
  }

  return null;
}
