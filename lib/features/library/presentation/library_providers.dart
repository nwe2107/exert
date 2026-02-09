import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../data/models/exercise_template_model.dart';

final librarySearchQueryProvider = StateProvider<String>((ref) => '');

final libraryMuscleFilterProvider = StateProvider<MuscleGroup?>((ref) => null);

final filteredLibraryTemplatesProvider = Provider<AsyncValue<List<ExerciseTemplateModel>>>(
  (ref) {
    final templatesAsync = ref.watch(allTemplatesProvider);
    final query = ref.watch(librarySearchQueryProvider).trim().toLowerCase();
    final group = ref.watch(libraryMuscleFilterProvider);

    return templatesAsync.whenData((templates) {
      return templates.where((template) {
        final matchesQuery =
            query.isEmpty || template.name.toLowerCase().contains(query);
        final matchesGroup = group == null || template.muscleGroup == group;
        return matchesQuery && matchesGroup;
      }).toList();
    });
  },
);
