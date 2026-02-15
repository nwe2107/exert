import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/local/saved_workout_template_store.dart';
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
  String? _hydratedSessionFingerprint;
  bool _savingSession = false;
  bool _savingTemplate = false;
  bool _applyingTemplate = false;

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
    final savedTemplatesAsync = ref.watch(savedWorkoutTemplatesProvider);

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
              Text('Entries', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _savingTemplate
                        ? null
                        : () => _saveCurrentWorkoutTemplate(day),
                    icon: _savingTemplate
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.bookmark_add_outlined),
                    label: Text(_savingTemplate ? 'Saving...' : 'Save Workout'),
                  ),
                  OutlinedButton.icon(
                    onPressed:
                        templatesAsync is AsyncData &&
                            savedTemplatesAsync is AsyncData &&
                            !_applyingTemplate
                        ? () => _selectAndApplySavedWorkout(
                            date: day,
                            session: session,
                            templates: templatesAsync.value!,
                            savedTemplates: savedTemplatesAsync.value!,
                          )
                        : null,
                    icon: _applyingTemplate
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.history),
                    label: Text(
                      _applyingTemplate ? 'Applying...' : 'Use Saved',
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: templatesAsync is AsyncData && !_applyingTemplate
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
    final nextFingerprint = _sessionFingerprint(session);
    if (_hydratedSessionFingerprint == nextFingerprint) {
      return;
    }

    _hydratedSessionFingerprint = nextFingerprint;

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

  String _sessionFingerprint(WorkoutSessionModel? session) {
    if (session == null) {
      return 'none';
    }
    return [
      session.id,
      session.status.name,
      session.durationMinutes,
      session.notes ?? '',
      session.updatedAt.millisecondsSinceEpoch,
    ].join('|');
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

  Future<void> _saveCurrentWorkoutTemplate(DateTime date) async {
    setState(() {
      _savingTemplate = true;
    });

    try {
      final repository = ref.read(workoutRepositoryProvider);
      final store = ref.read(savedWorkoutTemplateStoreProvider);
      final session = await repository.getSessionByDate(date);

      if (session == null) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Save the session first, then save it as a reusable workout.',
            ),
          ),
        );
        return;
      }

      final entries = await repository.getEntriesForSession(session.id);
      if (entries.isEmpty) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add at least one exercise entry before saving.'),
          ),
        );
        return;
      }

      if (!mounted) {
        return;
      }
      final suggestedName = 'Workout ${DateFormat.MMMd().format(date)}';
      final name = await _promptTemplateName(initialName: suggestedName);
      if (name == null) {
        return;
      }

      final existingTemplates = await store.loadTemplates();
      final existingTemplate = _findTemplateByName(
        templates: existingTemplates,
        name: name,
      );
      final now = DateTime.now();

      final template = SavedWorkoutTemplate(
        id: existingTemplate?.id ?? generateSavedWorkoutTemplateId(),
        name: name,
        status: _status,
        durationMinutes: int.tryParse(_durationController.text.trim()),
        notes: _nullIfEmpty(_notesController.text),
        entries: entries
            .map(_toSavedWorkoutEntryTemplate)
            .toList(growable: false),
        createdAt: existingTemplate?.createdAt ?? now,
        updatedAt: now,
      );

      await store.saveTemplate(template);
      ref.invalidate(savedWorkoutTemplatesProvider);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existingTemplate == null
                ? 'Saved "${template.name}" for later use.'
                : 'Updated saved workout "${template.name}".',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save workout template: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingTemplate = false;
        });
      }
    }
  }

  Future<void> _selectAndApplySavedWorkout({
    required DateTime date,
    required WorkoutSessionModel? session,
    required List<ExerciseTemplateModel> templates,
    required List<SavedWorkoutTemplate> savedTemplates,
  }) async {
    if (savedTemplates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No saved workouts yet.')));
      return;
    }

    final templatesById = {
      for (final template in templates) template.id: template.name,
    };

    final selectedTemplate = await showModalBottomSheet<SavedWorkoutTemplate>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _SavedWorkoutPickerSheet(
          templates: savedTemplates,
          exerciseNamesByTemplateId: templatesById,
        );
      },
    );
    if (selectedTemplate == null) {
      return;
    }

    await _applySavedWorkoutTemplate(
      date: date,
      session: session,
      templates: templates,
      savedTemplate: selectedTemplate,
    );
  }

  Future<void> _applySavedWorkoutTemplate({
    required DateTime date,
    required WorkoutSessionModel? session,
    required List<ExerciseTemplateModel> templates,
    required SavedWorkoutTemplate savedTemplate,
  }) async {
    setState(() {
      _applyingTemplate = true;
    });

    try {
      final repository = ref.read(workoutRepositoryProvider);
      final templateLookup = {
        for (final template in templates) template.id: template,
      };
      final applicableEntries =
          <MapEntry<SavedWorkoutEntryTemplate, ExerciseTemplateModel>>[];
      var skipped = 0;
      for (final entryTemplate in savedTemplate.entries) {
        final sourceTemplate = templateLookup[entryTemplate.exerciseTemplateId];
        if (sourceTemplate == null) {
          skipped += 1;
          continue;
        }
        applicableEntries.add(MapEntry(entryTemplate, sourceTemplate));
      }

      if (applicableEntries.isEmpty) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Saved workout can’t be applied because its exercises are missing from your library.',
            ),
          ),
        );
        return;
      }

      final resolvedSession = await _ensureSession(date, session);
      final existingEntries = await repository.getEntriesForSession(
        resolvedSession.id,
      );

      if (existingEntries.isNotEmpty) {
        final shouldReplace = await _confirmReplaceCurrentEntries();
        if (!shouldReplace) {
          return;
        }
      }

      await repository.deleteEntriesForSession(resolvedSession.id);

      resolvedSession
        ..status = savedTemplate.status
        ..durationMinutes = savedTemplate.durationMinutes
        ..notes = _nullIfEmpty(savedTemplate.notes);
      await repository.saveSession(resolvedSession);

      var copied = 0;
      for (final templateEntry in applicableEntries) {
        final entryTemplate = templateEntry.key;
        final sourceTemplate = templateEntry.value;
        final entry = ExerciseEntryModel()
          ..workoutSessionId = resolvedSession.id
          ..exerciseTemplateId = sourceTemplate.id
          ..schemeType = entryTemplate.schemeType
          ..supersetGroupId = _nullIfEmpty(entryTemplate.supersetGroupId)
          ..feltDifficulty = entryTemplate.feltDifficulty
          ..restSeconds = entryTemplate.restSeconds
          ..notes = _nullIfEmpty(entryTemplate.notes)
          ..sets = _setsFromSavedTemplate(entryTemplate)
          ..muscleGroup = sourceTemplate.muscleGroup
          ..specificMuscle = sourceTemplate.specificMuscle
          ..muscleGroups = sourceTemplate.resolveMuscleGroups()
          ..specificMuscles = sourceTemplate.resolveSpecificMuscles();

        await repository.saveEntry(entry);
        copied += 1;
      }

      _hydratedSessionFingerprint = null;

      if (!mounted) {
        return;
      }

      if (copied == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No entries could be applied. Add missing exercises to your library first.',
            ),
          ),
        );
        return;
      }

      final skippedText = skipped == 0
          ? ''
          : ' Skipped $skipped missing exercise template(s).';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Applied "${savedTemplate.name}" with $copied entries.$skippedText',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply saved workout: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _applyingTemplate = false;
        });
      }
    }
  }

  Future<String?> _promptTemplateName({required String initialName}) async {
    final controller = TextEditingController(text: initialName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Workout'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Saved workout name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final trimmed = controller.text.trim();
                if (trimmed.isEmpty) {
                  return;
                }
                Navigator.of(context).pop(trimmed);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  Future<bool> _confirmReplaceCurrentEntries() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Replace current entries?'),
          content: const Text(
            'Applying a saved workout will replace all current entries for this day.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  SavedWorkoutTemplate? _findTemplateByName({
    required List<SavedWorkoutTemplate> templates,
    required String name,
  }) {
    final normalized = name.trim().toLowerCase();
    for (final template in templates) {
      if (template.name.trim().toLowerCase() == normalized) {
        return template;
      }
    }
    return null;
  }

  SavedWorkoutEntryTemplate _toSavedWorkoutEntryTemplate(
    ExerciseEntryModel entry,
  ) {
    return SavedWorkoutEntryTemplate(
      exerciseTemplateId: entry.exerciseTemplateId,
      schemeType: entry.schemeType,
      feltDifficulty: entry.feltDifficulty,
      supersetGroupId: _nullIfEmpty(entry.supersetGroupId),
      restSeconds: entry.restSeconds,
      notes: _nullIfEmpty(entry.notes),
      sets: entry.sets
          .map(
            (set) => SavedWorkoutSetTemplate(
              reps: set.reps,
              weight: set.weight,
              durationSeconds: set.durationSeconds,
              rpe: set.rpe,
            ),
          )
          .toList(growable: false),
    );
  }

  List<SetItemModel> _setsFromSavedTemplate(SavedWorkoutEntryTemplate entry) {
    if (entry.sets.isEmpty) {
      return [SetItemModel()..setNumber = 1];
    }

    return entry.sets
        .asMap()
        .entries
        .map((item) {
          final index = item.key;
          final set = item.value;
          return SetItemModel()
            ..setNumber = index + 1
            ..reps = set.reps
            ..weight = set.weight
            ..durationSeconds = set.durationSeconds
            ..rpe = set.rpe;
        })
        .toList(growable: false);
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

class _SavedWorkoutPickerSheet extends StatelessWidget {
  const _SavedWorkoutPickerSheet({
    required this.templates,
    required this.exerciseNamesByTemplateId,
  });

  final List<SavedWorkoutTemplate> templates;
  final Map<int, String> exerciseNamesByTemplateId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose saved workout',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: templates.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final template = templates[index];
                  final updatedAt = DateFormat.yMMMd().format(
                    template.updatedAt.toLocal(),
                  );
                  final preview = _exercisePreview(template);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(template.name),
                    subtitle: Text(
                      '${template.entries.length} entries • Updated $updatedAt\n$preview',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pop(template),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _exercisePreview(SavedWorkoutTemplate template) {
    final names = <String>{};
    for (final entry in template.entries) {
      final name = exerciseNamesByTemplateId[entry.exerciseTemplateId];
      if (name != null && name.isNotEmpty) {
        names.add(name);
      }
    }

    if (names.isEmpty) {
      return 'Exercises are missing from your library.';
    }

    final ordered = names.toList(growable: false);
    if (ordered.length <= 3) {
      return ordered.join(' • ');
    }

    final firstThree = ordered.take(3).join(' • ');
    final remaining = ordered.length - 3;
    return '$firstThree +$remaining more';
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
