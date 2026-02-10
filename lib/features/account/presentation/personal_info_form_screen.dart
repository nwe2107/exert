import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/app_providers.dart';
import '../../../data/models/user_profile_model.dart';

const profileWeightFieldKey = ValueKey('profile-weight-field');
const profileHeightFieldKey = ValueKey('profile-height-field');
const profileAgeFieldKey = ValueKey('profile-age-field');
const profileGenderFieldKey = ValueKey('profile-gender-field');
const profileWeightUnitFieldKey = ValueKey('profile-weight-unit-field');
const profileHeightUnitFieldKey = ValueKey('profile-height-unit-field');
const profileSaveButtonKey = ValueKey('profile-save-button');

class PersonalInfoFormScreen extends ConsumerStatefulWidget {
  const PersonalInfoFormScreen({super.key});

  @override
  ConsumerState<PersonalInfoFormScreen> createState() =>
      _PersonalInfoFormScreenState();
}

class _PersonalInfoFormScreenState
    extends ConsumerState<PersonalInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  UserGender? _selectedGender;
  WeightUnit _selectedWeightUnit = WeightUnit.kg;
  HeightUnit _selectedHeightUnit = HeightUnit.cm;

  UserProfileModel? _existingProfile;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _showSavedState = false;
  Timer? _savedStateTimer;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _savedStateTimer?.cancel();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                            'Personal metrics',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Used for account personalization. All fields are required.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: profileWeightFieldKey,
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
                          const SizedBox(height: 12),
                          DropdownButtonFormField<WeightUnit>(
                            key: profileWeightUnitFieldKey,
                            initialValue: _selectedWeightUnit,
                            decoration: const InputDecoration(
                              labelText: 'Weight unit (optional preference)',
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
                            key: profileHeightFieldKey,
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
                          const SizedBox(height: 12),
                          DropdownButtonFormField<HeightUnit>(
                            key: profileHeightUnitFieldKey,
                            initialValue: _selectedHeightUnit,
                            decoration: const InputDecoration(
                              labelText: 'Height unit (optional preference)',
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
                            key: profileAgeFieldKey,
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: _validateAge,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<UserGender>(
                            key: profileGenderFieldKey,
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
                          ),
                          const SizedBox(height: 16),
                          if (_showSavedState) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text('Saved successfully'),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              key: profileSaveButtonKey,
                              onPressed: _isSaving ? null : _onSavePressed,
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
                                  : const Text('Save Personal Information'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      _weightController.text = _formatDouble(profile.weight);
      _heightController.text = _formatDouble(profile.height);
      _ageController.text = '${profile.age}';
      _selectedGender = profile.gender;
      _selectedWeightUnit = profile.weightUnit;
      _selectedHeightUnit = profile.heightUnit;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedGender == null) {
      return;
    }

    final parsedWeight = double.tryParse(_weightController.text.trim());
    final parsedHeight = double.tryParse(_heightController.text.trim());
    final parsedAge = int.tryParse(_ageController.text.trim());
    if (parsedWeight == null || parsedHeight == null || parsedAge == null) {
      return;
    }

    setState(() {
      _isSaving = true;
      _showSavedState = false;
    });

    final profile = UserProfileModel()
      ..id = _existingProfile?.id ?? 1
      ..weight = parsedWeight
      ..height = parsedHeight
      ..age = parsedAge
      ..gender = _selectedGender
      ..weightUnit = _selectedWeightUnit
      ..heightUnit = _selectedHeightUnit;

    try {
      await ref.read(userProfileRepositoryProvider).saveProfile(profile);

      if (!mounted) {
        return;
      }

      _existingProfile = profile;
      _savedStateTimer?.cancel();
      setState(() {
        _showSavedState = true;
      });
      _savedStateTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showSavedState = false;
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personal information saved.')),
      );
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

  String _formatDouble(double value) {
    final rounded = value.toStringAsFixed(1);
    if (rounded.endsWith('.0')) {
      return rounded.substring(0, rounded.length - 2);
    }
    return rounded;
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
}
