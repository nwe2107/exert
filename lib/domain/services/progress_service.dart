import '../../core/enums/app_enums.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/workout_session_model.dart';

class ProgressSnapshot {
  ProgressSnapshot({
    required this.sessionsRollingWeek,
    required this.sessionsThisMonth,
    required this.totalMinutesRollingMonth,
    required this.streak,
    required this.consistency7,
    required this.consistency30,
  });

  final int sessionsRollingWeek;
  final int sessionsThisMonth;
  final int totalMinutesRollingMonth;
  final int streak;
  final double consistency7;
  final double consistency30;
}

class ProgressService {
  ProgressSnapshot build(List<WorkoutSessionModel> sessions, {DateTime? today}) {
    final now = normalizeLocalDate(today ?? DateTime.now());
    final byDay = <DateTime, WorkoutSessionModel>{
      for (final session in sessions)
        if (session.deletedAt == null) normalizeLocalDate(session.date): session,
    };

    final rollingWeekStart = now.subtract(const Duration(days: 6));
    final rollingMonthStart = now.subtract(const Duration(days: 29));

    final sessionsRollingWeek = sessions.where((session) {
      if (session.deletedAt != null || !_isMomentumSession(session)) {
        return false;
      }
      final day = normalizeLocalDate(session.date);
      return !day.isBefore(rollingWeekStart) && !day.isAfter(now);
    }).length;

    final sessionsThisMonth = sessions.where((session) {
      if (session.deletedAt != null || !_isMomentumSession(session)) {
        return false;
      }
      final day = normalizeLocalDate(session.date);
      return day.year == now.year && day.month == now.month;
    }).length;

    final totalMinutesRollingMonth = sessions
        .where((session) {
          if (session.deletedAt != null || !_isMomentumSession(session)) {
            return false;
          }
          final day = normalizeLocalDate(session.date);
          return !day.isBefore(rollingMonthStart) && !day.isAfter(now);
        })
        .fold<int>(0, (sum, session) => sum + (session.durationMinutes ?? 0));

    final consistency7 = _consistency(
      start: rollingWeekStart,
      end: now,
      byDay: byDay,
    );

    final consistency30 = _consistency(
      start: rollingMonthStart,
      end: now,
      byDay: byDay,
    );

    final streak = _streak(byDay: byDay, today: now);

    return ProgressSnapshot(
      sessionsRollingWeek: sessionsRollingWeek,
      sessionsThisMonth: sessionsThisMonth,
      totalMinutesRollingMonth: totalMinutesRollingMonth,
      streak: streak,
      consistency7: consistency7,
      consistency30: consistency30,
    );
  }

  bool _isMomentumSession(WorkoutSessionModel session) {
    return session.status != SessionStatus.fail;
  }

  double _consistency({
    required DateTime start,
    required DateTime end,
    required Map<DateTime, WorkoutSessionModel> byDay,
  }) {
    final days = daysInRange(start, end).toList();
    if (days.isEmpty) {
      return 0;
    }

    final momentumDays = days.where((day) {
      final session = byDay[day];
      if (session == null) {
        return false;
      }
      return _isMomentumSession(session);
    }).length;

    return momentumDays / days.length;
  }

  int _streak({
    required Map<DateTime, WorkoutSessionModel> byDay,
    required DateTime today,
  }) {
    var streak = 0;

    // Today can be unlogged without instantly ending the current streak.
    final todaySession = byDay[today];
    if (todaySession != null && _isMomentumSession(todaySession)) {
      streak += 1;
    }

    var cursor = today.subtract(const Duration(days: 1));
    while (true) {
      final session = byDay[cursor];
      if (session == null || !_isMomentumSession(session)) {
        break;
      }
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
