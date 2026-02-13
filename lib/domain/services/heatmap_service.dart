import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/exercise_entry_model.dart';
import '../../data/models/exercise_template_model.dart';
import '../../data/models/workout_session_model.dart';

enum MuscleRecencyBand { recent, medium, stale, never }

class MuscleHeatmapItem {
  MuscleHeatmapItem({
    required this.group,
    required this.specificMuscle,
    required this.daysSinceLastTrained,
    required this.lastTrainedDate,
    required this.exercisesOnLastTrainedDate,
  });

  final MuscleGroup group;
  final SpecificMuscle specificMuscle;
  final int? daysSinceLastTrained;
  final DateTime? lastTrainedDate;
  final List<String> exercisesOnLastTrainedDate;

  MuscleRecencyBand get recencyBand {
    if (daysSinceLastTrained == null) {
      return MuscleRecencyBand.never;
    }
    if (daysSinceLastTrained! <= 3) {
      return MuscleRecencyBand.recent;
    }
    if (daysSinceLastTrained! <= 7) {
      return MuscleRecencyBand.medium;
    }
    return MuscleRecencyBand.stale;
  }
}

class HeatmapService {
  List<MuscleHeatmapItem> build({
    required DateTime today,
    required List<WorkoutSessionModel> sessions,
    required List<ExerciseEntryModel> entries,
    required Map<Id, ExerciseTemplateModel> templatesById,
  }) {
    final normalizedToday = normalizeLocalDate(today);
    final sessionById = <Id, WorkoutSessionModel>{
      for (final session in sessions)
        if (session.deletedAt == null &&
            (session.status == SessionStatus.success ||
                session.status == SessionStatus.partial) &&
            !normalizeLocalDate(session.date).isAfter(normalizedToday))
          session.id: session,
    };

    final allSpecificMuscles = <(MuscleGroup, SpecificMuscle)>[];
    for (final group in MuscleGroup.values) {
      final specifics =
          specificMusclesByGroup[group] ?? const <SpecificMuscle>[];
      for (final specific in specifics) {
        allSpecificMuscles.add((group, specific));
      }
    }

    final latestDateByMuscle = <SpecificMuscle, DateTime>{};
    final exercisesByMuscleOnLastDate = <SpecificMuscle, Set<String>>{};

    for (final entry in entries) {
      if (entry.deletedAt != null) {
        continue;
      }

      final session = sessionById[entry.workoutSessionId];
      if (session == null) {
        continue;
      }

      final trainedDay = normalizeLocalDate(session.date);
      final exerciseName = templatesById[entry.exerciseTemplateId]?.name;

      for (final muscle in entry.resolveSpecificMuscles()) {
        final previous = latestDateByMuscle[muscle];

        if (previous == null || trainedDay.isAfter(previous)) {
          latestDateByMuscle[muscle] = trainedDay;
          exercisesByMuscleOnLastDate[muscle] = exerciseName == null
              ? <String>{}
              : <String>{exerciseName};
          continue;
        }

        if (trainedDay == previous && exerciseName != null) {
          exercisesByMuscleOnLastDate
              .putIfAbsent(muscle, () => <String>{})
              .add(exerciseName);
        }
      }
    }

    return allSpecificMuscles.map((pair) {
      final group = pair.$1;
      final specificMuscle = pair.$2;
      final lastDate = latestDateByMuscle[specificMuscle];

      return MuscleHeatmapItem(
        group: group,
        specificMuscle: specificMuscle,
        daysSinceLastTrained: lastDate == null
            ? null
            : daysBetween(lastDate, normalizedToday),
        lastTrainedDate: lastDate,
        exercisesOnLastTrainedDate:
            exercisesByMuscleOnLastDate[specificMuscle]?.toList() ?? const [],
      );
    }).toList();
  }
}
