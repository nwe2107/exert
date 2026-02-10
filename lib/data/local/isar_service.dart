import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/exercise_entry_model.dart';
import '../models/exercise_template_model.dart';
import '../models/user_profile_model.dart';
import '../models/workout_session_model.dart';

class IsarService {
  static Future<Isar> open() async {
    final directory = await getApplicationSupportDirectory();
    return Isar.open(
      [
        ExerciseTemplateModelSchema,
        WorkoutSessionModelSchema,
        ExerciseEntryModelSchema,
        UserProfileModelSchema,
      ],
      directory: directory.path,
      inspector: kDebugMode,
    );
  }
}
