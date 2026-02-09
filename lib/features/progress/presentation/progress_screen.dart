import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(progressSnapshotProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: snapshotAsync.when(
        data: (snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ProgressCard(
                title: 'Sessions (rolling 7 days)',
                value: '${snapshot.sessionsRollingWeek}',
              ),
              _ProgressCard(
                title: 'Sessions (this month)',
                value: '${snapshot.sessionsThisMonth}',
              ),
              _ProgressCard(
                title: 'Total minutes (rolling 30 days)',
                value: '${snapshot.totalMinutesRollingMonth}',
              ),
              _ProgressCard(
                title: 'Current streak',
                value: '${snapshot.streak} days',
              ),
              _ProgressCard(
                title: 'Consistency (7 days)',
                value: '${(snapshot.consistency7 * 100).toStringAsFixed(0)}%',
              ),
              _ProgressCard(
                title: 'Consistency (30 days)',
                value: '${(snapshot.consistency30 * 100).toStringAsFixed(0)}%',
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to calculate progress: $error'),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
