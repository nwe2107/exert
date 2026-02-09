import 'package:isar/isar.dart';

import '../../data/models/exercise_template_model.dart';
import '../../domain/repositories/exercise_template_repository.dart';

class IsarExerciseTemplateRepository implements ExerciseTemplateRepository {
  IsarExerciseTemplateRepository(this._isar);

  final Isar _isar;

  @override
  Stream<List<ExerciseTemplateModel>> watchAll() {
    return _isar.exerciseTemplates
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => getAll());
  }

  @override
  Future<List<ExerciseTemplateModel>> getAll() async {
    final all = await _isar.exerciseTemplates.where().findAll();
    final active = all.where((template) => template.deletedAt == null).toList();
    active.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return active;
  }

  @override
  Future<ExerciseTemplateModel?> getById(Id id) async {
    final template = await _isar.exerciseTemplates.get(id);
    if (template == null || template.deletedAt != null) {
      return null;
    }
    return template;
  }

  @override
  Future<Id> save(ExerciseTemplateModel template) async {
    final now = DateTime.now();
    final existing = template.id == Isar.autoIncrement
        ? null
        : await _isar.exerciseTemplates.get(template.id);

    template.createdAt = existing?.createdAt ?? now;
    template.updatedAt = now;

    late Id id;
    await _isar.writeTxn(() async {
      id = await _isar.exerciseTemplates.put(template);
    });
    return id;
  }

  @override
  Future<void> softDelete(Id id) async {
    final template = await _isar.exerciseTemplates.get(id);
    if (template == null || template.deletedAt != null) {
      return;
    }

    template.deletedAt = DateTime.now();
    template.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.exerciseTemplates.put(template);
    });
  }

  @override
  Future<void> seedIfEmpty(List<ExerciseTemplateModel> templates) async {
    final current = await getAll();
    if (current.isNotEmpty) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.exerciseTemplates.putAll(templates);
    });
  }
}
