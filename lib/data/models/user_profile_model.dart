import 'package:isar/isar.dart';

part 'user_profile_model.g.dart';

enum UserGender { female, male, nonBinary, preferNotToSay }

enum WeightUnit { kg, lb }

enum HeightUnit { cm, inch }

extension UserGenderLabel on UserGender {
  String get label {
    switch (this) {
      case UserGender.female:
        return 'Female';
      case UserGender.male:
        return 'Male';
      case UserGender.nonBinary:
        return 'Non-binary';
      case UserGender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

extension WeightUnitLabel on WeightUnit {
  String get label {
    switch (this) {
      case WeightUnit.kg:
        return 'kg';
      case WeightUnit.lb:
        return 'lb';
    }
  }
}

extension HeightUnitLabel on HeightUnit {
  String get label {
    switch (this) {
      case HeightUnit.cm:
        return 'cm';
      case HeightUnit.inch:
        return 'in';
    }
  }
}

@Collection(accessor: 'userProfiles')
class UserProfileModel {
  UserProfileModel();

  // Single profile per authenticated local user for v1.
  Id id = 1;

  double weight = 0;
  double height = 0;
  int age = 0;

  @Enumerated(EnumType.name)
  UserGender? gender;

  @Enumerated(EnumType.name)
  WeightUnit weightUnit = WeightUnit.kg;

  @Enumerated(EnumType.name)
  HeightUnit heightUnit = HeightUnit.cm;

  late DateTime createdAt;
  late DateTime updatedAt;

  bool get isComplete {
    return weight > 0 && height > 0 && age > 0 && gender != null;
  }
}
