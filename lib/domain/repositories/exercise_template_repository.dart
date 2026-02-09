import 'package:isar/isar.dart';

import '../../data/models/exercise_template_model.dart';

abstract class ExerciseTemplateRepository {
  Stream<List<ExerciseTemplateModel>> watchAll();

  Future<List<ExerciseTemplateModel>> getAll();

  Future<ExerciseTemplateModel?> getById(Id id);

  Future<Id> save(ExerciseTemplateModel template);

  Future<void> softDelete(Id id);

  Future<void> seedIfEmpty(List<ExerciseTemplateModel> templates);
}
