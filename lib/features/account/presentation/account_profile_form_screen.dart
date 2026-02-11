import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../data/models/account_profile_model.dart';
import '../../../domain/repositories/account_profile_repository.dart';

const accountDisplayNameFieldKey = ValueKey('account-display-name-field');
const accountOnboardingToggleKey = ValueKey('account-onboarding-toggle');
const accountProfileSaveButtonKey = ValueKey('account-profile-save-button');

class AccountProfileFormScreen extends ConsumerStatefulWidget {
  const AccountProfileFormScreen({super.key});

  @override
  ConsumerState<AccountProfileFormScreen> createState() =>
      _AccountProfileFormScreenState();
}

class _AccountProfileFormScreenState
    extends ConsumerState<AccountProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();

  bool _onboardingComplete = false;
  bool _isSaving = false;
  bool _initializedFromProfile = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(accountProfileProvider);
    final session = ref.watch(authSessionProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(error: error.toString()),
        data: (profile) {
          final email = session?.email ?? profile?.email ?? '';

          if (!_initializedFromProfile && profile != null) {
            _displayNameController.text = profile.displayName;
            _onboardingComplete = profile.onboardingComplete;
            _initializedFromProfile = true;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile basics',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          key: accountDisplayNameFieldKey,
                          controller: _displayNameController,
                          decoration: const InputDecoration(
                            labelText: 'Display name',
                            border: OutlineInputBorder(),
                            hintText: 'How should we address you?',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Display name is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: email,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          key: accountOnboardingToggleKey,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Onboarding complete'),
                          subtitle: const Text(
                            'Mark as complete when your basic profile is set.',
                          ),
                          value: _onboardingComplete,
                          onChanged: (value) {
                            setState(() => _onboardingComplete = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            key: accountProfileSaveButtonKey,
                            onPressed: _isSaving || session == null
                                ? null
                                : _onSave,
                            child: _isSaving
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Saving...'),
                                    ],
                                  )
                                : const Text('Save changes'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final session = ref.read(authSessionProvider).valueOrNull;
    if (session == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final repository = ref.read(accountProfileRepositoryProvider);
    final now = DateTime.now();
    final profile = AccountProfileModel(
      uid: session.userId,
      email: session.email,
      displayName: _displayNameController.text.trim(),
      onboardingComplete: _onboardingComplete,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await repository.saveProfile(profile);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated.')));
      }
    } on AccountProfileException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 32),
          const SizedBox(height: 8),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
