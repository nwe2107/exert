import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/app_enums.dart';
import 'library_providers.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late final TextEditingController _searchController;
  String? _lastAppliedRouteMuscle;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _syncFiltersFromRoute();

    final templatesAsync = ref.watch(filteredLibraryTemplatesProvider);
    final selectedGroup = ref.watch(libraryMuscleFilterProvider);
    final selectedSpecificMuscle = ref.watch(
      librarySpecificMuscleFilterProvider,
    );
    final searchQuery = ref.watch(librarySearchQueryProvider).trim();
    final specificOptions = _specificOptionsForGroup(selectedGroup);
    final visibleSpecificMuscle =
        selectedSpecificMuscle != null &&
            specificOptions.contains(selectedSpecificMuscle)
        ? selectedSpecificMuscle
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/library/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(librarySearchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search exercises',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: DropdownButtonFormField<MuscleGroup?>(
              key: ValueKey('group_${selectedGroup?.name ?? 'all'}'),
              initialValue: selectedGroup,
              decoration: const InputDecoration(
                labelText: 'Filter by muscle group',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<MuscleGroup?>(
                  value: null,
                  child: Text('All groups'),
                ),
                ...MuscleGroup.values.map(
                  (group) => DropdownMenuItem<MuscleGroup?>(
                    value: group,
                    child: Text(group.label),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(libraryMuscleFilterProvider.notifier).state = value;
                final selectedSpecific = ref.read(
                  librarySpecificMuscleFilterProvider,
                );
                final isStillValid =
                    value != null &&
                    selectedSpecific != null &&
                    (specificMusclesByGroup[value]?.contains(
                          selectedSpecific,
                        ) ??
                        false);
                if (!isStillValid) {
                  ref.read(librarySpecificMuscleFilterProvider.notifier).state =
                      null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: DropdownButtonFormField<SpecificMuscle?>(
              key: ValueKey(
                'specific_${selectedGroup?.name ?? 'all'}_${visibleSpecificMuscle?.name ?? 'all'}',
              ),
              initialValue: visibleSpecificMuscle,
              decoration: const InputDecoration(
                labelText: 'Filter by specific muscle',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<SpecificMuscle?>(
                  value: null,
                  child: Text('All muscles'),
                ),
                ...specificOptions.map(
                  (muscle) => DropdownMenuItem<SpecificMuscle?>(
                    value: muscle,
                    child: Text(muscle.label),
                  ),
                ),
              ],
              onChanged: (value) {
                ref.read(librarySpecificMuscleFilterProvider.notifier).state =
                    value;
                if (value != null) {
                  ref.read(libraryMuscleFilterProvider.notifier).state =
                      _groupForSpecificMuscle(value);
                }
              },
            ),
          ),
          Expanded(
            child: templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  final hasActiveFilters =
                      searchQuery.isNotEmpty ||
                      selectedGroup != null ||
                      selectedSpecificMuscle != null;
                  return Center(
                    child: Text(
                      hasActiveFilters
                          ? 'No exercises match the selected filters.'
                          : 'No exercises found. Add your first template.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerLow,
                      title: Text(template.name),
                      subtitle: Text(
                        template.isCompound
                            ? 'Compound • ${template.compoundExerciseTemplateIds.length} exercises'
                            : '${template.muscleGroup.label} • ${template.specificMuscle.label}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/library/edit/${template.id}'),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: templates.length,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                return Center(child: Text('Failed to load templates: $error'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _syncFiltersFromRoute() {
    final routeMuscle = GoRouterState.of(context).uri.queryParameters['muscle'];
    if (_lastAppliedRouteMuscle == routeMuscle) {
      return;
    }
    _lastAppliedRouteMuscle = routeMuscle;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final parsedMuscle = _parseSpecificMuscle(routeMuscle);
      ref.read(librarySpecificMuscleFilterProvider.notifier).state =
          parsedMuscle;
      ref.read(libraryMuscleFilterProvider.notifier).state =
          parsedMuscle == null ? null : _groupForSpecificMuscle(parsedMuscle);
    });
  }

  static List<SpecificMuscle> _specificOptionsForGroup(MuscleGroup? group) {
    if (group == null) {
      return SpecificMuscle.values;
    }
    return specificMusclesByGroup[group] ?? const <SpecificMuscle>[];
  }

  static SpecificMuscle? _parseSpecificMuscle(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    for (final muscle in SpecificMuscle.values) {
      if (muscle.name == raw) {
        return muscle;
      }
    }
    return null;
  }

  static MuscleGroup _groupForSpecificMuscle(SpecificMuscle muscle) {
    for (final entry in specificMusclesByGroup.entries) {
      if (entry.value.contains(muscle)) {
        return entry.key;
      }
    }
    return MuscleGroup.fullBody;
  }
}
