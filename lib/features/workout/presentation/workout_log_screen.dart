import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/exercise_entry_model.dart';
import '../../../data/models/exercise_template_model.dart';
import '../../../data/models/workout_session_model.dart';
import '../domain/compound_exercise_template_expander.dart';
import 'workout_providers.dart';

class WorkoutLogScreen extends ConsumerStatefulWidget {
  const WorkoutLogScreen({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends ConsumerState<WorkoutLogScreen> {
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  SessionStatus _status = SessionStatus.success;
  int? _hydratedSessionId;
  bool _savingSession = false;

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = normalizeLocalDate(widget.date);
    final sessionAsync = ref.watch(sessionForDateProvider(day));
    final templatesAsync = ref.watch(allTemplatesProvider);

    final dateLabel = DateFormat.yMMMMEEEEd().format(day);

    return Scaffold(
      appBar: AppBar(title: Text('Workout Log • $dateLabel')),
      body: sessionAsync.when(
        data: (session) {
          _hydrateSessionFields(session);

          final entriesAsync = session == null
              ? const AsyncValue.data(<ExerciseEntryModel>[])
              : ref.watch(entriesForSessionProvider(session.id));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SessionCard(
                status: _status,
                durationController: _durationController,
                notesController: _notesController,
                saving: _savingSession,
                onStatusChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                onSave: () => _saveSession(day, existing: session),
                onMarkRest: () =>
                    _quickStatus(day, SessionStatus.rest, existing: session),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Entries',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: templatesAsync is AsyncData
                        ? () => _addOrEditEntry(
                            date: day,
                            session: session,
                            templates: templatesAsync.value!,
                          )
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Entry'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              entriesAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No entries yet. Add your first exercise.'),
                      ),
                    );
                  }

                  final templatesById = templatesAsync.valueOrNull == null
                      ? <int, ExerciseTemplateModel>{}
                      : {
                          for (final template in templatesAsync.value!)
                            template.id: template,
                        };

                  return Column(
                    children: entries.map((entry) {
                      final templateName =
                          templatesById[entry.exerciseTemplateId]?.name ??
                          'Unknown exercise';

                      final setsSummary = entry.sets
                          .map(
                            (set) =>
                                'S${set.setNumber}: ${set.reps ?? '-'} reps',
                          )
                          .join(' • ');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      templateName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: templatesAsync is AsyncData
                                        ? () => _addOrEditEntry(
                                            date: day,
                                            session: session,
                                            templates: templatesAsync.value!,
                                            existing: entry,
                                          )
                                        : null,
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteEntry(entry),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              Text(
                                '${entry.schemeType.label} • ${entry.feltDifficulty.label}',
                              ),
                              const SizedBox(height: 4),
                              Text(setsSummary),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) =>
                    Text('Failed to load entries: $error'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load workout log: $error')),
      ),
    );
  }

  void _hydrateSessionFields(WorkoutSessionModel? session) {
    final nextSessionId = session?.id;
    if (_hydratedSessionId == nextSessionId) {
      return;
    }

    _hydratedSessionId = nextSessionId;

    if (session == null) {
      _status = SessionStatus.success;
      _durationController.text = '';
      _notesController.text = '';
      return;
    }

    _status = session.status;
    _durationController.text = session.durationMinutes?.toString() ?? '';
    _notesController.text = session.notes ?? '';
  }

  Future<void> _saveSession(
    DateTime date, {
    WorkoutSessionModel? existing,
  }) async {
    setState(() {
      _savingSession = true;
    });

    final repository = ref.read(workoutRepositoryProvider);
    final session = existing ?? WorkoutSessionModel();

    session
      ..date = date
      ..status = _status
      ..durationMinutes = int.tryParse(_durationController.text.trim())
      ..notes = _nullIfEmpty(_notesController.text);

    await repository.saveSession(session);

    if (!mounted) {
      return;
    }

    setState(() {
      _savingSession = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Session saved.')));
  }

  Future<void> _quickStatus(
    DateTime date,
    SessionStatus status, {
    WorkoutSessionModel? existing,
  }) async {
    setState(() {
      _status = status;
    });

    final repository = ref.read(workoutRepositoryProvider);
    final session = existing ?? WorkoutSessionModel();
    session
      ..date = date
      ..status = status
      ..durationMinutes = int.tryParse(_durationController.text.trim())
      ..notes = _nullIfEmpty(_notesController.text);

    await repository.saveSession(session);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Day marked as ${status.label.toLowerCase()}.')),
    );
  }

  Future<void> _addOrEditEntry({
    required DateTime date,
    required WorkoutSessionModel? session,
    required List<ExerciseTemplateModel> templates,
    ExerciseEntryModel? existing,
  }) async {
    final resolvedSession = await _ensureSession(date, session);
    if (!mounted) {
      return;
    }

    final result = await showModalBottomSheet<_EntryFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _EntryEditorSheet(templates: templates, existing: existing);
      },
    );

    if (result == null) {
      return;
    }

    final repository = ref.read(workoutRepositoryProvider);

    if (result.deleteRequested && existing != null) {
      await _deleteEntry(existing);
      return;
    }

    final selectedTemplate = templates.firstWhere(
      (item) => item.id == result.exerciseTemplateId,
    );
    final templatesById = {
      for (final template in templates) template.id: template,
    };
    final targetTemplates = expandTemplateForLogging(
      selectedTemplate,
      templatesById: templatesById,
    );

    if (existing != null && targetTemplates.length != 1) {
      await repository.deleteEntry(
        existing.id,
        sessionId: existing.workoutSessionId,
      );
    }

    for (var i = 0; i < targetTemplates.length; i++) {
      final template = targetTemplates[i];
      final entry = existing != null && targetTemplates.length == 1 && i == 0
          ? existing
          : ExerciseEntryModel();
      final resolvedMuscleGroups = template.resolveMuscleGroups();
      final resolvedSpecificMuscles = template.resolveSpecificMuscles();

      entry
        ..workoutSessionId = resolvedSession.id
        ..exerciseTemplateId = template.id
        ..schemeType = result.schemeType
        ..supersetGroupId = _nullIfEmpty(result.supersetGroupId)
        ..feltDifficulty = result.feltDifficulty
        ..restSeconds = result.restSeconds
        ..notes = _nullIfEmpty(result.notes)
        ..sets = result.setReps.asMap().entries.map((entry) {
          return SetItemModel()
            ..setNumber = entry.key + 1
            ..reps = entry.value;
        }).toList()
        ..muscleGroup = template.muscleGroup
        ..specificMuscle = template.specificMuscle
        ..muscleGroups = resolvedMuscleGroups
        ..specificMuscles = resolvedSpecificMuscles;

      await repository.saveEntry(entry);
    }
  }

  Future<WorkoutSessionModel> _ensureSession(
    DateTime date,
    WorkoutSessionModel? current,
  ) async {
    if (current != null) {
      return current;
    }

    final repository = ref.read(workoutRepositoryProvider);
    final session = WorkoutSessionModel()
      ..date = date
      ..status = _status
      ..durationMinutes = int.tryParse(_durationController.text.trim())
      ..notes = _nullIfEmpty(_notesController.text);

    final id = await repository.saveSession(session);
    session.id = id;
    return session;
  }

  Future<void> _deleteEntry(ExerciseEntryModel entry) async {
    final repository = ref.read(workoutRepositoryProvider);
    try {
      await repository.deleteEntry(entry.id, sessionId: entry.workoutSessionId);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entry deleted.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete entry: $error')));
    }
  }

  String? _nullIfEmpty(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.status,
    required this.durationController,
    required this.notesController,
    required this.saving,
    required this.onStatusChanged,
    required this.onSave,
    required this.onMarkRest,
  });

  final SessionStatus status;
  final TextEditingController durationController;
  final TextEditingController notesController;
  final bool saving;
  final ValueChanged<SessionStatus> onStatusChanged;
  final VoidCallback onSave;
  final VoidCallback onMarkRest;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SessionStatus>(
              initialValue: status,
              decoration: const InputDecoration(
                labelText: 'Day status',
                border: OutlineInputBorder(),
              ),
              items: SessionStatus.values
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onStatusChanged(value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration minutes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: saving ? null : onSave,
                    child: Text(saving ? 'Saving...' : 'Save Session'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onMarkRest,
                    child: const Text('Mark Rest'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryFormResult {
  _EntryFormResult({
    required this.exerciseTemplateId,
    required this.schemeType,
    required this.feltDifficulty,
    required this.setReps,
    this.supersetGroupId,
    this.restSeconds,
    this.notes,
    this.deleteRequested = false,
  });

  final int exerciseTemplateId;
  final SchemeType schemeType;
  final DifficultyLevel feltDifficulty;
  final List<int?> setReps;
  final String? supersetGroupId;
  final int? restSeconds;
  final String? notes;
  final bool deleteRequested;
}

class _EntryEditorSheet extends StatefulWidget {
  const _EntryEditorSheet({required this.templates, this.existing});

  final List<ExerciseTemplateModel> templates;
  final ExerciseEntryModel? existing;

  @override
  State<_EntryEditorSheet> createState() => _EntryEditorSheetState();
}

class _EntryEditorSheetState extends State<_EntryEditorSheet> {
  int? _templateId;
  SchemeType _schemeType = SchemeType.standard;
  DifficultyLevel _feltDifficulty = DifficultyLevel.moderate;

  late final TextEditingController _supersetGroupController;
  late final TextEditingController _restController;
  late final TextEditingController _notesController;

  final List<TextEditingController> _setRepControllers = [];

  @override
  void initState() {
    super.initState();

    _templateId = widget.existing?.exerciseTemplateId;
    _schemeType = widget.existing?.schemeType ?? SchemeType.standard;
    _feltDifficulty =
        widget.existing?.feltDifficulty ?? DifficultyLevel.moderate;

    _supersetGroupController = TextEditingController(
      text: widget.existing?.supersetGroupId ?? '',
    );
    _restController = TextEditingController(
      text: widget.existing?.restSeconds?.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.existing?.notes ?? '',
    );

    final existingSets = widget.existing?.sets ?? const <SetItemModel>[];
    if (existingSets.isEmpty) {
      _setRepControllers.add(TextEditingController());
    } else {
      for (final set in existingSets) {
        _setRepControllers.add(
          TextEditingController(text: set.reps?.toString() ?? ''),
        );
      }
    }
  }

  @override
  void dispose() {
    _supersetGroupController.dispose();
    _restController.dispose();
    _notesController.dispose();
    for (final controller in _setRepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existing == null ? 'Add Entry' : 'Edit Entry',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _templateId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Exercise',
                border: OutlineInputBorder(),
              ),
              items: _groupedTemplateDropdownItems(context),
              onChanged: (value) {
                setState(() {
                  _templateId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SchemeType>(
              initialValue: _schemeType,
              decoration: const InputDecoration(
                labelText: 'Scheme type',
                border: OutlineInputBorder(),
              ),
              items: SchemeType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _schemeType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DifficultyLevel>(
              initialValue: _feltDifficulty,
              decoration: const InputDecoration(
                labelText: 'Felt difficulty',
                border: OutlineInputBorder(),
              ),
              items: DifficultyLevel.values
                  .map(
                    (difficulty) => DropdownMenuItem(
                      value: difficulty,
                      child: Text(difficulty.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _feltDifficulty = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _supersetGroupController,
              decoration: const InputDecoration(
                labelText: 'Superset group id (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _restController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest seconds (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Text('Sets', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._buildSetEditors(),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _setRepControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add set'),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Save Entry'),
                  ),
                ),
                if (widget.existing != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _requestDelete,
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetEditors() {
    final widgets = <Widget>[];

    for (var i = 0; i < _setRepControllers.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(width: 36, child: Text('S${i + 1}')),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _setRepControllers[i],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _setRepControllers.length <= 1
                    ? null
                    : () {
                        setState(() {
                          final controller = _setRepControllers.removeAt(i);
                          controller.dispose();
                        });
                      },
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  List<DropdownMenuItem<int>> _groupedTemplateDropdownItems(
    BuildContext context,
  ) {
    final templatesByGroup = <MuscleGroup, List<ExerciseTemplateModel>>{};
    for (final template in widget.templates) {
      templatesByGroup
          .putIfAbsent(template.muscleGroup, () => [])
          .add(template);
    }

    final items = <DropdownMenuItem<int>>[];
    var nextHeaderValue = -1;
    for (final group in MuscleGroup.values) {
      final grouped = templatesByGroup[group];
      if (grouped == null || grouped.isEmpty) {
        continue;
      }

      grouped.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
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

      for (final template in grouped) {
        items.add(
          DropdownMenuItem<int>(
            value: template.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(template.name),
            ),
          ),
        );
      }
    }

    return items;
  }

  void _save() {
    if (_templateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an exercise first.')),
      );
      return;
    }

    final reps = _setRepControllers
        .map((controller) => int.tryParse(controller.text.trim()))
        .toList();

    final result = _EntryFormResult(
      exerciseTemplateId: _templateId!,
      schemeType: _schemeType,
      feltDifficulty: _feltDifficulty,
      setReps: reps,
      supersetGroupId: _supersetGroupController.text,
      restSeconds: int.tryParse(_restController.text.trim()),
      notes: _notesController.text,
    );

    Navigator.of(context).pop(result);
  }

  void _requestDelete() {
    final result = _EntryFormResult(
      exerciseTemplateId: _templateId ?? 0,
      schemeType: _schemeType,
      feltDifficulty: _feltDifficulty,
      setReps: const [],
      deleteRequested: true,
    );

    Navigator.of(context).pop(result);
  }
}
