import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'application/app_providers.dart';
import 'data/local/isar_service.dart';
import 'data/repositories/isar_exercise_template_repository.dart';
import 'data/seeding/seed_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await IsarService.open();

  final seedRepository = IsarExerciseTemplateRepository(isar);
  final seedService = SeedService(seedRepository);
  await seedService.seedIfNeeded();

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const ExertApp(),
    ),
  );
}
