import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/app_enums.dart';
import '../../../domain/services/progress_service.dart';
import 'progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(progressSnapshotProvider);
    final analysisAsync = ref.watch(muscleProgressAnalysisProvider);
    final selectedMuscle = ref.watch(progressMuscleFilterProvider);
    final selectedExerciseTemplateId = ref.watch(
      progressExerciseFilterProvider,
    );
    final exerciseOptionsAsync = ref.watch(progressExerciseOptionsProvider);
    final selectedRange = ref.watch(progressRangeFilterProvider);
    final selectedChartType = ref.watch(progressChartTypeProvider);

    if (snapshotAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: Center(
          child: Text('Failed to calculate progress: ${snapshotAsync.error}'),
        ),
      );
    }

    if (analysisAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: Center(
          child: Text(
            'Failed to calculate muscle trends: ${analysisAsync.error}',
          ),
        ),
      );
    }

    if (snapshotAsync is! AsyncData || analysisAsync is! AsyncData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final snapshot = snapshotAsync.value!;
    final analysis = analysisAsync.value!;
    final selectedExerciseLabel = _exerciseLabelForTemplate(
      options: exerciseOptionsAsync.valueOrNull ?? const [],
      templateId: selectedExerciseTemplateId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
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
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Muscle trend filters',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    initialValue: selectedMuscle.index,
                    decoration: const InputDecoration(
                      labelText: 'Specific muscle',
                      border: OutlineInputBorder(),
                    ),
                    items: _groupedMuscleDropdownItems(context),
                    onChanged: (value) {
                      if (value == null || value < 0) {
                        return;
                      }
                      ref.read(progressMuscleFilterProvider.notifier).state =
                          SpecificMuscle.values[value];
                      ref.read(progressExerciseFilterProvider.notifier).state =
                          null;
                    },
                  ),
                  const SizedBox(height: 12),
                  exerciseOptionsAsync.when(
                    data: (options) {
                      final selectedExercise =
                          options
                              .where(
                                (option) =>
                                    option.templateId ==
                                    selectedExerciseTemplateId,
                              )
                              .isNotEmpty
                          ? selectedExerciseTemplateId
                          : null;

                      return DropdownButtonFormField<int?>(
                        isExpanded: true,
                        initialValue: selectedExercise,
                        decoration: const InputDecoration(
                          labelText: 'Exercise (optional)',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('All exercises'),
                          ),
                          ...options.map(
                            (option) => DropdownMenuItem<int?>(
                              value: option.templateId,
                              child: Text(option.label),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          ref
                                  .read(progressExerciseFilterProvider.notifier)
                                  .state =
                              value;
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stackTrace) =>
                        Text('Failed to load exercise filter: $error'),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ProgressRangeFilter>(
                    segments: ProgressRangeFilter.values
                        .map(
                          (range) => ButtonSegment(
                            value: range,
                            label: Text(range.label),
                          ),
                        )
                        .toList(),
                    selected: {selectedRange},
                    onSelectionChanged: (selection) {
                      ref.read(progressRangeFilterProvider.notifier).state =
                          selection.first;
                    },
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ProgressChartType>(
                    segments: ProgressChartType.values
                        .map(
                          (chartType) => ButtonSegment(
                            value: chartType,
                            label: Text(chartType.label),
                          ),
                        )
                        .toList(),
                    selected: {selectedChartType},
                    onSelectionChanged: (selection) {
                      ref.read(progressChartTypeProvider.notifier).state =
                          selection.first;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (analysis.workouts.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  selectedExerciseLabel == null
                      ? 'No workouts found for this muscle in the selected range.'
                      : 'No workouts found for ${analysis.muscle.label} • '
                            '$selectedExerciseLabel in the selected range.',
                ),
              ),
            )
          else ...[
            _DeltaSummaryCard(
              analysis: analysis,
              selectedExerciseLabel: selectedExerciseLabel,
            ),
            _buildTrendChart(
              title: 'Total reps per workout',
              chartType: selectedChartType,
              points: analysis.workouts,
              metric: (point) => point.totalReps,
              color: Colors.teal.shade600,
            ),
            _buildTrendChart(
              title: 'Total sets per workout',
              chartType: selectedChartType,
              points: analysis.workouts,
              metric: (point) => point.totalSets,
              color: Colors.deepPurple.shade400,
            ),
            _buildTrendChart(
              title: 'Work score (sets × reps)',
              chartType: selectedChartType,
              points: analysis.workouts,
              metric: (point) => point.workScore,
              color: Colors.orange.shade700,
            ),
            _RecentWorkoutComparisonCard(
              points: analysis.workouts,
              selectedExerciseLabel: selectedExerciseLabel,
            ),
          ],
        ],
      ),
    );
  }
}

Widget _buildTrendChart({
  required String title,
  required ProgressChartType chartType,
  required List<MuscleWorkoutPoint> points,
  required _MetricSelector metric,
  required Color color,
}) {
  if (chartType == ProgressChartType.plot) {
    return _MetricLineChart(
      title: title,
      points: points,
      metric: metric,
      color: color,
    );
  }

  return _MetricBarChart(
    title: title,
    points: points,
    metric: metric,
    color: color,
  );
}

List<DropdownMenuItem<int>> _groupedMuscleDropdownItems(BuildContext context) {
  final items = <DropdownMenuItem<int>>[];
  var nextHeaderValue = -1;

  for (final group in MuscleGroup.values) {
    final groupMuscles = List<SpecificMuscle>.from(
      specificMusclesByGroup[group] ?? const [],
    );
    if (groupMuscles.isEmpty) {
      continue;
    }

    groupMuscles.sort(
      (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
    );

    items.add(
      DropdownMenuItem<int>(
        value: nextHeaderValue,
        enabled: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1.2,
            ),
          ),
          child: Text(
            group.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
    nextHeaderValue -= 1;

    for (final muscle in groupMuscles) {
      items.add(
        DropdownMenuItem<int>(
          value: muscle.index,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(muscle.label),
          ),
        ),
      );
    }
  }

  return items;
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.title, required this.value});

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
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _DeltaSummaryCard extends StatelessWidget {
  const _DeltaSummaryCard({
    required this.analysis,
    required this.selectedExerciseLabel,
  });

  final MuscleProgressAnalysis analysis;
  final String? selectedExerciseLabel;

  @override
  Widget build(BuildContext context) {
    final scopedLabel = selectedExerciseLabel == null
        ? analysis.muscle.label
        : '${analysis.muscle.label} • $selectedExerciseLabel';
    final delta = analysis.latestDelta;
    if (delta == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            'Add one more $scopedLabel workout to unlock sequential deltas.',
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest vs previous workout ($scopedLabel)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _DeltaChip(label: 'Reps', value: _signedInt(delta.deltaReps)),
                _DeltaChip(label: 'Sets', value: _signedInt(delta.deltaSets)),
                _DeltaChip(
                  label: 'Avg reps/set',
                  value: _signedDouble(delta.deltaAverageRepsPerSet),
                ),
                _DeltaChip(
                  label: 'Max reps',
                  value: _signedInt(delta.deltaMaxReps),
                ),
                _DeltaChip(
                  label: 'Work score',
                  value: _signedInt(delta.deltaWorkScore),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = _deltaColor(value, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _deltaColor(String value, BuildContext context) {
    if (value.startsWith('+')) {
      return Colors.green.shade700;
    }
    if (value.startsWith('-')) {
      return Colors.red.shade700;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

typedef _MetricSelector = int Function(MuscleWorkoutPoint point);

class _MetricBarChart extends StatelessWidget {
  const _MetricBarChart({
    required this.title,
    required this.points,
    required this.metric,
    required this.color,
  });

  final String title;
  final List<MuscleWorkoutPoint> points;
  final _MetricSelector metric;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final maxValue = points
        .map(metric)
        .fold<int>(0, (current, next) => math.max(current, next));
    final safeMax = maxValue == 0 ? 1 : maxValue;
    final dateFormat = DateFormat.Md();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: points.map((point) {
                  final value = metric(point);
                  final rawHeight = (value / safeMax) * 90;
                  final barHeight = value == 0
                      ? 4.0
                      : rawHeight.clamp(8.0, 90.0);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 46,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$value',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 24,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dateFormat.format(point.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricLineChart extends StatelessWidget {
  const _MetricLineChart({
    required this.title,
    required this.points,
    required this.metric,
    required this.color,
  });

  final String title;
  final List<MuscleWorkoutPoint> points;
  final _MetricSelector metric;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final values = points.map(metric).toList(growable: false);
    final maxValue = values.fold<int>(
      0,
      (current, next) => math.max(current, next),
    );
    final safeMax = maxValue == 0 ? 1 : maxValue;
    final chartWidth = math.max(280.0, points.length * 56.0);
    final dateFormat = DateFormat.Md();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 132,
                      child: CustomPaint(
                        painter: _LinePlotPainter(
                          values: values,
                          maxValue: safeMax,
                          color: color,
                          gridColor: Theme.of(
                            context,
                          ).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (points.length == 1)
                      Text(
                        dateFormat.format(points.first.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else
                      Row(
                        children: [
                          Text(
                            dateFormat.format(points.first.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Text(
                            dateFormat.format(points.last.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinePlotPainter extends CustomPainter {
  _LinePlotPainter({
    required this.values,
    required this.maxValue,
    required this.color,
    required this.gridColor,
  });

  final List<int> values;
  final int maxValue;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final left = 12.0;
    final right = 12.0;
    final top = 8.0;
    final bottom = 14.0;
    final width = math.max(1.0, size.width - left - right);
    final height = math.max(1.0, size.height - top - bottom);

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = gridColor.withValues(alpha: 0.5);
    for (var i = 0; i <= 3; i++) {
      final y = top + (height / 3) * i;
      canvas.drawLine(Offset(left, y), Offset(left + width, y), gridPaint);
    }

    final points = _pointsForValues(
      values: values,
      maxValue: maxValue,
      left: left,
      top: top,
      width: width,
      height: height,
    );
    if (points.isEmpty) {
      return;
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final areaPath = Path.from(linePath)
      ..lineTo(points.last.dx, top + height)
      ..lineTo(points.first.dx, top + height)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.24), color.withValues(alpha: 0.02)],
      ).createShader(Rect.fromLTWH(left, top, width, height));
    canvas.drawPath(areaPath, fillPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawPath(linePath, linePaint);

    final dotFill = Paint()..color = color;
    final dotStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white;
    for (final point in points) {
      canvas.drawCircle(point, 4.5, dotFill);
      canvas.drawCircle(point, 4.5, dotStroke);
    }
  }

  List<Offset> _pointsForValues({
    required List<int> values,
    required int maxValue,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    if (values.isEmpty) {
      return const [];
    }

    if (values.length == 1) {
      final y = top + (1 - (values.first / maxValue)) * height;
      return [Offset(left + (width / 2), y)];
    }

    final step = width / (values.length - 1);
    return List.generate(values.length, (index) {
      final x = left + (step * index);
      final y = top + (1 - (values[index] / maxValue)) * height;
      return Offset(x, y);
    });
  }

  @override
  bool shouldRepaint(covariant _LinePlotPainter oldDelegate) {
    return oldDelegate.maxValue != maxValue ||
        oldDelegate.color != color ||
        oldDelegate.gridColor != gridColor ||
        !_sameIntList(oldDelegate.values, values);
  }
}

bool _sameIntList(List<int> a, List<int> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

class _RecentWorkoutComparisonCard extends StatelessWidget {
  const _RecentWorkoutComparisonCard({
    required this.points,
    required this.selectedExerciseLabel,
  });

  final List<MuscleWorkoutPoint> points;
  final String? selectedExerciseLabel;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    final descending = points.reversed.take(8).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
              child: Text(
                selectedExerciseLabel == null
                    ? 'Recent workout comparisons'
                    : 'Recent workout comparisons • $selectedExerciseLabel',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...List.generate(descending.length, (index) {
              final current = descending[index];
              final previous = index + 1 < descending.length
                  ? descending[index + 1]
                  : null;
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            dateFormat.format(current.date),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        if (previous == null)
                          const _WorkoutDeltaBadge(
                            label: 'Baseline',
                            delta: null,
                          )
                        else
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _WorkoutDeltaBadge(
                                label: 'Reps',
                                delta: current.totalReps - previous.totalReps,
                              ),
                              _WorkoutDeltaBadge(
                                label: 'Sets',
                                delta: current.totalSets - previous.totalSets,
                              ),
                              _WorkoutDeltaBadge(
                                label: 'Volume',
                                delta: current.workScore - previous.workScore,
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sets ${current.totalSets} • Reps ${current.totalReps} • '
                      'Avg ${current.averageRepsPerSet.toStringAsFixed(1)} • '
                      'Max ${current.maxReps} • Volume ${current.workScore}',
                    ),
                    if (index + 1 < descending.length) ...[
                      const SizedBox(height: 6),
                      const Divider(height: 1),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WorkoutDeltaBadge extends StatelessWidget {
  const _WorkoutDeltaBadge({required this.label, required this.delta});

  final String label;
  final int? delta;

  @override
  Widget build(BuildContext context) {
    final color = _badgeColor(context);
    final valueText = _badgeText();
    final badgeText = delta == null ? valueText : '$label $valueText';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        badgeText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _badgeText() {
    if (delta == null) {
      return label;
    }
    if (delta == 0) {
      return 'No change';
    }
    return _signedInt(delta!);
  }

  Color _badgeColor(BuildContext context) {
    if (delta == null || delta == 0) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    if (delta! > 0) {
      return Colors.green.shade700;
    }
    return Colors.red.shade700;
  }
}

String? _exerciseLabelForTemplate({
  required List<ProgressExerciseOption> options,
  required int? templateId,
}) {
  if (templateId == null) {
    return null;
  }
  for (final option in options) {
    if (option.templateId == templateId) {
      return option.label;
    }
  }
  return 'Exercise $templateId';
}

String _signedInt(int value) {
  if (value > 0) {
    return '+$value';
  }
  return '$value';
}

String _signedDouble(double value) {
  final rounded = value.toStringAsFixed(1);
  if (value > 0) {
    return '+$rounded';
  }
  return rounded;
}
