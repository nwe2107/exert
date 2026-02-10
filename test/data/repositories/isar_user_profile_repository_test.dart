import 'dart:io';

import 'package:exert/data/models/user_profile_model.dart';
import 'package:exert/data/repositories/isar_user_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('IsarUserProfileRepository', () {
    test('persists profile values across Isar reopen', () async {
      if (!_isarNativeAvailable()) {
        return;
      }

      final tempDir = await Directory.systemTemp.createTemp(
        'exert_user_profile_test_',
      );
      const dbName = 'user_profile_persistence';
      Isar? isar;

      try {
        isar = await Isar.open(
          [UserProfileModelSchema],
          directory: tempDir.path,
          name: dbName,
          inspector: false,
        );
        final repository = IsarUserProfileRepository(isar);

        final profile = UserProfileModel()
          ..weight = 70.5
          ..height = 176
          ..age = 31
          ..gender = UserGender.female
          ..weightUnit = WeightUnit.kg
          ..heightUnit = HeightUnit.cm;
        await repository.saveProfile(profile);

        await isar.close();

        isar = await Isar.open(
          [UserProfileModelSchema],
          directory: tempDir.path,
          name: dbName,
          inspector: false,
        );
        final reopenedRepository = IsarUserProfileRepository(isar);
        final reopenedProfile = await reopenedRepository.getProfile();

        expect(reopenedProfile, isNotNull);
        expect(reopenedProfile!.weight, 70.5);
        expect(reopenedProfile.height, 176);
        expect(reopenedProfile.age, 31);
        expect(reopenedProfile.gender, UserGender.female);
        expect(reopenedProfile.weightUnit, WeightUnit.kg);
        expect(reopenedProfile.heightUnit, HeightUnit.cm);
      } finally {
        await isar?.close(deleteFromDisk: true);
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });

    test('clearProfile removes persisted profile', () async {
      if (!_isarNativeAvailable()) {
        return;
      }

      final tempDir = await Directory.systemTemp.createTemp(
        'exert_user_profile_clear_test_',
      );
      const dbName = 'user_profile_clear';
      Isar? isar;

      try {
        isar = await Isar.open(
          [UserProfileModelSchema],
          directory: tempDir.path,
          name: dbName,
          inspector: false,
        );
        final repository = IsarUserProfileRepository(isar);

        await repository.saveProfile(
          UserProfileModel()
            ..weight = 80
            ..height = 180
            ..age = 35
            ..gender = UserGender.male,
        );
        expect(await repository.getProfile(), isNotNull);

        await repository.clearProfile();

        expect(await repository.getProfile(), isNull);
      } finally {
        await isar?.close(deleteFromDisk: true);
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });
  });
}

bool _isarNativeAvailable() {
  if (Platform.isMacOS) {
    return File('${Directory.current.path}/libisar.dylib').existsSync();
  }
  if (Platform.isLinux) {
    return File('${Directory.current.path}/libisar.so').existsSync();
  }
  if (Platform.isWindows) {
    return File('${Directory.current.path}\\isar.dll').existsSync();
  }
  return false;
}
