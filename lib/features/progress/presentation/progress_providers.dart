import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
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
