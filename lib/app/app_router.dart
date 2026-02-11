import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/app_providers.dart';
import '../core/utils/route_date_codec.dart';
import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/account_settings_screen.dart';
import '../features/account/presentation/account_profile_form_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/heatmap/presentation/heatmap_screen.dart';
import '../features/library/presentation/exercise_template_form_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../features/shell/presentation/root_shell_scaffold.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/workout/presentation/workout_log_screen.dart';
import 'auth_redirect.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final refreshListenable = GoRouterRefreshStream(
    authRepository.watchSession(),
  );
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: todayRoutePath,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      return authRedirect(
        session: authRepository.currentSession,
        matchedLocation: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: loginRoutePath,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: todayRoutePath,
                builder: (context, state) => const TodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/heatmap',
                builder: (context, state) => const HeatmapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const AccountProfileFormScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const AccountSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/workout-log/:date',
        builder: (context, state) {
          final rawDate = state.pathParameters['date'];
          final date = rawDate == null
              ? DateTime.now()
              : decodeRouteDate(rawDate);
          return WorkoutLogScreen(date: date);
        },
      ),
      GoRoute(
        path: '/library/new',
        builder: (context, state) => const ExerciseTemplateFormScreen(),
      ),
      GoRoute(
        path: '/library/edit/:id',
        builder: (context, state) {
          final idRaw = state.pathParameters['id'];
          final id = int.tryParse(idRaw ?? '');
          return ExerciseTemplateFormScreen(templateId: id);
        },
      ),
    ],
  );
});
