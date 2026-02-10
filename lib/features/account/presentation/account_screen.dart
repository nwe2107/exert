import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/app_providers.dart';
import '../../../data/models/user_profile_model.dart';

const accountBackButtonKey = ValueKey('account-back-button');
const accountSettingsButtonKey = ValueKey('account-settings-button');
const accountProfileButtonKey = ValueKey('account-profile-button');

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.valueOrNull;
    final isProfileComplete = profile?.isComplete ?? false;
    final statusLabel = isProfileComplete ? 'Complete' : 'Incomplete';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: accountBackButtonKey,
          tooltip: 'Back to Today',
          onPressed: () => context.go('/today'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile summary',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: $statusLabel',
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (profileAsync.isLoading) ...[
                          const SizedBox(height: 6),
                          const LinearProgressIndicator(),
                        ] else if (isProfileComplete) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${profile!.weight.toStringAsFixed(1)} ${profile.weightUnit.label} • '
                            '${profile.height.toStringAsFixed(1)} ${profile.heightUnit.label} • '
                            'Age ${profile.age} • ${profile.gender!.label}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ] else ...[
                          const SizedBox(height: 6),
                          Text(
                            'Add your personal metrics to personalize your account.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: accountProfileButtonKey,
            onPressed: () => context.push('/account/profile'),
            icon: const Icon(Icons.badge_outlined),
            label: Text(
              isProfileComplete
                  ? 'Edit Personal Info'
                  : 'Complete Personal Info',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            key: accountSettingsButtonKey,
            onPressed: () => context.push('/account/settings'),
            icon: const Icon(Icons.settings),
            label: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
