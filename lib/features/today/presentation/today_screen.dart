import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/utils/route_date_codec.dart';
import '../../../data/models/workout_session_model.dart';
import '../../progress/presentation/progress_providers.dart';
import '../../workout/presentation/workout_providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final progressAsync = ref.watch(progressSnapshotProvider);
    final sessionAsync = ref.watch(sessionForDateProvider(today));

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          progressAsync.when(
            data: (snapshot) {
              return Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Streak',
                      value: '${snapshot.streak} days',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _MetricCard(
                      title: 'Debt',
                      value: '0',
                      subtitle: 'Placeholder for v2 logic',
                    ),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text('Failed to load metrics: $error'),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: sessionAsync.when(
                data: (session) {
                  final label = session == null
                      ? 'No log yet'
                      : 'Today: ${session.status.label}';
                  return Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
                loading: () => const Text('Loading today status...'),
                error: (error, stackTrace) => Text('Failed to load: $error'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.push('/workout-log/${encodeRouteDate(today)}');
            },
            icon: const Icon(Icons.edit_note),
            label: const Text('Log Workout'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _quickMark(
              context,
              ref,
              today,
              status: SessionStatus.partial,
              durationMinutes: 10,
              note: 'Minimum workout mode',
            ),
            icon: const Icon(Icons.flag),
            label: const Text('Do Minimum'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _quickMark(
              context,
              ref,
              today,
              status: SessionStatus.rest,
              note: 'Intentional rest day',
            ),
            icon: const Icon(Icons.hotel),
            label: const Text('Mark Rest'),
          ),
        ],
      ),
    );
  }

  Future<void> _quickMark(
    BuildContext context,
    WidgetRef ref,
    DateTime date, {
    required SessionStatus status,
    int? durationMinutes,
    String? note,
  }) async {
    final repository = ref.read(workoutRepositoryProvider);
    final existing = await repository.getSessionByDate(date);

    final session = existing ?? WorkoutSessionModel();
    session
      ..date = date
      ..status = status
      ..durationMinutes = durationMinutes ?? existing?.durationMinutes
      ..notes = note ?? existing?.notes;

    await repository.saveSession(session);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved ${status.label.toLowerCase()} day.')),
      );
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
