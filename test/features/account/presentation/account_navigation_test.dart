import 'package:exert/app/app.dart';
import 'package:exert/application/app_providers.dart';
import 'package:exert/data/models/exercise_entry_model.dart';
import 'package:exert/data/models/exercise_template_model.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/domain/models/auth_session.dart';
import 'package:exert/domain/repositories/auth_repository.dart';
import 'package:exert/features/account/presentation/account_screen.dart';
import 'package:exert/features/today/presentation/today_screen.dart';
import 'package:exert/features/workout/presentation/workout_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('navigates Today -> Account -> Settings and returns to Today', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _AuthenticatedAuthRepository(),
          ),
          todayProvider.overrideWithValue(DateTime(2026, 2, 9)),
          allSessionsProvider.overrideWith(
            (ref) => Stream.value(<WorkoutSessionModel>[]),
          ),
          allTemplatesProvider.overrideWith(
            (ref) => Stream.value(<ExerciseTemplateModel>[]),
          ),
          allEntriesProvider.overrideWith(
            (ref) => Stream.value(<ExerciseEntryModel>[]),
          ),
          sessionForDateProvider.overrideWith(
            (ref, date) => Stream<WorkoutSessionModel?>.value(null),
          ),
        ],
        child: const ExertApp(),
      ),
    );
    await tester.pumpAndSettle();

    final todayAccountButton = find.byKey(todayAccountButtonKey);
    expect(todayAccountButton, findsOneWidget);

    await tester.tap(todayAccountButton);
    await tester.pumpAndSettle();

    final settingsButton = find.byKey(accountSettingsButtonKey);
    expect(settingsButton, findsOneWidget);

    await tester.tap(settingsButton);
    await tester.pumpAndSettle();
    expect(find.text('Account settings'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    final backToTodayButton = find.byKey(accountBackButtonKey);
    expect(backToTodayButton, findsOneWidget);
    await tester.tap(backToTodayButton);
    await tester.pumpAndSettle();

    expect(find.byKey(todayAccountButtonKey), findsOneWidget);
    expect(find.text('Account settings'), findsNothing);
  });
}

class _AuthenticatedAuthRepository implements AuthRepository {
  _AuthenticatedAuthRepository()
    : _session = AuthSession(
        userId: 'test-user',
        email: 'test@exert.app',
        signedInAt: DateTime(2026, 2, 9),
      );

  final AuthSession _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  Stream<AuthSession?> watchSession() => Stream<AuthSession?>.value(_session);

  @override
  Future<AuthSession> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _session;
  }

  @override
  Future<void> signOut() async {}
}
