import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../domain/services/progress_service.dart';

final progressSnapshotProvider = Provider<AsyncValue<ProgressSnapshot>>((ref) {
  final sessionsAsync = ref.watch(allSessionsProvider);
  final progressService = ref.watch(progressServiceProvider);
  final today = ref.watch(todayProvider);

  if (sessionsAsync.hasError) {
    return AsyncValue.error(
      sessionsAsync.error!,
      sessionsAsync.stackTrace ?? StackTrace.empty,
    );
  }

  if (sessionsAsync is! AsyncData) {
    return const AsyncValue.loading();
  }

  final snapshot = progressService.build(sessionsAsync.value!, today: today);
  return AsyncValue.data(snapshot);
});

enum ProgressRangeFilter { days7, days30, days90 }

extension ProgressRangeFilterX on ProgressRangeFilter {
  int get days {
    switch (this) {
      case ProgressRangeFilter.days7:
        return 7;
      case ProgressRangeFilter.days30:
        return 30;
      case ProgressRangeFilter.days90:
        return 90;
    }
  }

  String get label {
    switch (this) {
      case ProgressRangeFilter.days7:
        return '7D';
      case ProgressRangeFilter.days30:
        return '30D';
      case ProgressRangeFilter.days90:
        return '90D';
    }
  }
}

enum ProgressChartType { bar, plot }

extension ProgressChartTypeX on ProgressChartType {
  String get label {
    switch (this) {
      case ProgressChartType.bar:
        return 'Bar';
      case ProgressChartType.plot:
        return 'Plot';
    }
  }
}

final progressRangeFilterProvider = StateProvider<ProgressRangeFilter>((ref) {
  return ProgressRangeFilter.days30;
});

final progressChartTypeProvider = StateProvider<ProgressChartType>((ref) {
  return ProgressChartType.bar;
});

final progressMuscleFilterProvider = StateProvider<SpecificMuscle>((ref) {
  return SpecificMuscle.abs;
});

final progressExerciseFilterProvider = StateProvider<int?>((ref) {
  return null;
});

class ProgressExerciseOption {
  const ProgressExerciseOption({required this.templateId, required this.label});

  final int templateId;
  final String label;
}

final progressExerciseOptionsProvider =
    Provider<AsyncValue<List<ProgressExerciseOption>>>((ref) {
      final entriesAsync = ref.watch(allEntriesProvider);
      final templatesAsync = ref.watch(allTemplatesProvider);
      final selectedMuscle = ref.watch(progressMuscleFilterProvider);

      if (entriesAsync.hasError) {
        return AsyncValue.error(
          entriesAsync.error!,
          entriesAsync.stackTrace ?? StackTrace.empty,
        );
      }
      if (templatesAsync.hasError) {
        return AsyncValue.error(
          templatesAsync.error!,
          templatesAsync.stackTrace ?? StackTrace.empty,
        );
      }

      if (entriesAsync is! AsyncData || templatesAsync is! AsyncData) {
        return const AsyncValue.loading();
      }

      final nameByTemplateId = {
        for (final template in templatesAsync.value!)
          template.id: template.name,
      };
      final templateIds = entriesAsync.value!
          .where((entry) => entry.specificMuscle == selectedMuscle)
          .map((entry) => entry.exerciseTemplateId)
          .toSet();

      final options =
          templateIds
              .map(
                (templateId) => ProgressExerciseOption(
                  templateId: templateId,
                  label: nameByTemplateId[templateId] ?? 'Exercise $templateId',
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
            );

      return AsyncValue.data(options);
    });

final muscleProgressAnalysisProvider =
    Provider<AsyncValue<MuscleProgressAnalysis>>((ref) {
      final sessionsAsync = ref.watch(allSessionsProvider);
      final entriesAsync = ref.watch(allEntriesProvider);
      final progressService = ref.watch(progressServiceProvider);
      final today = ref.watch(todayProvider);
      final selectedMuscle = ref.watch(progressMuscleFilterProvider);
      final selectedExerciseTemplateId = ref.watch(
        progressExerciseFilterProvider,
      );
      final range = ref.watch(progressRangeFilterProvider);

      if (sessionsAsync.hasError) {
        return AsyncValue.error(
          sessionsAsync.error!,
          sessionsAsync.stackTrace ?? StackTrace.empty,
        );
      }

      if (entriesAsync.hasError) {
        return AsyncValue.error(
          entriesAsync.error!,
          entriesAsync.stackTrace ?? StackTrace.empty,
        );
      }

      if (sessionsAsync is! AsyncData || entriesAsync is! AsyncData) {
        return const AsyncValue.loading();
      }

      final analysis = progressService.buildMuscleAnalysis(
        sessions: sessionsAsync.value!,
        entries: entriesAsync.value!,
        muscle: selectedMuscle,
        exerciseTemplateId: selectedExerciseTemplateId,
        rangeDays: range.days,
        today: today,
      );

      return AsyncValue.data(analysis);
    });
