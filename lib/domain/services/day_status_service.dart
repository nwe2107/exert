import '../../core/enums/app_enums.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/workout_session_model.dart';

enum CalendarDayStatus { success, partial, failure, rest, empty }

class DayStatusService {
  CalendarDayStatus statusForDate({
    required DateTime date,
    required WorkoutSessionModel? session,
    DateTime? today,
  }) {
    final currentDay = normalizeLocalDate(today ?? DateTime.now());
    final targetDay = normalizeLocalDate(date);

    if (session != null) {
      switch (session.status) {
        case SessionStatus.success:
          return CalendarDayStatus.success;
        case SessionStatus.partial:
          return CalendarDayStatus.partial;
        case SessionStatus.fail:
          return CalendarDayStatus.failure;
        case SessionStatus.rest:
          return CalendarDayStatus.rest;
      }
    }

    if (targetDay.isBefore(currentDay)) {
      return CalendarDayStatus.failure;
    }
    return CalendarDayStatus.empty;
  }

  bool isMomentumDay(SessionStatus status) {
    return status != SessionStatus.fail;
  }

  bool isSuccessDay(SessionStatus status) {
    return status == SessionStatus.success || status == SessionStatus.rest;
  }
}
