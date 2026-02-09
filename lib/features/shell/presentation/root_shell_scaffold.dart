import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootShellScaffold extends StatelessWidget {
  const RootShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.local_fire_department), label: 'Heatmap'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Library'),
        ],
      ),
    );
  }
}
