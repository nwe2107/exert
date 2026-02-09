import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/route_date_codec.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/heatmap/presentation/heatmap_screen.dart';
import '../features/library/presentation/exercise_template_form_screen.dart';
import '../features/library/presentation/library_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../features/shell/presentation/root_shell_scaffold.dart';
import '../features/today/presentation/today_screen.dart';
import '../features/workout/presentation/workout_log_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/today',
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
        path: '/workout-log/:date',
        builder: (context, state) {
          final rawDate = state.pathParameters['date'];
          final date = rawDate == null ? DateTime.now() : decodeRouteDate(rawDate);
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
