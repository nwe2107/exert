import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../core/enums/app_enums.dart';
import '../../../data/models/exercise_template_model.dart';

class ExerciseTemplateFormScreen extends ConsumerStatefulWidget {
  const ExerciseTemplateFormScreen({
    super.key,
    this.templateId,
  });

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

    ExerciseTemplateModel? existing;
    if (widget.templateId != null && allTemplatesAsync is AsyncData) {
      for (final candidate in allTemplatesAsync.value ?? const <ExerciseTemplateModel>[]) {
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
    final specificOptions =
        specificMusclesByGroup[_muscleGroup] ?? const <SpecificMuscle>[];

    if (!specificOptions.contains(_specificMuscle) && specificOptions.isNotEmpty) {
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
              onPressed: _isSaving ? null : () => _save(existing),
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

    final progression = existing.progressionSettings;
    if (progression != null) {
      _minRepsController.text = progression.minReps?.toString() ?? '';
      _maxRepsController.text = progression.maxReps?.toString() ?? '';
      _targetSetsController.text = progression.targetSets?.toString() ?? '';
      _progressionStepController.text =
          progression.progressionStep?.toString() ?? '';
    }
  }

  Future<void> _save(ExerciseTemplateModel? existing) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
      ..muscleGroup = _muscleGroup
      ..specificMuscle = _specificMuscle
      ..defaultDifficulty = _defaultDifficulty
      ..equipment = _equipment
      ..notes = _nullIfEmpty(_notesController.text)
      ..progressionSettings = progression;

    await repository.save(model);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
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
    final progressionStep = double.tryParse(_progressionStepController.text.trim());

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
