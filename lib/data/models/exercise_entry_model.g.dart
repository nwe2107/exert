// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_entry_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseEntryModelCollection on Isar {
  IsarCollection<ExerciseEntryModel> get exerciseEntries => this.collection();
}

const ExerciseEntryModelSchema = CollectionSchema(
  name: r'ExerciseEntryModel',
  id: 3474937503977940195,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'exerciseTemplateId': PropertySchema(
      id: 2,
      name: r'exerciseTemplateId',
      type: IsarType.long,
    ),
    r'feltDifficulty': PropertySchema(
      id: 3,
      name: r'feltDifficulty',
      type: IsarType.string,
      enumMap: _ExerciseEntryModelfeltDifficultyEnumValueMap,
    ),
    r'muscleGroup': PropertySchema(
      id: 4,
      name: r'muscleGroup',
      type: IsarType.string,
      enumMap: _ExerciseEntryModelmuscleGroupEnumValueMap,
    ),
    r'muscleGroups': PropertySchema(
      id: 5,
      name: r'muscleGroups',
      type: IsarType.stringList,
      enumMap: _ExerciseEntryModelmuscleGroupsEnumValueMap,
    ),
    r'notes': PropertySchema(
      id: 6,
      name: r'notes',
      type: IsarType.string,
    ),
    r'restSeconds': PropertySchema(
      id: 7,
      name: r'restSeconds',
      type: IsarType.long,
    ),
    r'schemeType': PropertySchema(
      id: 8,
      name: r'schemeType',
      type: IsarType.string,
      enumMap: _ExerciseEntryModelschemeTypeEnumValueMap,
    ),
    r'sets': PropertySchema(
      id: 9,
      name: r'sets',
      type: IsarType.objectList,
      target: r'SetItemModel',
    ),
    r'specificMuscle': PropertySchema(
      id: 10,
      name: r'specificMuscle',
      type: IsarType.string,
      enumMap: _ExerciseEntryModelspecificMuscleEnumValueMap,
    ),
    r'specificMuscles': PropertySchema(
      id: 11,
      name: r'specificMuscles',
      type: IsarType.stringList,
      enumMap: _ExerciseEntryModelspecificMusclesEnumValueMap,
    ),
    r'supersetGroupId': PropertySchema(
      id: 12,
      name: r'supersetGroupId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workoutSessionId': PropertySchema(
      id: 14,
      name: r'workoutSessionId',
      type: IsarType.long,
    )
  },
  estimateSize: _exerciseEntryModelEstimateSize,
  serialize: _exerciseEntryModelSerialize,
  deserialize: _exerciseEntryModelDeserialize,
  deserializeProp: _exerciseEntryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'workoutSessionId': IndexSchema(
      id: 4885970055233737365,
      name: r'workoutSessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workoutSessionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'exerciseTemplateId': IndexSchema(
      id: 4487856677418974640,
      name: r'exerciseTemplateId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'exerciseTemplateId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'SetItemModel': SetItemModelSchema},
  getId: _exerciseEntryModelGetId,
  getLinks: _exerciseEntryModelGetLinks,
  attach: _exerciseEntryModelAttach,
  version: '3.1.0+1',
);

