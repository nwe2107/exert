import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/route_date_codec.dart';
import '../../../data/models/exercise_entry_model.dart';
import '../../../data/models/exercise_template_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../../../domain/services/day_status_service.dart';
import '../../workout/presentation/workout_providers.dart';
import 'calendar_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allSessionsProvider);
    final templatesAsync = ref.watch(allTemplatesProvider);
    final accountProfileAsync = ref.watch(accountProfileProvider);
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    final calendarMode = ref.watch(calendarViewModeProvider);
    final dayStatusService = ref.watch(dayStatusServiceProvider);
    final today = ref.watch(todayProvider);

    final entriesAsync = ref.watch(entriesForDateProvider(selectedDate));

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: sessionsAsync.when(
        data: (sessions) {
          final sessionsByDate = _mapSessionsByDate(sessions);
          final trackingStartDate = _resolveTrackingStartDate(
            accountCreatedAt: accountProfileAsync.valueOrNull?.createdAt,
            sessions: sessions,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  SegmentedButton<CalendarViewMode>(
                    segments: const [
                      ButtonSegment(
                        value: CalendarViewMode.week,
                        label: Text('Week'),
                      ),
                      ButtonSegment(
                        value: CalendarViewMode.month,
                        label: Text('Month'),
                      ),
                    ],
                    selected: {calendarMode},
                    onSelectionChanged: (selected) {
                      ref.read(calendarViewModeProvider.notifier).state =
                          selected.first;
                    },
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () {
                      context.push(
                        '/workout-log/${encodeRouteDate(selectedDate)}',
                      );
                    },
                    child: const Text('View/Edit Day Log'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar<WorkoutSessionModel>(
                    focusedDay: selectedDate,
                    firstDay: today.subtract(const Duration(days: 365)),
                    lastDay: today.add(const Duration(days: 365)),
                    calendarFormat: calendarMode == CalendarViewMode.week
                        ? CalendarFormat.week
                        : CalendarFormat.month,
                    selectedDayPredicate: (day) {
                      return isSameLocalDay(day, selectedDate);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      final normalized = normalizeLocalDate(selectedDay);
                      ref.read(selectedCalendarDateProvider.notifier).state =
                          normalized;
                      context.push(
                        '/workout-log/${encodeRouteDate(normalized)}',
                      );
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final status = dayStatusService.statusForDate(
                          date: day,
                          session: sessionsByDate[normalizeLocalDate(day)],
                          today: today,
                          trackingStartDate: trackingStartDate,
                        );
                        return _CalendarDayCell(day: day, status: status);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final status = dayStatusService.statusForDate(
                          date: day,
                          session: sessionsByDate[normalizeLocalDate(day)],
                          today: today,
                          trackingStartDate: trackingStartDate,
                        );
                        return _CalendarDayCell(
                          day: day,
                          status: status,
                          highlighted: true,
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final status = dayStatusService.statusForDate(
                          date: day,
                          session: sessionsByDate[normalizeLocalDate(day)],
                          today: today,
                          trackingStartDate: trackingStartDate,
                        );
                        return _CalendarDayCell(
                          day: day,
                          status: status,
                          selected: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selected day summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _SelectedDaySummary(
                session: sessionsByDate[normalizeLocalDate(selectedDate)],
                entriesAsync: entriesAsync,
                templatesAsync: templatesAsync,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load calendar: $error')),
      ),
    );
  }

  Map<DateTime, WorkoutSessionModel> _mapSessionsByDate(
    List<WorkoutSessionModel> sessions,
  ) {
    return {
      for (final session in sessions) normalizeLocalDate(session.date): session,
    };
  }

  DateTime? _resolveTrackingStartDate({
    required DateTime? accountCreatedAt,
    required List<WorkoutSessionModel> sessions,
  }) {
    final normalizedAccountStart = _normalizeAccountCreatedAt(accountCreatedAt);
    if (normalizedAccountStart != null) {
      return normalizedAccountStart;
    }
    if (sessions.isEmpty) {
      return null;
    }

    var earliest = normalizeLocalDate(sessions.first.date);
    for (final session in sessions.skip(1)) {
      final sessionDay = normalizeLocalDate(session.date);
      if (sessionDay.isBefore(earliest)) {
        earliest = sessionDay;
      }
    }
    return earliest;
  }

  DateTime? _normalizeAccountCreatedAt(DateTime? createdAt) {
    if (createdAt == null) {
      return null;
    }
    final normalized = normalizeLocalDate(createdAt);

    // Profiles without createdAt may deserialize as Unix epoch.
    if (normalized.year <= 1971) {
      return null;
    }
    return normalized;
  }
}

class _SelectedDaySummary extends StatelessWidget {
  const _SelectedDaySummary({
    required this.session,
    required this.entriesAsync,
    required this.templatesAsync,
  });

  final WorkoutSessionModel? session;
  final AsyncValue<List<ExerciseEntryModel>> entriesAsync;
  final AsyncValue<List<ExerciseTemplateModel>> templatesAsync;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('No session logged for this day.'),
        ),
      );
    }

    final top = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${session!.status.label}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('Duration: ${session!.durationMinutes ?? 0} min'),
            if ((session!.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Notes: ${session!.notes}'),
            ],
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        top,
        const SizedBox(height: 8),
        entriesAsync.when(
          data: (entries) {
            if (entries.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No exercise entries for this day.'),
                ),
              );
            }

            final namesById = <int, String>{
              for (final template in templatesAsync.valueOrNull ?? const [])
                template.id: template.name,
            };

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entries.map((entry) {
                    final name =
                        namesById[entry.exerciseTemplateId] ?? 'Exercise';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $name'),
                    );
                  }).toList(),
                ),
              ),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => Text('Failed to load entries: $error'),
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.status,
    this.selected = false,
    this.highlighted = false,
  });

  final DateTime day;
  final CalendarDayStatus status;
  final bool selected;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status, context);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.primaryContainer
            : highlighted
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}'),
          const SizedBox(height: 4),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }

  Color _statusColor(CalendarDayStatus status, BuildContext context) {
    switch (status) {
      case CalendarDayStatus.success:
        return Colors.green;
      case CalendarDayStatus.partial:
        return Colors.orange;
      case CalendarDayStatus.failure:
        return Colors.red;
      case CalendarDayStatus.rest:
        return Colors.blue;
      case CalendarDayStatus.empty:
        return Theme.of(context).colorScheme.outlineVariant;
    }
  }
}
