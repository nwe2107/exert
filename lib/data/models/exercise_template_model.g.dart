// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_template_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseTemplateModelCollection on Isar {
  IsarCollection<ExerciseTemplateModel> get exerciseTemplates =>
      this.collection();
}

const ExerciseTemplateModelSchema = CollectionSchema(
  name: r'ExerciseTemplateModel',
  id: 3623981952408253446,
  properties: {
    r'compoundExerciseTemplateIds': PropertySchema(
      id: 0,
      name: r'compoundExerciseTemplateIds',
      type: IsarType.longList,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'defaultDifficulty': PropertySchema(
      id: 2,
      name: r'defaultDifficulty',
      type: IsarType.string,
      enumMap: _ExerciseTemplateModeldefaultDifficultyEnumValueMap,
    ),
    r'deletedAt': PropertySchema(
      id: 3,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'equipment': PropertySchema(
      id: 4,
      name: r'equipment',
      type: IsarType.string,
      enumMap: _ExerciseTemplateModelequipmentEnumValueMap,
    ),
    r'isCompound': PropertySchema(
      id: 5,
      name: r'isCompound',
      type: IsarType.bool,
    ),
    r'lowercaseName': PropertySchema(
      id: 6,
      name: r'lowercaseName',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 7,
      name: r'mediaType',
      type: IsarType.string,
      enumMap: _ExerciseTemplateModelmediaTypeEnumValueMap,
    ),
    r'mediaUrl': PropertySchema(
      id: 8,
      name: r'mediaUrl',
      type: IsarType.string,
    ),
    r'muscleGroup': PropertySchema(
      id: 9,
      name: r'muscleGroup',
      type: IsarType.string,
      enumMap: _ExerciseTemplateModelmuscleGroupEnumValueMap,
    ),
    r'muscleGroups': PropertySchema(
      id: 10,
      name: r'muscleGroups',
      type: IsarType.stringList,
      enumMap: _ExerciseTemplateModelmuscleGroupsEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 12,
      name: r'notes',
      type: IsarType.string,
    ),
    r'progressionSettings': PropertySchema(
      id: 13,
      name: r'progressionSettings',
      type: IsarType.object,
      target: r'ProgressionSettingsModel',
    ),
    r'specificMuscle': PropertySchema(
      id: 14,
      name: r'specificMuscle',
      type: IsarType.string,
      enumMap: _ExerciseTemplateModelspecificMuscleEnumValueMap,
    ),
    r'specificMuscles': PropertySchema(
      id: 15,
      name: r'specificMuscles',
      type: IsarType.stringList,
      enumMap: _ExerciseTemplateModelspecificMusclesEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _exerciseTemplateModelEstimateSize,
  serialize: _exerciseTemplateModelSerialize,
  deserialize: _exerciseTemplateModelDeserialize,
  deserializeProp: _exerciseTemplateModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'lowercaseName': IndexSchema(
      id: 413724704772840086,
      name: r'lowercaseName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lowercaseName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'ProgressionSettingsModel': ProgressionSettingsModelSchema
  },
  getId: _exerciseTemplateModelGetId,
  getLinks: _exerciseTemplateModelGetLinks,
  attach: _exerciseTemplateModelAttach,
  version: '3.1.0+1',
);

int _exerciseTemplateModelEstimateSize(
  ExerciseTemplateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.compoundExerciseTemplateIds.length * 8;
  bytesCount += 3 + object.defaultDifficulty.name.length * 3;
  {
    final value = object.equipment;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.lowercaseName.length * 3;
  {
    final value = object.mediaType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.mediaUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.muscleGroup.name.length * 3;
  bytesCount += 3 + object.muscleGroups.length * 3;
  {
    for (var i = 0; i < object.muscleGroups.length; i++) {
      final value = object.muscleGroups[i];
      bytesCount += value.name.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.progressionSettings;
    if (value != null) {
      bytesCount += 3 +
          ProgressionSettingsModelSchema.estimateSize(
              value, allOffsets[ProgressionSettingsModel]!, allOffsets);
    }
  }
  bytesCount += 3 + object.specificMuscle.name.length * 3;
  bytesCount += 3 + object.specificMuscles.length * 3;
  {
    for (var i = 0; i < object.specificMuscles.length; i++) {
      final value = object.specificMuscles[i];
      bytesCount += value.name.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseTemplateModelSerialize(
  ExerciseTemplateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.compoundExerciseTemplateIds);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.defaultDifficulty.name);
  writer.writeDateTime(offsets[3], object.deletedAt);
  writer.writeString(offsets[4], object.equipment?.name);
  writer.writeBool(offsets[5], object.isCompound);
  writer.writeString(offsets[6], object.lowercaseName);
  writer.writeString(offsets[7], object.mediaType?.name);
  writer.writeString(offsets[8], object.mediaUrl);
  writer.writeString(offsets[9], object.muscleGroup.name);
  writer.writeStringList(
      offsets[10], object.muscleGroups.map((e) => e.name).toList());
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.notes);
  writer.writeObject<ProgressionSettingsModel>(
    offsets[13],
    allOffsets,
    ProgressionSettingsModelSchema.serialize,
    object.progressionSettings,
  );
  writer.writeString(offsets[14], object.specificMuscle.name);
  writer.writeStringList(
      offsets[15], object.specificMuscles.map((e) => e.name).toList());
  writer.writeDateTime(offsets[16], object.updatedAt);
}

ExerciseTemplateModel _exerciseTemplateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseTemplateModel();
  object.compoundExerciseTemplateIds = reader.readLongList(offsets[0]) ?? [];
  object.createdAt = reader.readDateTime(offsets[1]);
  object.defaultDifficulty =
      _ExerciseTemplateModeldefaultDifficultyValueEnumMap[
              reader.readStringOrNull(offsets[2])] ??
          DifficultyLevel.easy;
  object.deletedAt = reader.readDateTimeOrNull(offsets[3]);
  object.equipment = _ExerciseTemplateModelequipmentValueEnumMap[
      reader.readStringOrNull(offsets[4])];
  object.id = id;
  object.isCompound = reader.readBool(offsets[5]);
  object.mediaType = _ExerciseTemplateModelmediaTypeValueEnumMap[
      reader.readStringOrNull(offsets[7])];
  object.mediaUrl = reader.readStringOrNull(offsets[8]);
  object.muscleGroup = _ExerciseTemplateModelmuscleGroupValueEnumMap[
          reader.readStringOrNull(offsets[9])] ??
      MuscleGroup.chest;
  object.muscleGroups = reader
          .readStringList(offsets[10])
          ?.map((e) =>
              _ExerciseTemplateModelmuscleGroupsValueEnumMap[e] ??
              MuscleGroup.chest)
          .toList() ??
      [];
  object.name = reader.readString(offsets[11]);
  object.notes = reader.readStringOrNull(offsets[12]);
  object.progressionSettings =
      reader.readObjectOrNull<ProgressionSettingsModel>(
    offsets[13],
    ProgressionSettingsModelSchema.deserialize,
    allOffsets,
  );
  object.specificMuscle = _ExerciseTemplateModelspecificMuscleValueEnumMap[
          reader.readStringOrNull(offsets[14])] ??
      SpecificMuscle.upperChest;
  object.specificMuscles = reader
          .readStringList(offsets[15])
          ?.map((e) =>
              _ExerciseTemplateModelspecificMusclesValueEnumMap[e] ??
              SpecificMuscle.upperChest)
          .toList() ??
      [];
  object.updatedAt = reader.readDateTime(offsets[16]);
  return object;
}

P _exerciseTemplateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_ExerciseTemplateModeldefaultDifficultyValueEnumMap[
              reader.readStringOrNull(offset)] ??
          DifficultyLevel.easy) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (_ExerciseTemplateModelequipmentValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_ExerciseTemplateModelmediaTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_ExerciseTemplateModelmuscleGroupValueEnumMap[
              reader.readStringOrNull(offset)] ??
          MuscleGroup.chest) as P;
    case 10:
      return (reader
              .readStringList(offset)
              ?.map((e) =>
                  _ExerciseTemplateModelmuscleGroupsValueEnumMap[e] ??
                  MuscleGroup.chest)
              .toList() ??
          []) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readObjectOrNull<ProgressionSettingsModel>(
        offset,
        ProgressionSettingsModelSchema.deserialize,
        allOffsets,
      )) as P;
    case 14:
      return (_ExerciseTemplateModelspecificMuscleValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SpecificMuscle.upperChest) as P;
    case 15:
      return (reader
              .readStringList(offset)
              ?.map((e) =>
                  _ExerciseTemplateModelspecificMusclesValueEnumMap[e] ??
                  SpecificMuscle.upperChest)
              .toList() ??
          []) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExerciseTemplateModeldefaultDifficultyEnumValueMap = {
  r'easy': r'easy',
  r'moderate': r'moderate',
  r'hard': r'hard',
};
const _ExerciseTemplateModeldefaultDifficultyValueEnumMap = {
  r'easy': DifficultyLevel.easy,
  r'moderate': DifficultyLevel.moderate,
  r'hard': DifficultyLevel.hard,
};
const _ExerciseTemplateModelequipmentEnumValueMap = {
  r'bodyweight': r'bodyweight',
  r'dumbbell': r'dumbbell',
  r'barbell': r'barbell',
  r'kettlebell': r'kettlebell',
  r'machine': r'machine',
  r'cable': r'cable',
  r'band': r'band',
  r'medicineBall': r'medicineBall',
  r'other': r'other',
};
const _ExerciseTemplateModelequipmentValueEnumMap = {
  r'bodyweight': EquipmentType.bodyweight,
  r'dumbbell': EquipmentType.dumbbell,
  r'barbell': EquipmentType.barbell,
  r'kettlebell': EquipmentType.kettlebell,
  r'machine': EquipmentType.machine,
  r'cable': EquipmentType.cable,
  r'band': EquipmentType.band,
  r'medicineBall': EquipmentType.medicineBall,
  r'other': EquipmentType.other,
};
const _ExerciseTemplateModelmediaTypeEnumValueMap = {
  r'photo': r'photo',
  r'video': r'video',
  r'link': r'link',
};
const _ExerciseTemplateModelmediaTypeValueEnumMap = {
  r'photo': MediaType.photo,
  r'video': MediaType.video,
  r'link': MediaType.link,
};
const _ExerciseTemplateModelmuscleGroupEnumValueMap = {
  r'chest': r'chest',
  r'back': r'back',
  r'shoulders': r'shoulders',
  r'arms': r'arms',
  r'legs': r'legs',
  r'glutes': r'glutes',
  r'core': r'core',
  r'cardio': r'cardio',
  r'mobility': r'mobility',
  r'fullBody': r'fullBody',
};
const _ExerciseTemplateModelmuscleGroupValueEnumMap = {
  r'chest': MuscleGroup.chest,
  r'back': MuscleGroup.back,
  r'shoulders': MuscleGroup.shoulders,
  r'arms': MuscleGroup.arms,
  r'legs': MuscleGroup.legs,
  r'glutes': MuscleGroup.glutes,
  r'core': MuscleGroup.core,
  r'cardio': MuscleGroup.cardio,
  r'mobility': MuscleGroup.mobility,
  r'fullBody': MuscleGroup.fullBody,
};
const _ExerciseTemplateModelmuscleGroupsEnumValueMap = {
  r'chest': r'chest',
  r'back': r'back',
  r'shoulders': r'shoulders',
  r'arms': r'arms',
  r'legs': r'legs',
  r'glutes': r'glutes',
  r'core': r'core',
  r'cardio': r'cardio',
  r'mobility': r'mobility',
  r'fullBody': r'fullBody',
};
const _ExerciseTemplateModelmuscleGroupsValueEnumMap = {
  r'chest': MuscleGroup.chest,
  r'back': MuscleGroup.back,
  r'shoulders': MuscleGroup.shoulders,
  r'arms': MuscleGroup.arms,
  r'legs': MuscleGroup.legs,
  r'glutes': MuscleGroup.glutes,
  r'core': MuscleGroup.core,
  r'cardio': MuscleGroup.cardio,
  r'mobility': MuscleGroup.mobility,
  r'fullBody': MuscleGroup.fullBody,
};
const _ExerciseTemplateModelspecificMuscleEnumValueMap = {
  r'upperChest': r'upperChest',
  r'midChest': r'midChest',
  r'lowerChest': r'lowerChest',
  r'lats': r'lats',
  r'rhomboids': r'rhomboids',
  r'traps': r'traps',
  r'lowerBack': r'lowerBack',
  r'frontDelts': r'frontDelts',
  r'sideDelts': r'sideDelts',
  r'rearDelts': r'rearDelts',
  r'biceps': r'biceps',
  r'triceps': r'triceps',
  r'forearms': r'forearms',
  r'quads': r'quads',
  r'hamstrings': r'hamstrings',
  r'calves': r'calves',
  r'adductors': r'adductors',
  r'gluteMax': r'gluteMax',
  r'gluteMed': r'gluteMed',
  r'abs': r'abs',
  r'obliques': r'obliques',
  r'spinalErectors': r'spinalErectors',
  r'aerobic': r'aerobic',
  r'anaerobic': r'anaerobic',
  r'hips': r'hips',
  r'thoracic': r'thoracic',
  r'ankles': r'ankles',
  r'fullBody': r'fullBody',
};
const _ExerciseTemplateModelspecificMuscleValueEnumMap = {
  r'upperChest': SpecificMuscle.upperChest,
  r'midChest': SpecificMuscle.midChest,
  r'lowerChest': SpecificMuscle.lowerChest,
  r'lats': SpecificMuscle.lats,
  r'rhomboids': SpecificMuscle.rhomboids,
  r'traps': SpecificMuscle.traps,
  r'lowerBack': SpecificMuscle.lowerBack,
  r'frontDelts': SpecificMuscle.frontDelts,
  r'sideDelts': SpecificMuscle.sideDelts,
  r'rearDelts': SpecificMuscle.rearDelts,
  r'biceps': SpecificMuscle.biceps,
  r'triceps': SpecificMuscle.triceps,
  r'forearms': SpecificMuscle.forearms,
  r'quads': SpecificMuscle.quads,
  r'hamstrings': SpecificMuscle.hamstrings,
  r'calves': SpecificMuscle.calves,
  r'adductors': SpecificMuscle.adductors,
  r'gluteMax': SpecificMuscle.gluteMax,
  r'gluteMed': SpecificMuscle.gluteMed,
  r'abs': SpecificMuscle.abs,
  r'obliques': SpecificMuscle.obliques,
  r'spinalErectors': SpecificMuscle.spinalErectors,
  r'aerobic': SpecificMuscle.aerobic,
  r'anaerobic': SpecificMuscle.anaerobic,
  r'hips': SpecificMuscle.hips,
  r'thoracic': SpecificMuscle.thoracic,
  r'ankles': SpecificMuscle.ankles,
  r'fullBody': SpecificMuscle.fullBody,
};
const _ExerciseTemplateModelspecificMusclesEnumValueMap = {
  r'upperChest': r'upperChest',
  r'midChest': r'midChest',
  r'lowerChest': r'lowerChest',
  r'lats': r'lats',
  r'rhomboids': r'rhomboids',
  r'traps': r'traps',
  r'lowerBack': r'lowerBack',
  r'frontDelts': r'frontDelts',
  r'sideDelts': r'sideDelts',
  r'rearDelts': r'rearDelts',
  r'biceps': r'biceps',
  r'triceps': r'triceps',
  r'forearms': r'forearms',
  r'quads': r'quads',
  r'hamstrings': r'hamstrings',
  r'calves': r'calves',
  r'adductors': r'adductors',
  r'gluteMax': r'gluteMax',
  r'gluteMed': r'gluteMed',
  r'abs': r'abs',
  r'obliques': r'obliques',
  r'spinalErectors': r'spinalErectors',
  r'aerobic': r'aerobic',
  r'anaerobic': r'anaerobic',
  r'hips': r'hips',
  r'thoracic': r'thoracic',
  r'ankles': r'ankles',
  r'fullBody': r'fullBody',
};
const _ExerciseTemplateModelspecificMusclesValueEnumMap = {
  r'upperChest': SpecificMuscle.upperChest,
  r'midChest': SpecificMuscle.midChest,
  r'lowerChest': SpecificMuscle.lowerChest,
  r'lats': SpecificMuscle.lats,
  r'rhomboids': SpecificMuscle.rhomboids,
  r'traps': SpecificMuscle.traps,
  r'lowerBack': SpecificMuscle.lowerBack,
  r'frontDelts': SpecificMuscle.frontDelts,
  r'sideDelts': SpecificMuscle.sideDelts,
  r'rearDelts': SpecificMuscle.rearDelts,
  r'biceps': SpecificMuscle.biceps,
  r'triceps': SpecificMuscle.triceps,
  r'forearms': SpecificMuscle.forearms,
  r'quads': SpecificMuscle.quads,
  r'hamstrings': SpecificMuscle.hamstrings,
  r'calves': SpecificMuscle.calves,
  r'adductors': SpecificMuscle.adductors,
  r'gluteMax': SpecificMuscle.gluteMax,
  r'gluteMed': SpecificMuscle.gluteMed,
  r'abs': SpecificMuscle.abs,
  r'obliques': SpecificMuscle.obliques,
  r'spinalErectors': SpecificMuscle.spinalErectors,
  r'aerobic': SpecificMuscle.aerobic,
  r'anaerobic': SpecificMuscle.anaerobic,
  r'hips': SpecificMuscle.hips,
  r'thoracic': SpecificMuscle.thoracic,
  r'ankles': SpecificMuscle.ankles,
  r'fullBody': SpecificMuscle.fullBody,
};

Id _exerciseTemplateModelGetId(ExerciseTemplateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseTemplateModelGetLinks(
    ExerciseTemplateModel object) {
  return [];
}

void _exerciseTemplateModelAttach(
    IsarCollection<dynamic> col, Id id, ExerciseTemplateModel object) {
  object.id = id;
}

extension ExerciseTemplateModelQueryWhereSort
    on QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QWhere> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExerciseTemplateModelQueryWhere on QueryBuilder<ExerciseTemplateModel,
    ExerciseTemplateModel, QWhereClause> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      lowercaseNameEqualTo(String lowercaseName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lowercaseName',
        value: [lowercaseName],
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterWhereClause>
      lowercaseNameNotEqualTo(String lowercaseName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lowercaseName',
              lower: [],
              upper: [lowercaseName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lowercaseName',
              lower: [lowercaseName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lowercaseName',
              lower: [lowercaseName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lowercaseName',
              lower: [],
              upper: [lowercaseName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ExerciseTemplateModelQueryFilter on QueryBuilder<
    ExerciseTemplateModel, ExerciseTemplateModel, QFilterCondition> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      compoundExerciseTemplateIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compoundExerciseTemplateIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'compoundExerciseTemplateIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'compoundExerciseTemplateIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'compoundExerciseTemplateIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      compoundExerciseTemplateIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> compoundExerciseTemplateIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'compoundExerciseTemplateIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyEqualTo(
    DifficultyLevel value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyGreaterThan(
    DifficultyLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyLessThan(
    DifficultyLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyBetween(
    DifficultyLevel lower,
    DifficultyLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultDifficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      defaultDifficultyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      defaultDifficultyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultDifficulty',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultDifficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> defaultDifficultyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultDifficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'equipment',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'equipment',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentEqualTo(
    EquipmentType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentGreaterThan(
    EquipmentType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentLessThan(
    EquipmentType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentBetween(
    EquipmentType? lower,
    EquipmentType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'equipment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      equipmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'equipment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      equipmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'equipment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'equipment',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> equipmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'equipment',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> isCompoundEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompound',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowercaseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      lowercaseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lowercaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      lowercaseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lowercaseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowercaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> lowercaseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lowercaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediaType',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediaType',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeEqualTo(
    MediaType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeGreaterThan(
    MediaType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeLessThan(
    MediaType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeBetween(
    MediaType? lower,
    MediaType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      mediaTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      mediaTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediaUrl',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediaUrl',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      mediaUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      mediaUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> mediaUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupEqualTo(
    MuscleGroup value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupGreaterThan(
    MuscleGroup value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupLessThan(
    MuscleGroup value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupBetween(
    MuscleGroup lower,
    MuscleGroup upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      muscleGroupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      muscleGroupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleGroup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementEqualTo(
    MuscleGroup value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementGreaterThan(
    MuscleGroup value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementLessThan(
    MuscleGroup value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementBetween(
    MuscleGroup lower,
    MuscleGroup upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroups',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      muscleGroupsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      muscleGroupsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleGroups',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroups',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleGroups',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> muscleGroupsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'muscleGroups',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> progressionSettingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'progressionSettings',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> progressionSettingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'progressionSettings',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleEqualTo(
    SpecificMuscle value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleGreaterThan(
    SpecificMuscle value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleLessThan(
    SpecificMuscle value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleBetween(
    SpecificMuscle lower,
    SpecificMuscle upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'specificMuscle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      specificMuscleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      specificMuscleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'specificMuscle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscle',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMuscleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'specificMuscle',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementEqualTo(
    SpecificMuscle value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementGreaterThan(
    SpecificMuscle value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementLessThan(
    SpecificMuscle value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementBetween(
    SpecificMuscle lower,
    SpecificMuscle upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'specificMuscles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      specificMusclesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'specificMuscles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      specificMusclesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'specificMuscles',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'specificMuscles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> specificMusclesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'specificMuscles',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseTemplateModelQueryObject on QueryBuilder<
    ExerciseTemplateModel, ExerciseTemplateModel, QFilterCondition> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel,
          QAfterFilterCondition>
      progressionSettings(FilterQuery<ProgressionSettingsModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'progressionSettings');
    });
  }
}

extension ExerciseTemplateModelQueryLinks on QueryBuilder<ExerciseTemplateModel,
    ExerciseTemplateModel, QFilterCondition> {}

extension ExerciseTemplateModelQuerySortBy
    on QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QSortBy> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByDefaultDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDifficulty', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByDefaultDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDifficulty', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByEquipment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipment', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByEquipmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipment', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByIsCompound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompound', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByIsCompoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompound', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByLowercaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowercaseName', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByLowercaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowercaseName', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMediaUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaUrl', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMediaUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaUrl', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortBySpecificMuscle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortBySpecificMuscleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ExerciseTemplateModelQuerySortThenBy
    on QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QSortThenBy> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByDefaultDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDifficulty', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByDefaultDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDifficulty', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByEquipment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipment', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByEquipmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipment', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByIsCompound() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompound', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByIsCompoundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompound', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByLowercaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowercaseName', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByLowercaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowercaseName', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMediaUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaUrl', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMediaUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaUrl', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenBySpecificMuscle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenBySpecificMuscleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.desc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ExerciseTemplateModelQueryWhereDistinct
    on QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct> {
  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByCompoundExerciseTemplateIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compoundExerciseTemplateIds');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByDefaultDifficulty({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDifficulty',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByEquipment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'equipment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByIsCompound() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompound');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByLowercaseName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowercaseName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByMediaType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByMediaUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByMuscleGroup({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByMuscleGroups() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroups');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctBySpecificMuscle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'specificMuscle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctBySpecificMuscles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'specificMuscles');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ExerciseTemplateModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ExerciseTemplateModelQueryProperty on QueryBuilder<
    ExerciseTemplateModel, ExerciseTemplateModel, QQueryProperty> {
  QueryBuilder<ExerciseTemplateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExerciseTemplateModel, List<int>, QQueryOperations>
      compoundExerciseTemplateIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compoundExerciseTemplateIds');
    });
  }

  QueryBuilder<ExerciseTemplateModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ExerciseTemplateModel, DifficultyLevel, QQueryOperations>
      defaultDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDifficulty');
    });
  }

  QueryBuilder<ExerciseTemplateModel, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<ExerciseTemplateModel, EquipmentType?, QQueryOperations>
      equipmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'equipment');
    });
  }

  QueryBuilder<ExerciseTemplateModel, bool, QQueryOperations>
      isCompoundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompound');
    });
  }

  QueryBuilder<ExerciseTemplateModel, String, QQueryOperations>
      lowercaseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowercaseName');
    });
  }

  QueryBuilder<ExerciseTemplateModel, MediaType?, QQueryOperations>
      mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<ExerciseTemplateModel, String?, QQueryOperations>
      mediaUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaUrl');
    });
  }

  QueryBuilder<ExerciseTemplateModel, MuscleGroup, QQueryOperations>
      muscleGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroup');
    });
  }

  QueryBuilder<ExerciseTemplateModel, List<MuscleGroup>, QQueryOperations>
      muscleGroupsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroups');
    });
  }

  QueryBuilder<ExerciseTemplateModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ExerciseTemplateModel, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<ExerciseTemplateModel, ProgressionSettingsModel?,
      QQueryOperations> progressionSettingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressionSettings');
    });
  }

  QueryBuilder<ExerciseTemplateModel, SpecificMuscle, QQueryOperations>
      specificMuscleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specificMuscle');
    });
  }

  QueryBuilder<ExerciseTemplateModel, List<SpecificMuscle>, QQueryOperations>
      specificMusclesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specificMuscles');
    });
  }

  QueryBuilder<ExerciseTemplateModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ProgressionSettingsModelSchema = Schema(
  name: r'ProgressionSettingsModel',
  id: 7892569391189153667,
  properties: {
    r'maxReps': PropertySchema(
      id: 0,
      name: r'maxReps',
      type: IsarType.long,
    ),
    r'minReps': PropertySchema(
      id: 1,
      name: r'minReps',
      type: IsarType.long,
    ),
    r'progressionStep': PropertySchema(
      id: 2,
      name: r'progressionStep',
      type: IsarType.double,
    ),
    r'targetSets': PropertySchema(
      id: 3,
      name: r'targetSets',
      type: IsarType.long,
    )
  },
  estimateSize: _progressionSettingsModelEstimateSize,
  serialize: _progressionSettingsModelSerialize,
  deserialize: _progressionSettingsModelDeserialize,
  deserializeProp: _progressionSettingsModelDeserializeProp,
);

int _progressionSettingsModelEstimateSize(
  ProgressionSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _progressionSettingsModelSerialize(
  ProgressionSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.maxReps);
  writer.writeLong(offsets[1], object.minReps);
  writer.writeDouble(offsets[2], object.progressionStep);
  writer.writeLong(offsets[3], object.targetSets);
}

ProgressionSettingsModel _progressionSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProgressionSettingsModel();
  object.maxReps = reader.readLongOrNull(offsets[0]);
  object.minReps = reader.readLongOrNull(offsets[1]);
  object.progressionStep = reader.readDoubleOrNull(offsets[2]);
  object.targetSets = reader.readLongOrNull(offsets[3]);
  return object;
}

P _progressionSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ProgressionSettingsModelQueryFilter on QueryBuilder<
    ProgressionSettingsModel, ProgressionSettingsModel, QFilterCondition> {
  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxReps',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxReps',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> maxRepsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'minReps',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'minReps',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minReps',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> minRepsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'progressionStep',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'progressionStep',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressionStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progressionStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progressionStep',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> progressionStepBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progressionStep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetSets',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetSets',
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressionSettingsModel, ProgressionSettingsModel,
      QAfterFilterCondition> targetSetsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProgressionSettingsModelQueryObject on QueryBuilder<
    ProgressionSettingsModel, ProgressionSettingsModel, QFilterCondition> {}
