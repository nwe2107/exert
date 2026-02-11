import 'dart:math' as math;

import '../../core/enums/app_enums.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/exercise_entry_model.dart';
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

class MuscleWorkoutPoint {
  MuscleWorkoutPoint({
    required this.sessionId,
    required this.date,
    required this.totalSets,
    required this.totalReps,
    required this.averageRepsPerSet,
    required this.maxReps,
    required this.workScore,
  });

  final int sessionId;
  final DateTime date;
  final int totalSets;
  final int totalReps;
  final double averageRepsPerSet;
  final int maxReps;
  final int workScore;
}

class WorkoutProgressDelta {
  WorkoutProgressDelta({
    required this.current,
    required this.previous,
    required this.deltaSets,
    required this.deltaReps,
    required this.deltaAverageRepsPerSet,
    required this.deltaMaxReps,
    required this.deltaWorkScore,
  });

  final MuscleWorkoutPoint current;
  final MuscleWorkoutPoint previous;
  final int deltaSets;
  final int deltaReps;
  final double deltaAverageRepsPerSet;
  final int deltaMaxReps;
  final int deltaWorkScore;
}

class MuscleProgressAnalysis {
  MuscleProgressAnalysis({
    required this.muscle,
    required this.exerciseTemplateId,
    required this.rangeDays,
    required this.workouts,
    required this.latestDelta,
  });

  final SpecificMuscle muscle;
  final int? exerciseTemplateId;
  final int rangeDays;
  final List<MuscleWorkoutPoint> workouts;
  final WorkoutProgressDelta? latestDelta;
}

class ProgressService {
  ProgressSnapshot build(
    List<WorkoutSessionModel> sessions, {
    DateTime? today,
  }) {
    final now = normalizeLocalDate(today ?? DateTime.now());
    final byDay = <DateTime, WorkoutSessionModel>{
      for (final session in sessions)
        if (session.deletedAt == null)
          normalizeLocalDate(session.date): session,
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

  MuscleProgressAnalysis buildMuscleAnalysis({
    required List<WorkoutSessionModel> sessions,
    required List<ExerciseEntryModel> entries,
    required SpecificMuscle muscle,
    int? exerciseTemplateId,
    required int rangeDays,
    DateTime? today,
  }) {
    final now = normalizeLocalDate(today ?? DateTime.now());
    final safeRangeDays = rangeDays < 1 ? 1 : rangeDays;
    final rangeStart = now.subtract(Duration(days: safeRangeDays - 1));

    final sessionById = <int, WorkoutSessionModel>{
      for (final session in sessions)
        if (session.deletedAt == null) session.id: session,
    };

    final aggregateBySessionId = <int, _SessionWorkoutAggregate>{};

    for (final entry in entries) {
      if (entry.deletedAt != null || entry.specificMuscle != muscle) {
        continue;
      }
      if (exerciseTemplateId != null &&
          entry.exerciseTemplateId != exerciseTemplateId) {
        continue;
      }

      final session = sessionById[entry.workoutSessionId];
      if (session == null) {
        continue;
      }

      final sessionDate = normalizeLocalDate(session.date);
      if (sessionDate.isBefore(rangeStart) || sessionDate.isAfter(now)) {
        continue;
      }

      final aggregate = aggregateBySessionId.putIfAbsent(
        session.id,
        () =>
            _SessionWorkoutAggregate(sessionId: session.id, date: sessionDate),
      );

      final repsInEntry = entry.sets
          .map((set) => set.reps)
          .whereType<int>()
          .toList(growable: false);
      final repsTotal = repsInEntry.fold<int>(0, (sum, reps) => sum + reps);
      final entryMaxReps = repsInEntry.isEmpty
          ? 0
          : repsInEntry.reduce(math.max);

      aggregate
        ..totalSets += entry.sets.length
        ..totalReps += repsTotal
        ..setsWithReps += repsInEntry.length
        ..maxReps = math.max(aggregate.maxReps, entryMaxReps);
    }

    final workouts = aggregateBySessionId.values.map((aggregate) {
      final averageRepsPerSet = aggregate.setsWithReps == 0
          ? 0.0
          : aggregate.totalReps / aggregate.setsWithReps;

      return MuscleWorkoutPoint(
        sessionId: aggregate.sessionId,
        date: aggregate.date,
        totalSets: aggregate.totalSets,
        totalReps: aggregate.totalReps,
        averageRepsPerSet: averageRepsPerSet,
        maxReps: aggregate.maxReps,
        workScore: aggregate.totalReps * math.max(1, aggregate.totalSets),
      );
    }).toList();

    workouts.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return a.sessionId.compareTo(b.sessionId);
    });

    WorkoutProgressDelta? latestDelta;
    if (workouts.length >= 2) {
      final previous = workouts[workouts.length - 2];
      final current = workouts.last;
      latestDelta = WorkoutProgressDelta(
        current: current,
        previous: previous,
        deltaSets: current.totalSets - previous.totalSets,
        deltaReps: current.totalReps - previous.totalReps,
        deltaAverageRepsPerSet:
            current.averageRepsPerSet - previous.averageRepsPerSet,
        deltaMaxReps: current.maxReps - previous.maxReps,
        deltaWorkScore: current.workScore - previous.workScore,
      );
    }

    return MuscleProgressAnalysis(
      muscle: muscle,
      exerciseTemplateId: exerciseTemplateId,
      rangeDays: safeRangeDays,
      workouts: workouts,
      latestDelta: latestDelta,
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

class _SessionWorkoutAggregate {
  _SessionWorkoutAggregate({required this.sessionId, required this.date});

  final int sessionId;
  final DateTime date;
  int totalSets = 0;
  int totalReps = 0;
  int setsWithReps = 0;
  int maxReps = 0;
}
