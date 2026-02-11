import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/auth_redirect.dart';
import '../../../application/app_providers.dart';
import '../../../data/models/user_profile_model.dart';

const onboardingGenderFieldKey = ValueKey('onboarding-gender-field');
const onboardingAgeFieldKey = ValueKey('onboarding-age-field');
const onboardingHeightFieldKey = ValueKey('onboarding-height-field');
const onboardingWeightFieldKey = ValueKey('onboarding-weight-field');
const onboardingHeightUnitFieldKey = ValueKey('onboarding-height-unit-field');
const onboardingWeightUnitFieldKey = ValueKey('onboarding-weight-unit-field');
const onboardingBackButtonKey = ValueKey('onboarding-back-button');
const onboardingNextButtonKey = ValueKey('onboarding-next-button');
const onboardingFinishButtonKey = ValueKey('onboarding-finish-button');

class GetStartedQuestionnaireScreen extends ConsumerStatefulWidget {
  const GetStartedQuestionnaireScreen({super.key});

  @override
  ConsumerState<GetStartedQuestionnaireScreen> createState() =>
      _GetStartedQuestionnaireScreenState();
}

class _GetStartedQuestionnaireScreenState
    extends ConsumerState<GetStartedQuestionnaireScreen> {
  static const int _totalSteps = 4;
  static const int _lastStepIndex = _totalSteps - 1;

  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  UserGender? _selectedGender;
  HeightUnit _selectedHeightUnit = HeightUnit.cm;
  WeightUnit _selectedWeightUnit = WeightUnit.kg;

  UserProfileModel? _existingProfile;
  int _currentStep = 0;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tell us about you',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / _totalSteps,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _StepCard(
                            key: ValueKey(_currentStep),
                            title: _titleForStep(_currentStep),
                            subtitle: _subtitleForStep(_currentStep),
                            child: _fieldForStep(_currentStep),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            key: onboardingBackButtonKey,
                            onPressed: _currentStep == 0 || _isSaving
                                ? null
                                : _onBackPressed,
                            child: const Text('Back'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            key: _currentStep == _lastStepIndex
                                ? onboardingFinishButtonKey
                                : onboardingNextButtonKey,
                            onPressed: _isSaving
                                ? null
                                : (_currentStep == _lastStepIndex
                                      ? _onFinishPressed
                                      : _onNextPressed),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _currentStep == _lastStepIndex
                                        ? 'Finish'
                                        : 'Next',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _loadExistingProfile() async {
    final profile = await ref.read(userProfileRepositoryProvider).getProfile();
    if (!mounted) {
      return;
    }

    if (profile != null) {
      _existingProfile = profile;
      _selectedGender = profile.gender;
      _selectedHeightUnit = profile.heightUnit;
      _selectedWeightUnit = profile.weightUnit;
      if (profile.age > 0) {
        _ageController.text = '${profile.age}';
      }
      if (profile.height > 0) {
        _heightController.text = _formatDouble(profile.height);
      }
      if (profile.weight > 0) {
        _weightController.text = _formatDouble(profile.weight);
      }
      _currentStep = _initialStepForLoadedProfile();
    }

    setState(() {
      _isLoading = false;
    });
  }

  int _initialStepForLoadedProfile() {
    if (_selectedGender == null) {
      return 0;
    }
    if (_validateAge(_ageController.text) != null) {
      return 1;
    }
    if (_validateHeight(_heightController.text) != null) {
      return 2;
    }
    return 3;
  }

  void _onBackPressed() {
    if (_currentStep == 0) {
      return;
    }
    setState(() {
      _currentStep -= 1;
    });
  }

  void _onNextPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _currentStep += 1;
    });
  }

  Future<void> _onFinishPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_selectedGender == null) {
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    if (age == null || height == null || weight == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final profile = UserProfileModel()
      ..id = _existingProfile?.id ?? 1
      ..gender = _selectedGender
      ..age = age
      ..height = height
      ..weight = weight
      ..heightUnit = _selectedHeightUnit
      ..weightUnit = _selectedWeightUnit;

    try {
      await ref.read(userProfileRepositoryProvider).saveProfile(profile);
      if (!mounted) {
        return;
      }
      context.go(todayRoutePath);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to save personal information. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _titleForStep(int step) {
    switch (step) {
      case 0:
        return 'What is your gender?';
      case 1:
        return 'How old are you?';
      case 2:
        return 'What is your height?';
      default:
        return 'What is your weight?';
    }
  }

  String _subtitleForStep(int step) {
    switch (step) {
      case 0:
        return 'This helps us personalize your profile.';
      case 1:
        return 'Enter your age in whole years.';
      case 2:
        return 'Choose your preferred unit and enter a value.';
      default:
        return 'Choose your preferred unit and enter a value.';
    }
  }

  Widget _fieldForStep(int step) {
    switch (step) {
      case 0:
        return DropdownButtonFormField<UserGender>(
          key: onboardingGenderFieldKey,
          initialValue: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          items: UserGender.values
              .map(
                (gender) => DropdownMenuItem<UserGender>(
                  value: gender,
                  child: Text(gender.label),
                ),
              )
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Gender is required.';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        );
      case 1:
        return TextFormField(
          key: onboardingAgeFieldKey,
          controller: _ageController,
          decoration: const InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: _validateAge,
        );
      case 2:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<HeightUnit>(
              key: onboardingHeightUnitFieldKey,
              initialValue: _selectedHeightUnit,
              decoration: const InputDecoration(
                labelText: 'Height unit',
                border: OutlineInputBorder(),
              ),
              items: HeightUnit.values
                  .map(
                    (unit) => DropdownMenuItem<HeightUnit>(
                      value: unit,
                      child: Text(unit.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedHeightUnit = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: onboardingHeightFieldKey,
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height',
                border: const OutlineInputBorder(),
                suffixText: _selectedHeightUnit.label,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateHeight,
            ),
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<WeightUnit>(
              key: onboardingWeightUnitFieldKey,
              initialValue: _selectedWeightUnit,
              decoration: const InputDecoration(
                labelText: 'Weight unit',
                border: OutlineInputBorder(),
              ),
              items: WeightUnit.values
                  .map(
                    (unit) => DropdownMenuItem<WeightUnit>(
                      value: unit,
                      child: Text(unit.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedWeightUnit = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: onboardingWeightFieldKey,
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight',
                border: const OutlineInputBorder(),
                suffixText: _selectedWeightUnit.label,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateWeight,
            ),
          ],
        );
    }
  }

  String _formatDouble(double value) {
    final rounded = value.toStringAsFixed(1);
    if (rounded.endsWith('.0')) {
      return rounded.substring(0, rounded.length - 2);
    }
    return rounded;
  }

  String? _validateAge(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Age is required.';
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a whole number.';
    }
    if (parsed < 13 || parsed > 120) {
      return 'Age must be between 13 and 120.';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Height is required.';
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number.';
    }

    if (_selectedHeightUnit == HeightUnit.cm) {
      if (parsed < 100 || parsed > 260) {
        return 'Height must be between 100 and 260 cm.';
      }
    } else {
      if (parsed < 39 || parsed > 102) {
        return 'Height must be between 39 and 102 in.';
      }
    }
    return null;
  }

  String? _validateWeight(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Weight is required.';
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number.';
    }

    if (_selectedWeightUnit == WeightUnit.kg) {
      if (parsed < 20 || parsed > 500) {
        return 'Weight must be between 20 and 500 kg.';
      }
    } else {
      if (parsed < 44 || parsed > 1100) {
        return 'Weight must be between 44 and 1100 lb.';
      }
    }
    return null;
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
