import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/app_enums.dart';
import '../../../domain/services/heatmap_service.dart';
import 'body_heatmap_view.dart';
import 'heatmap_providers.dart';

enum HeatmapDisplayMode { body, grid }

class HeatmapScreen extends ConsumerStatefulWidget {
  const HeatmapScreen({super.key});

  @override
  ConsumerState<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends ConsumerState<HeatmapScreen> {
  HeatmapDisplayMode _displayMode = HeatmapDisplayMode.body;
  BodyOrientation _bodyOrientation = BodyOrientation.front;

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(heatmapItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Body Heatmap')),
      body: heatmapAsync.when(
        data: (items) {
          final itemByMuscle = {
            for (final item in items) item.specificMuscle: item,
          };

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<HeatmapDisplayMode>(
                        segments: const [
                          ButtonSegment(
                            value: HeatmapDisplayMode.body,
                            label: Text('Body Map'),
                            icon: Icon(Icons.accessibility_new),
                          ),
                          ButtonSegment(
                            value: HeatmapDisplayMode.grid,
                            label: Text('Grid'),
                            icon: Icon(Icons.grid_view),
                          ),
                        ],
                        selected: {_displayMode},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _displayMode = selection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_displayMode == HeatmapDisplayMode.body)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<BodyOrientation>(
                          segments: const [
                            ButtonSegment(
                              value: BodyOrientation.front,
                              label: Text('Front'),
                            ),
                            ButtonSegment(
                              value: BodyOrientation.back,
                              label: Text('Back'),
                            ),
                          ],
                          selected: {_bodyOrientation},
                          onSelectionChanged: (selection) {
                            setState(() {
                              _bodyOrientation = selection.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: _Legend(
                  showNeverAsGreen: _displayMode == HeatmapDisplayMode.body,
                ),
              ),
              if (_displayMode == HeatmapDisplayMode.body)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'Tap a zone to see muscle details.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Expanded(
                child: _displayMode == HeatmapDisplayMode.body
                    ? BodyHeatmapView(
                        orientation: _bodyOrientation,
                        itemByMuscle: itemByMuscle,
                        onMuscleTap: (item) => _showDetails(context, item),
                      )
                    : _MuscleGrid(
                        items: items,
                        onTap: (item) => _showDetails(context, item),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to build heatmap: $error')),
      ),
    );
  }

  void _showDetails(BuildContext context, MuscleHeatmapItem item) {
    final dateFormat = DateFormat.yMMMd();
    final rootContext = context;

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.specificMuscle.label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(item.group.label),
              const SizedBox(height: 12),
              Text(
                item.lastTrainedDate == null
                    ? 'Last trained: not logged yet'
                    : 'Last trained: ${dateFormat.format(item.lastTrainedDate!)}',
              ),
              const SizedBox(height: 8),
              if (item.exercisesOnLastTrainedDate.isEmpty)
                const Text('Exercises: no matching logs yet')
              else ...[
                const Text('Exercises on last trained date:'),
                const SizedBox(height: 4),
                ...item.exercisesOnLastTrainedDate.map(
                  (name) => Text('• $name'),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    rootContext.go(
                      '/library?muscle=${item.specificMuscle.name}',
                    );
                  },
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('See exercises'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.showNeverAsGreen});

  final bool showNeverAsGreen;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        _LegendChip(color: Colors.green.shade300, text: 'Recent'),
        _LegendChip(color: Colors.yellow.shade400, text: 'Medium'),
        _LegendChip(color: Colors.red.shade300, text: 'Stale'),
        _LegendChip(
          color: showNeverAsGreen
              ? Colors.green.shade200
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          text: showNeverAsGreen ? 'Unlogged (starts green)' : 'Never trained',
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

class _MuscleGrid extends StatelessWidget {
  const _MuscleGrid({required this.items, required this.onTap});

  final List<MuscleHeatmapItem> items;
  final ValueChanged<MuscleHeatmapItem> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(item),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _bandColor(item.recencyBand, context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.specificMuscle.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.group.label),
                  const Spacer(),
                  Text(
                    item.daysSinceLastTrained == null
                        ? 'Never trained'
                        : '${item.daysSinceLastTrained} days ago',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _bandColor(MuscleRecencyBand band, BuildContext context) {
    switch (band) {
      case MuscleRecencyBand.recent:
        return Colors.green.shade200;
      case MuscleRecencyBand.medium:
        return Colors.yellow.shade300;
      case MuscleRecencyBand.stale:
        return Colors.red.shade200;
      case MuscleRecencyBand.never:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }
}