int _exerciseEntryModelEstimateSize(
  ExerciseEntryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.feltDifficulty.name.length * 3;
  bytesCount += 3 + object.muscleGroup.name.length * 3;
  bytesCount += 3 + object.muscleGroups.length * 3;
  {
    for (var i = 0; i < object.muscleGroups.length; i++) {
      final value = object.muscleGroups[i];
      bytesCount += value.name.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.schemeType.name.length * 3;
  bytesCount += 3 + object.sets.length * 3;
  {
    final offsets = allOffsets[SetItemModel]!;
    for (var i = 0; i < object.sets.length; i++) {
      final value = object.sets[i];
      bytesCount += SetItemModelSchema.estimateSize(value, offsets, allOffsets);
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
  {
    final value = object.supersetGroupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseEntryModelSerialize(
  ExerciseEntryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeLong(offsets[2], object.exerciseTemplateId);
  writer.writeString(offsets[3], object.feltDifficulty.name);
  writer.writeString(offsets[4], object.muscleGroup.name);
  writer.writeStringList(
      offsets[5], object.muscleGroups.map((e) => e.name).toList());
  writer.writeString(offsets[6], object.notes);
  writer.writeLong(offsets[7], object.restSeconds);
  writer.writeString(offsets[8], object.schemeType.name);
  writer.writeObjectList<SetItemModel>(
    offsets[9],
    allOffsets,
    SetItemModelSchema.serialize,
    object.sets,
  );
  writer.writeString(offsets[10], object.specificMuscle.name);
  writer.writeStringList(
      offsets[11], object.specificMuscles.map((e) => e.name).toList());
  writer.writeString(offsets[12], object.supersetGroupId);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeLong(offsets[14], object.workoutSessionId);
}

ExerciseEntryModel _exerciseEntryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseEntryModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[1]);
  object.exerciseTemplateId = reader.readLong(offsets[2]);
  object.feltDifficulty = _ExerciseEntryModelfeltDifficultyValueEnumMap[
          reader.readStringOrNull(offsets[3])] ??
      DifficultyLevel.easy;
  object.id = id;
  object.muscleGroup = _ExerciseEntryModelmuscleGroupValueEnumMap[
          reader.readStringOrNull(offsets[4])] ??
      MuscleGroup.chest;
  object.muscleGroups = reader
          .readStringList(offsets[5])
          ?.map((e) =>
              _ExerciseEntryModelmuscleGroupsValueEnumMap[e] ??
              MuscleGroup.chest)
          .toList() ??
      [];
  object.notes = reader.readStringOrNull(offsets[6]);
  object.restSeconds = reader.readLongOrNull(offsets[7]);
  object.schemeType = _ExerciseEntryModelschemeTypeValueEnumMap[
          reader.readStringOrNull(offsets[8])] ??
      SchemeType.standard;
  object.sets = reader.readObjectList<SetItemModel>(
        offsets[9],
        SetItemModelSchema.deserialize,
        allOffsets,
        SetItemModel(),
      ) ??
      [];
  object.specificMuscle = _ExerciseEntryModelspecificMuscleValueEnumMap[
          reader.readStringOrNull(offsets[10])] ??
      SpecificMuscle.upperChest;
  object.specificMuscles = reader
          .readStringList(offsets[11])
          ?.map((e) =>
              _ExerciseEntryModelspecificMusclesValueEnumMap[e] ??
              SpecificMuscle.upperChest)
          .toList() ??
      [];
  object.supersetGroupId = reader.readStringOrNull(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  object.workoutSessionId = reader.readLong(offsets[14]);
  return object;
}

P _exerciseEntryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_ExerciseEntryModelfeltDifficultyValueEnumMap[
              reader.readStringOrNull(offset)] ??
          DifficultyLevel.easy) as P;
    case 4:
      return (_ExerciseEntryModelmuscleGroupValueEnumMap[
              reader.readStringOrNull(offset)] ??
          MuscleGroup.chest) as P;
    case 5:
      return (reader
              .readStringList(offset)
              ?.map((e) =>
                  _ExerciseEntryModelmuscleGroupsValueEnumMap[e] ??
                  MuscleGroup.chest)
              .toList() ??
          []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (_ExerciseEntryModelschemeTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SchemeType.standard) as P;
    case 9:
      return (reader.readObjectList<SetItemModel>(
            offset,
            SetItemModelSchema.deserialize,
            allOffsets,
            SetItemModel(),
          ) ??
          []) as P;
    case 10:
      return (_ExerciseEntryModelspecificMuscleValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SpecificMuscle.upperChest) as P;
    case 11:
      return (reader
              .readStringList(offset)
              ?.map((e) =>
                  _ExerciseEntryModelspecificMusclesValueEnumMap[e] ??
                  SpecificMuscle.upperChest)
              .toList() ??
          []) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExerciseEntryModelfeltDifficultyEnumValueMap = {
  r'easy': r'easy',
  r'moderate': r'moderate',
  r'hard': r'hard',
};
const _ExerciseEntryModelfeltDifficultyValueEnumMap = {
  r'easy': DifficultyLevel.easy,
  r'moderate': DifficultyLevel.moderate,
  r'hard': DifficultyLevel.hard,
};
const _ExerciseEntryModelmuscleGroupEnumValueMap = {
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
const _ExerciseEntryModelmuscleGroupValueEnumMap = {
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
const _ExerciseEntryModelmuscleGroupsEnumValueMap = {
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
const _ExerciseEntryModelmuscleGroupsValueEnumMap = {
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
const _ExerciseEntryModelschemeTypeEnumValueMap = {
  r'standard': r'standard',
  r'superset': r'superset',
  r'easyMode': r'easyMode',
};
const _ExerciseEntryModelschemeTypeValueEnumMap = {
  r'standard': SchemeType.standard,
  r'superset': SchemeType.superset,
  r'easyMode': SchemeType.easyMode,
};
const _ExerciseEntryModelspecificMuscleEnumValueMap = {
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
const _ExerciseEntryModelspecificMuscleValueEnumMap = {
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
const _ExerciseEntryModelspecificMusclesEnumValueMap = {
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
const _ExerciseEntryModelspecificMusclesValueEnumMap = {
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

Id _exerciseEntryModelGetId(ExerciseEntryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseEntryModelGetLinks(
    ExerciseEntryModel object) {
  return [];
}

void _exerciseEntryModelAttach(
    IsarCollection<dynamic> col, Id id, ExerciseEntryModel object) {
  object.id = id;
}

extension ExerciseEntryModelQueryWhereSort
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QWhere> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhere>
      anyWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'workoutSessionId'),
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhere>
      anyExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'exerciseTemplateId'),
      );
    });
  }
}

extension ExerciseEntryModelQueryWhere
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QWhereClause> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      workoutSessionIdEqualTo(int workoutSessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workoutSessionId',
        value: [workoutSessionId],
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      workoutSessionIdNotEqualTo(int workoutSessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [],
              upper: [workoutSessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [workoutSessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [workoutSessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [],
              upper: [workoutSessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      workoutSessionIdGreaterThan(
    int workoutSessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workoutSessionId',
        lower: [workoutSessionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      workoutSessionIdLessThan(
    int workoutSessionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workoutSessionId',
        lower: [],
        upper: [workoutSessionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      workoutSessionIdBetween(
    int lowerWorkoutSessionId,
    int upperWorkoutSessionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workoutSessionId',
        lower: [lowerWorkoutSessionId],
        includeLower: includeLower,
        upper: [upperWorkoutSessionId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      exerciseTemplateIdEqualTo(int exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseTemplateId',
        value: [exerciseTemplateId],
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      exerciseTemplateIdNotEqualTo(int exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [],
              upper: [exerciseTemplateId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [exerciseTemplateId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [exerciseTemplateId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [],
              upper: [exerciseTemplateId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      exerciseTemplateIdGreaterThan(
    int exerciseTemplateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseTemplateId',
        lower: [exerciseTemplateId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      exerciseTemplateIdLessThan(
    int exerciseTemplateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseTemplateId',
        lower: [],
        upper: [exerciseTemplateId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterWhereClause>
      exerciseTemplateIdBetween(
    int lowerExerciseTemplateId,
    int upperExerciseTemplateId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'exerciseTemplateId',
        lower: [lowerExerciseTemplateId],
        includeLower: includeLower,
        upper: [upperExerciseTemplateId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseEntryModelQueryFilter
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QFilterCondition> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      deletedAtBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      exerciseTemplateIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      exerciseTemplateIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      exerciseTemplateIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      exerciseTemplateIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseTemplateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyEqualTo(
    DifficultyLevel value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyGreaterThan(
    DifficultyLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyLessThan(
    DifficultyLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyBetween(
    DifficultyLevel lower,
    DifficultyLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feltDifficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'feltDifficulty',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'feltDifficulty',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feltDifficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      feltDifficultyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'feltDifficulty',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupEqualTo(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupStartsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupEndsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleGroup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleGroup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleGroup',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementEqualTo(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementStartsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementEndsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'muscleGroups',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'muscleGroups',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroups',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'muscleGroups',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsLengthEqualTo(int length) {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsIsEmpty() {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsIsNotEmpty() {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsLengthLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsLengthGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      muscleGroupsLengthBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesEqualTo(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesStartsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesEndsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'restSeconds',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'restSeconds',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'restSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'restSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'restSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      restSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'restSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeEqualTo(
    SchemeType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeGreaterThan(
    SchemeType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeLessThan(
    SchemeType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeBetween(
    SchemeType lower,
    SchemeType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schemeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schemeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      schemeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schemeType',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleEqualTo(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleStartsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleEndsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'specificMuscle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'specificMuscle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscle',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMuscleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'specificMuscle',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementEqualTo(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementStartsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementEndsWith(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specificMuscles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'specificMuscles',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesLengthEqualTo(int length) {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesIsEmpty() {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesIsNotEmpty() {
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesLengthLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesLengthGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      specificMusclesLengthBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supersetGroupId',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supersetGroupId',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supersetGroupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supersetGroupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supersetGroupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supersetGroupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      supersetGroupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supersetGroupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      updatedAtBetween(
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

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      workoutSessionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      workoutSessionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      workoutSessionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutSessionId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      workoutSessionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutSessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseEntryModelQueryObject
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QFilterCondition> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterFilterCondition>
      setsElement(FilterQuery<SetItemModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sets');
    });
  }
}

extension ExerciseEntryModelQueryLinks
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QFilterCondition> {}

extension ExerciseEntryModelQuerySortBy
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QSortBy> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByFeltDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feltDifficulty', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByFeltDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feltDifficulty', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restSeconds', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restSeconds', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySchemeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeType', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySchemeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeType', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySpecificMuscle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySpecificMuscleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySupersetGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersetGroupId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortBySupersetGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersetGroupId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      sortByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension ExerciseEntryModelQuerySortThenBy
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QSortThenBy> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByFeltDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feltDifficulty', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByFeltDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feltDifficulty', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restSeconds', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restSeconds', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySchemeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeType', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySchemeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeType', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySpecificMuscle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySpecificMuscleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specificMuscle', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySupersetGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersetGroupId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenBySupersetGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supersetGroupId', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QAfterSortBy>
      thenByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension ExerciseEntryModelQueryWhereDistinct
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct> {
  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseTemplateId');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByFeltDifficulty({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feltDifficulty',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByMuscleGroup({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByMuscleGroups() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroups');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'restSeconds');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctBySchemeType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctBySpecificMuscle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'specificMuscle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctBySpecificMuscles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'specificMuscles');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctBySupersetGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supersetGroupId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QDistinct>
      distinctByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutSessionId');
    });
  }
}

extension ExerciseEntryModelQueryProperty
    on QueryBuilder<ExerciseEntryModel, ExerciseEntryModel, QQueryProperty> {
  QueryBuilder<ExerciseEntryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExerciseEntryModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, int, QQueryOperations>
      exerciseTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseTemplateId');
    });
  }

  QueryBuilder<ExerciseEntryModel, DifficultyLevel, QQueryOperations>
      feltDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feltDifficulty');
    });
  }

  QueryBuilder<ExerciseEntryModel, MuscleGroup, QQueryOperations>
      muscleGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroup');
    });
  }

  QueryBuilder<ExerciseEntryModel, List<MuscleGroup>, QQueryOperations>
      muscleGroupsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroups');
    });
  }

  QueryBuilder<ExerciseEntryModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<ExerciseEntryModel, int?, QQueryOperations>
      restSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'restSeconds');
    });
  }

  QueryBuilder<ExerciseEntryModel, SchemeType, QQueryOperations>
      schemeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemeType');
    });
  }

  QueryBuilder<ExerciseEntryModel, List<SetItemModel>, QQueryOperations>
      setsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sets');
    });
  }

  QueryBuilder<ExerciseEntryModel, SpecificMuscle, QQueryOperations>
      specificMuscleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specificMuscle');
    });
  }

  QueryBuilder<ExerciseEntryModel, List<SpecificMuscle>, QQueryOperations>
      specificMusclesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specificMuscles');
    });
  }

  QueryBuilder<ExerciseEntryModel, String?, QQueryOperations>
      supersetGroupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supersetGroupId');
    });
  }

  QueryBuilder<ExerciseEntryModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ExerciseEntryModel, int, QQueryOperations>
      workoutSessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutSessionId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SetItemModelSchema = Schema(
  name: r'SetItemModel',
  id: -8133006678846881717,
  properties: {
    r'durationSeconds': PropertySchema(
      id: 0,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'reps': PropertySchema(
      id: 1,
      name: r'reps',
      type: IsarType.long,
    ),
    r'rpe': PropertySchema(
      id: 2,
      name: r'rpe',
      type: IsarType.double,
    ),
    r'setNumber': PropertySchema(
      id: 3,
      name: r'setNumber',
      type: IsarType.long,
    ),
    r'weight': PropertySchema(
      id: 4,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _setItemModelEstimateSize,
  serialize: _setItemModelSerialize,
  deserialize: _setItemModelDeserialize,
  deserializeProp: _setItemModelDeserializeProp,
);

int _setItemModelEstimateSize(
  SetItemModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _setItemModelSerialize(
  SetItemModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationSeconds);
  writer.writeLong(offsets[1], object.reps);
  writer.writeDouble(offsets[2], object.rpe);
  writer.writeLong(offsets[3], object.setNumber);
  writer.writeDouble(offsets[4], object.weight);
}

SetItemModel _setItemModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SetItemModel();
  object.durationSeconds = reader.readLongOrNull(offsets[0]);
  object.reps = reader.readLongOrNull(offsets[1]);
  object.rpe = reader.readDoubleOrNull(offsets[2]);
  object.setNumber = reader.readLong(offsets[3]);
  object.weight = reader.readDoubleOrNull(offsets[4]);
  return object;
}

P _setItemModelDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SetItemModelQueryFilter
    on QueryBuilder<SetItemModel, SetItemModel, QFilterCondition> {
  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      durationSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> repsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      repsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> repsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      repsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> repsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> repsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> rpeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rpe',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      rpeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rpe',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> rpeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rpe',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      rpeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rpe',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> rpeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rpe',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> rpeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rpe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      setNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      setNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      setNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      setNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> weightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      weightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition>
      weightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SetItemModel, SetItemModel, QAfterFilterCondition> weightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SetItemModelQueryObject
    on QueryBuilder<SetItemModel, SetItemModel, QFilterCondition> {}
