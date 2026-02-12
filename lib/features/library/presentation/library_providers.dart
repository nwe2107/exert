import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../data/models/exercise_template_model.dart';

final librarySearchQueryProvider = StateProvider<String>((ref) => '');

final libraryMuscleFilterProvider = StateProvider<MuscleGroup?>((ref) => null);

final librarySpecificMuscleFilterProvider = StateProvider<SpecificMuscle?>(
  (ref) => null,
);

List<ExerciseTemplateModel> applyLibraryFilters({
  required List<ExerciseTemplateModel> templates,
  required String query,
  required MuscleGroup? group,
  required SpecificMuscle? specificMuscle,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  return templates.where((template) {
    final matchesQuery =
        normalizedQuery.isEmpty ||
        template.name.toLowerCase().contains(normalizedQuery);
    final matchesGroup = group == null || template.muscleGroup == group;
    final matchesSpecific =
        specificMuscle == null || template.specificMuscle == specificMuscle;
    return matchesQuery && matchesGroup && matchesSpecific;
  }).toList();
}

final filteredLibraryTemplatesProvider =
    Provider<AsyncValue<List<ExerciseTemplateModel>>>((ref) {
      final templatesAsync = ref.watch(allTemplatesProvider);
      final query = ref.watch(librarySearchQueryProvider);
      final group = ref.watch(libraryMuscleFilterProvider);
      final specificMuscle = ref.watch(librarySpecificMuscleFilterProvider);

      return templatesAsync.whenData((templates) {
        return applyLibraryFilters(
          templates: templates,
          query: query,
          group: group,
          specificMuscle: specificMuscle,
        );
      });
    });
