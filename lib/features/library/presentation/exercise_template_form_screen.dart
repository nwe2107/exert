import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../data/models/exercise_template_model.dart';

class ExerciseTemplateFormScreen extends ConsumerStatefulWidget {
  const ExerciseTemplateFormScreen({super.key, this.templateId});

  final int? templateId;

  @override
  ConsumerState<ExerciseTemplateFormScreen> createState() =>
      _ExerciseTemplateFormScreenState();
}

class _ExerciseTemplateFormScreenState
    extends ConsumerState<ExerciseTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _mediaUrlController;
  late final TextEditingController _notesController;
  late final TextEditingController _minRepsController;
  late final TextEditingController _maxRepsController;
  late final TextEditingController _targetSetsController;
  late final TextEditingController _progressionStepController;

  bool _didHydrate = false;
  bool _isSaving = false;
  bool _isCompound = false;
  final Set<int> _compoundTemplateIds = <int>{};

  MediaType? _mediaType;
  MuscleGroup _muscleGroup = MuscleGroup.chest;
  SpecificMuscle _specificMuscle = SpecificMuscle.midChest;
  DifficultyLevel _defaultDifficulty = DifficultyLevel.moderate;
  EquipmentType? _equipment;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mediaUrlController = TextEditingController();
    _notesController = TextEditingController();
    _minRepsController = TextEditingController();
    _maxRepsController = TextEditingController();
    _targetSetsController = TextEditingController();
    _progressionStepController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mediaUrlController.dispose();
    _notesController.dispose();
    _minRepsController.dispose();
    _maxRepsController.dispose();
    _targetSetsController.dispose();
    _progressionStepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTemplatesAsync = ref.watch(allTemplatesProvider);
    final allTemplates =
        allTemplatesAsync.valueOrNull ?? const <ExerciseTemplateModel>[];

    ExerciseTemplateModel? existing;
    if (widget.templateId != null) {
      for (final candidate in allTemplates) {
        if (candidate.id == widget.templateId) {
          existing = candidate;
          break;
        }
      }
    }

    if (!_didHydrate && existing != null) {
      _hydrate(existing);
    }

    final title = existing == null ? 'Add Exercise' : 'Edit Exercise';
    final compoundOptions = _compoundTemplateOptions(
      allTemplates,
      editingTemplateId: existing?.id,
    );
    final specificOptions =
        specificMusclesByGroup[_muscleGroup] ?? const <SpecificMuscle>[];

    if (!specificOptions.contains(_specificMuscle) &&
        specificOptions.isNotEmpty) {
      _specificMuscle = specificOptions.first;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Compound exercise'),
              subtitle: const Text(
                'Use this for workouts made of multiple existing exercises.',
              ),
              value: _isCompound,
              onChanged: (value) {
                setState(() {
                  _isCompound = value;
                });
              },
            ),
            const SizedBox(height: 8),
            if (!_isCompound) ...[
              DropdownButtonFormField<MuscleGroup>(
                initialValue: _muscleGroup,
                decoration: const InputDecoration(
                  labelText: 'Muscle group',
                  border: OutlineInputBorder(),
                ),
                items: MuscleGroup.values
                    .map(
                      (group) => DropdownMenuItem(
                        value: group,
                        child: Text(group.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _muscleGroup = value;
                    final options = specificMusclesByGroup[_muscleGroup];
                    if (options != null && options.isNotEmpty) {
                      _specificMuscle = options.first;
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SpecificMuscle>(
                initialValue: _specificMuscle,
                decoration: const InputDecoration(
                  labelText: 'Specific muscle',
                  border: OutlineInputBorder(),
                ),
                items: specificOptions
                    .map(
                      (muscle) => DropdownMenuItem(
                        value: muscle,
                        child: Text(muscle.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _specificMuscle = value;
                  });
                },
              ),
            ] else ...[
              _CompoundExercisePicker(
                options: compoundOptions,
                selectedTemplateIds: _compoundTemplateIds,
                onToggleTemplate: (templateId, selected) {
                  setState(() {
                    if (selected) {
                      _compoundTemplateIds.add(templateId);
                    } else {
                      _compoundTemplateIds.remove(templateId);
                    }
                  });
                },
              ),
            ],
            const SizedBox(height: 12),
            DropdownButtonFormField<DifficultyLevel>(
              initialValue: _defaultDifficulty,
              decoration: const InputDecoration(
                labelText: 'Default difficulty',
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
                  _defaultDifficulty = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<EquipmentType?>(
              initialValue: _equipment,
              decoration: const InputDecoration(
                labelText: 'Equipment (optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<EquipmentType?>(
                  value: null,
                  child: Text('None'),
                ),
                ...EquipmentType.values.map(
                  (equipment) => DropdownMenuItem<EquipmentType?>(
                    value: equipment,
                    child: Text(equipment.label),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _equipment = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MediaType?>(
              initialValue: _mediaType,
              decoration: const InputDecoration(
                labelText: 'Media type (optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<MediaType?>(
                  value: null,
                  child: Text('None'),
                ),
                ...MediaType.values.map(
                  (mediaType) => DropdownMenuItem<MediaType?>(
                    value: mediaType,
                    child: Text(mediaType.label),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _mediaType = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mediaUrlController,
              decoration: const InputDecoration(
                labelText: 'Media URL (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
            Text(
              'Progression settings (stored for future engine)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minRepsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _maxRepsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _targetSetsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _progressionStepController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Progression step',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving
                  ? null
                  : () => _save(existing, allTemplates: allTemplates),
              child: Text(_isSaving ? 'Saving...' : 'Save Exercise'),
            ),
            if (existing != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isSaving ? null : () => _delete(existing!),
                child: const Text('Delete Exercise'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _hydrate(ExerciseTemplateModel existing) {
    _didHydrate = true;
    _nameController.text = existing.name;
    _mediaUrlController.text = existing.mediaUrl ?? '';
    _notesController.text = existing.notes ?? '';
    _mediaType = existing.mediaType;
    _muscleGroup = existing.muscleGroup;
    _specificMuscle = existing.specificMuscle;
    _defaultDifficulty = existing.defaultDifficulty;
    _equipment = existing.equipment;
    _isCompound = existing.isCompound;
    _compoundTemplateIds
      ..clear()
      ..addAll(existing.compoundExerciseTemplateIds);

    final progression = existing.progressionSettings;
    if (progression != null) {
      _minRepsController.text = progression.minReps?.toString() ?? '';
      _maxRepsController.text = progression.maxReps?.toString() ?? '';
      _targetSetsController.text = progression.targetSets?.toString() ?? '';
      _progressionStepController.text =
          progression.progressionStep?.toString() ?? '';
    }
  }

  Future<void> _save(
    ExerciseTemplateModel? existing, {
    required List<ExerciseTemplateModel> allTemplates,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final compoundOptions = _compoundTemplateOptions(
      allTemplates,
      editingTemplateId: existing?.id,
    );
    final validCompoundIds =
        _compoundTemplateIds
            .where((id) => compoundOptions.any((template) => template.id == id))
            .toList(growable: false)
          ..sort();

    if (_isCompound && validCompoundIds.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least 2 exercises for a compound workout.'),
        ),
      );
      return;
    }

    final compoundComponents = compoundOptions
        .where((template) => validCompoundIds.contains(template.id))
        .toList(growable: false);
    final compoundTarget = _deriveCompoundTarget(compoundComponents);

    setState(() {
      _isSaving = true;
    });

    final repository = ref.read(exerciseTemplateRepositoryProvider);
    final model = existing ?? ExerciseTemplateModel();
    final progression = _buildProgressionSettings();

    model
      ..name = _nameController.text.trim()
      ..mediaType = _mediaType
      ..mediaUrl = _nullIfEmpty(_mediaUrlController.text)
      ..muscleGroup = _isCompound ? compoundTarget.muscleGroup : _muscleGroup
      ..specificMuscle = _isCompound
          ? compoundTarget.specificMuscle
          : _specificMuscle
      ..defaultDifficulty = _defaultDifficulty
      ..equipment = _equipment
      ..notes = _nullIfEmpty(_notesController.text)
      ..isCompound = _isCompound
      ..compoundExerciseTemplateIds = _isCompound
          ? validCompoundIds
          : const <int>[]
      ..progressionSettings = progression;

    await repository.save(model);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  List<ExerciseTemplateModel> _compoundTemplateOptions(
    List<ExerciseTemplateModel> allTemplates, {
    int? editingTemplateId,
  }) {
    final options = allTemplates.where((template) {
      if (template.isCompound) {
        return false;
      }
      if (editingTemplateId != null && template.id == editingTemplateId) {
        return false;
      }
      return true;
    }).toList();

    options.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return options;
  }

  ({MuscleGroup muscleGroup, SpecificMuscle specificMuscle})
  _deriveCompoundTarget(List<ExerciseTemplateModel> components) {
    if (components.isEmpty) {
      return (
        muscleGroup: MuscleGroup.fullBody,
        specificMuscle: SpecificMuscle.fullBody,
      );
    }

    final groups = components.map((template) => template.muscleGroup).toSet();
    final specifics = components
        .map((template) => template.specificMuscle)
        .toSet();

    if (groups.length == 1 && specifics.length == 1) {
      return (muscleGroup: groups.first, specificMuscle: specifics.first);
    }

    return (
      muscleGroup: MuscleGroup.fullBody,
      specificMuscle: SpecificMuscle.fullBody,
    );
  }

  Future<void> _delete(ExerciseTemplateModel existing) async {
    setState(() {
      _isSaving = true;
    });

    final repository = ref.read(exerciseTemplateRepositoryProvider);
    await repository.softDelete(existing.id);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  ProgressionSettingsModel? _buildProgressionSettings() {
    final minReps = int.tryParse(_minRepsController.text.trim());
    final maxReps = int.tryParse(_maxRepsController.text.trim());
    final targetSets = int.tryParse(_targetSetsController.text.trim());
    final progressionStep = double.tryParse(
      _progressionStepController.text.trim(),
    );

    final hasAnyValue =
        minReps != null ||
        maxReps != null ||
        targetSets != null ||
        progressionStep != null;

    if (!hasAnyValue) {
      return null;
    }

    return ProgressionSettingsModel()
      ..minReps = minReps
      ..maxReps = maxReps
      ..targetSets = targetSets
      ..progressionStep = progressionStep;
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _CompoundExercisePicker extends StatelessWidget {
  const _CompoundExercisePicker({
    required this.options,
    required this.selectedTemplateIds,
    required this.onToggleTemplate,
  });

  final List<ExerciseTemplateModel> options;
  final Set<int> selectedTemplateIds;
  final void Function(int templateId, bool selected) onToggleTemplate;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Add regular exercises first, then you can compose them into a compound workout.',
          ),
        ),
      );
    }

    final selectedCount = options
        .where((template) => selectedTemplateIds.contains(template.id))
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compound exercises',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: options.length,
              separatorBuilder: (_, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final template = options[index];
                return CheckboxListTile(
                  value: selectedTemplateIds.contains(template.id),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(template.name),
                  subtitle: Text(
                    '${template.muscleGroup.label} • ${template.specificMuscle.label}',
                  ),
                  onChanged: (value) {
                    onToggleTemplate(template.id, value ?? false);
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('$selectedCount selected'),
      ],
    );
  }
}
