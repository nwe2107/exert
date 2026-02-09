import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../domain/services/heatmap_service.dart';

final heatmapItemsProvider = Provider<AsyncValue<List<MuscleHeatmapItem>>>(
  (ref) {
    final sessionsAsync = ref.watch(allSessionsProvider);
    final entriesAsync = ref.watch(allEntriesProvider);
    final templatesByIdAsync = ref.watch(templatesByIdProvider);
    final service = ref.watch(heatmapServiceProvider);
    final today = ref.watch(todayProvider);

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

    if (templatesByIdAsync.hasError) {
      return AsyncValue.error(
        templatesByIdAsync.error!,
        templatesByIdAsync.stackTrace ?? StackTrace.empty,
      );
    }

    if (sessionsAsync is! AsyncData ||
        entriesAsync is! AsyncData ||
        templatesByIdAsync is! AsyncData) {
      return const AsyncValue.loading();
    }

    final items = service.build(
      today: today,
      sessions: sessionsAsync.value!,
      entries: entriesAsync.value!,
      templatesById: templatesByIdAsync.value!,
    );

    return AsyncValue.data(items);
  },
);
