import 'package:flutter_test/flutter_test.dart';

import 'package:exert/core/enums/app_enums.dart';
import 'package:exert/data/models/workout_session_model.dart';
import 'package:exert/domain/services/day_status_service.dart';

void main() {
  group('DayStatusService.statusForDate', () {
    test('returns empty before tracking start date when no session exists', () {
      final service = DayStatusService();

      final status = service.statusForDate(
        date: DateTime(2026, 1, 31),
        session: null,
        today: DateTime(2026, 2, 12),
        trackingStartDate: DateTime(2026, 2, 1),
      );

      expect(status, CalendarDayStatus.empty);
    });

    test(
      'returns failure for past days after tracking start without session',
      () {
        final service = DayStatusService();

        final status = service.statusForDate(
          date: DateTime(2026, 2, 10),
          session: null,
          today: DateTime(2026, 2, 12),
          trackingStartDate: DateTime(2026, 2, 1),
        );

        expect(status, CalendarDayStatus.failure);
      },
    );

    test('returns recorded session status even before tracking start date', () {
      final service = DayStatusService();

      final status = service.statusForDate(
        date: DateTime(2026, 1, 31),
        session: _session(SessionStatus.rest),
        today: DateTime(2026, 2, 12),
        trackingStartDate: DateTime(2026, 2, 1),
      );

      expect(status, CalendarDayStatus.rest);
    });
  });
}

WorkoutSessionModel _session(SessionStatus status) {
  final now = DateTime(2026, 2, 12);
  return WorkoutSessionModel()
    ..id = 1
    ..date = now
    ..status = status
    ..createdAt = now
    ..updatedAt = now;
}
