import 'package:isar/isar.dart';

import '../../core/enums/app_enums.dart';

part 'workout_session_model.g.dart';

@Collection(accessor: 'workoutSessions')
class WorkoutSessionModel {
  WorkoutSessionModel();

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  @Enumerated(EnumType.name)
  late SessionStatus status;

  int? durationMinutes;

  String? notes;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
