import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import '../application/app_providers.dart';

class ExertApp extends ConsumerWidget {
  const ExertApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off seeding defaults on auth change.
    ref.watch(ensureExerciseSeededProvider);

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: 'Exert Discipline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17624A),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17624A),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
