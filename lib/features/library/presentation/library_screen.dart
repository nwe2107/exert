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
    final templatesAsync = ref.watch(filteredLibraryTemplatesProvider);
    final selectedGroup = ref.watch(libraryMuscleFilterProvider);

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
              },
            ),
          ),
          Expanded(
            child: templatesAsync.when(
              data: (templates) {
                if (templates.isEmpty) {
                  return const Center(
                    child: Text('No exercises found. Add your first template.'),
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
}
