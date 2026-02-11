import '../domain/models/auth_session.dart';

const String loginRoutePath = '/login';
const String todayRoutePath = '/today';
const String getStartedRoutePath = '/get-started';

String? authRedirect({
  required AuthSession? session,
  required String matchedLocation,
  required bool isPersonalInfoKnown,
  required bool hasCompletedPersonalInfo,
}) {
  final onLoginRoute = matchedLocation == loginRoutePath;
  final onGetStartedRoute = matchedLocation == getStartedRoutePath;
  final isAuthenticated = session != null;

  if (!isAuthenticated) {
    if (onLoginRoute) {
      return null;
    }
    return loginRoutePath;
  }

  if (onLoginRoute) {
    if (!isPersonalInfoKnown) {
      return todayRoutePath;
    }
    return hasCompletedPersonalInfo ? todayRoutePath : getStartedRoutePath;
  }

  if (!isPersonalInfoKnown) {
    return null;
  }

  if (!hasCompletedPersonalInfo && !onGetStartedRoute) {
    return getStartedRoutePath;
  }

  if (hasCompletedPersonalInfo && onGetStartedRoute) {
    return todayRoutePath;
  }

  return null;
}
