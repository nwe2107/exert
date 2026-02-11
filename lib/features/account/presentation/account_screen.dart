import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/app_providers.dart';
import '../../../data/models/account_profile_model.dart';

const accountBackButtonKey = ValueKey('account-back-button');
const accountSettingsButtonKey = ValueKey('account-settings-button');
const accountProfileButtonKey = ValueKey('account-profile-button');

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(accountProfileProvider);
    final session = ref.watch(authSessionProvider).valueOrNull;
    final profile = profileAsync.valueOrNull;
    final profileStatus = profileAsync.isLoading
        ? 'Loading...'
        : (profile != null ? 'Loaded' : 'Missing');

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
                          'Account profile',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('Status: $profileStatus'),
                        if (profileAsync.isLoading) ...[
                          const SizedBox(height: 6),
                          const LinearProgressIndicator(),
                        ] else if (profileAsync.hasError) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Failed to load profile. Tap edit to retry.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ] else if (profile != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            profile.displayName.isNotEmpty
                                ? profile.displayName
                                : 'No display name yet',
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            session?.email ?? profile.email,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.onboardingComplete
                                ? 'Onboarding complete'
                                : 'Onboarding incomplete',
                            style: theme.textTheme.bodySmall,
                          ),
                        ] else ...[
                          const SizedBox(height: 6),
                          Text(
                            'Set your display name to personalize your account.',
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
            label: const Text('Edit Account Profile'),
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
