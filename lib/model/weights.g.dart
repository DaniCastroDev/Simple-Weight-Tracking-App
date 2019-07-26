// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weights.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Weight extends DataClass implements Insertable<Weight> {
  final DateTime date;
  final double weight;
  Weight({@required this.date, @required this.weight});
  factory Weight.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Weight(
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      weight:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}weight']),
    );
  }
  factory Weight.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Weight(
      date: serializer.fromJson<DateTime>(json['date']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'date': serializer.toJson<DateTime>(date),
      'weight': serializer.toJson<double>(weight),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Weight>>(bool nullToAbsent) {
    return WeightsCompanion(
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
    ) as T;
  }

  Weight copyWith({DateTime date, double weight}) => Weight(
        date: date ?? this.date,
        weight: weight ?? this.weight,
      );
  @override
  String toString() {
    return (StringBuffer('Weight(')
          ..write('date: $date, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc($mrjc(0, date.hashCode), weight.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Weight && other.date == date && other.weight == weight);
}

class WeightsCompanion extends UpdateCompanion<Weight> {
  final Value<DateTime> date;
  final Value<double> weight;
  const WeightsCompanion({
    this.date = const Value.absent(),
    this.weight = const Value.absent(),
  });
}

class $WeightsTable extends Weights with TableInfo<$WeightsTable, Weight> {
  final GeneratedDatabase _db;
  final String _alias;
  $WeightsTable(this._db, [this._alias]);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _weightMeta = const VerificationMeta('weight');
  GeneratedRealColumn _weight;
  @override
  GeneratedRealColumn get weight => _weight ??= _constructWeight();
  GeneratedRealColumn _constructWeight() {
    return GeneratedRealColumn(
      'weight',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [date, weight];
  @override
  $WeightsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'weights';
  @override
  final String actualTableName = 'weights';
  @override
  VerificationContext validateIntegrity(WeightsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (date.isRequired && isInserting) {
      context.missing(_dateMeta);
    }
    if (d.weight.present) {
      context.handle(
          _weightMeta, weight.isAcceptableValue(d.weight.value, _weightMeta));
    } else if (weight.isRequired && isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Weight map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Weight.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(WeightsCompanion d) {
    final map = <String, Variable>{};
    if (d.date.present) {
      map['date'] = Variable<DateTime, DateTimeType>(d.date.value);
    }
    if (d.weight.present) {
      map['weight'] = Variable<double, RealType>(d.weight.value);
    }
    return map;
  }

  @override
  $WeightsTable createAlias(String alias) {
    return $WeightsTable(_db, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int identifier;
  final double initialWeight;
  final double objectiveWeight;
  final double height;
  final bool isMale;
  final bool isRetarded;
  Setting(
      {@required this.identifier,
      @required this.initialWeight,
      @required this.objectiveWeight,
      @required this.height,
      @required this.isMale,
      @required this.isRetarded});
  factory Setting.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Setting(
      identifier:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}identifier']),
      initialWeight: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}initial_weight']),
      objectiveWeight: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}objective_weight']),
      height:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}height']),
      isMale:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_male']),
      isRetarded: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_retarded']),
    );
  }
  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Setting(
      identifier: serializer.fromJson<int>(json['identifier']),
      initialWeight: serializer.fromJson<double>(json['initialWeight']),
      objectiveWeight: serializer.fromJson<double>(json['objectiveWeight']),
      height: serializer.fromJson<double>(json['height']),
      isMale: serializer.fromJson<bool>(json['isMale']),
      isRetarded: serializer.fromJson<bool>(json['isRetarded']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'identifier': serializer.toJson<int>(identifier),
      'initialWeight': serializer.toJson<double>(initialWeight),
      'objectiveWeight': serializer.toJson<double>(objectiveWeight),
      'height': serializer.toJson<double>(height),
      'isMale': serializer.toJson<bool>(isMale),
      'isRetarded': serializer.toJson<bool>(isRetarded),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Setting>>(bool nullToAbsent) {
    return SettingsCompanion(
      identifier: identifier == null && nullToAbsent
          ? const Value.absent()
          : Value(identifier),
      initialWeight: initialWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(initialWeight),
      objectiveWeight: objectiveWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(objectiveWeight),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      isMale:
          isMale == null && nullToAbsent ? const Value.absent() : Value(isMale),
      isRetarded: isRetarded == null && nullToAbsent
          ? const Value.absent()
          : Value(isRetarded),
    ) as T;
  }

  Setting copyWith(
          {int identifier,
          double initialWeight,
          double objectiveWeight,
          double height,
          bool isMale,
          bool isRetarded}) =>
      Setting(
        identifier: identifier ?? this.identifier,
        initialWeight: initialWeight ?? this.initialWeight,
        objectiveWeight: objectiveWeight ?? this.objectiveWeight,
        height: height ?? this.height,
        isMale: isMale ?? this.isMale,
        isRetarded: isRetarded ?? this.isRetarded,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('identifier: $identifier, ')
          ..write('initialWeight: $initialWeight, ')
          ..write('objectiveWeight: $objectiveWeight, ')
          ..write('height: $height, ')
          ..write('isMale: $isMale, ')
          ..write('isRetarded: $isRetarded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc($mrjc(0, identifier.hashCode), initialWeight.hashCode),
                  objectiveWeight.hashCode),
              height.hashCode),
          isMale.hashCode),
      isRetarded.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Setting &&
          other.identifier == identifier &&
          other.initialWeight == initialWeight &&
          other.objectiveWeight == objectiveWeight &&
          other.height == height &&
          other.isMale == isMale &&
          other.isRetarded == isRetarded);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> identifier;
  final Value<double> initialWeight;
  final Value<double> objectiveWeight;
  final Value<double> height;
  final Value<bool> isMale;
  final Value<bool> isRetarded;
  const SettingsCompanion({
    this.identifier = const Value.absent(),
    this.initialWeight = const Value.absent(),
    this.objectiveWeight = const Value.absent(),
    this.height = const Value.absent(),
    this.isMale = const Value.absent(),
    this.isRetarded = const Value.absent(),
  });
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  final GeneratedDatabase _db;
  final String _alias;
  $SettingsTable(this._db, [this._alias]);
  final VerificationMeta _identifierMeta = const VerificationMeta('identifier');
  GeneratedIntColumn _identifier;
  @override
  GeneratedIntColumn get identifier => _identifier ??= _constructIdentifier();
  GeneratedIntColumn _constructIdentifier() {
    return GeneratedIntColumn('identifier', $tableName, false,
        hasAutoIncrement: true);
  }

  final VerificationMeta _initialWeightMeta =
      const VerificationMeta('initialWeight');
  GeneratedRealColumn _initialWeight;
  @override
  GeneratedRealColumn get initialWeight =>
      _initialWeight ??= _constructInitialWeight();
  GeneratedRealColumn _constructInitialWeight() {
    return GeneratedRealColumn(
      'initial_weight',
      $tableName,
      false,
    );
  }

  final VerificationMeta _objectiveWeightMeta =
      const VerificationMeta('objectiveWeight');
  GeneratedRealColumn _objectiveWeight;
  @override
  GeneratedRealColumn get objectiveWeight =>
      _objectiveWeight ??= _constructObjectiveWeight();
  GeneratedRealColumn _constructObjectiveWeight() {
    return GeneratedRealColumn(
      'objective_weight',
      $tableName,
      false,
    );
  }

  final VerificationMeta _heightMeta = const VerificationMeta('height');
  GeneratedRealColumn _height;
  @override
  GeneratedRealColumn get height => _height ??= _constructHeight();
  GeneratedRealColumn _constructHeight() {
    return GeneratedRealColumn(
      'height',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isMaleMeta = const VerificationMeta('isMale');
  GeneratedBoolColumn _isMale;
  @override
  GeneratedBoolColumn get isMale => _isMale ??= _constructIsMale();
  GeneratedBoolColumn _constructIsMale() {
    return GeneratedBoolColumn(
      'is_male',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isRetardedMeta = const VerificationMeta('isRetarded');
  GeneratedBoolColumn _isRetarded;
  @override
  GeneratedBoolColumn get isRetarded => _isRetarded ??= _constructIsRetarded();
  GeneratedBoolColumn _constructIsRetarded() {
    return GeneratedBoolColumn(
      'is_retarded',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [identifier, initialWeight, objectiveWeight, height, isMale, isRetarded];
  @override
  $SettingsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'settings';
  @override
  final String actualTableName = 'settings';
  @override
  VerificationContext validateIntegrity(SettingsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.identifier.present) {
      context.handle(_identifierMeta,
          identifier.isAcceptableValue(d.identifier.value, _identifierMeta));
    } else if (identifier.isRequired && isInserting) {
      context.missing(_identifierMeta);
    }
    if (d.initialWeight.present) {
      context.handle(
          _initialWeightMeta,
          initialWeight.isAcceptableValue(
              d.initialWeight.value, _initialWeightMeta));
    } else if (initialWeight.isRequired && isInserting) {
      context.missing(_initialWeightMeta);
    }
    if (d.objectiveWeight.present) {
      context.handle(
          _objectiveWeightMeta,
          objectiveWeight.isAcceptableValue(
              d.objectiveWeight.value, _objectiveWeightMeta));
    } else if (objectiveWeight.isRequired && isInserting) {
      context.missing(_objectiveWeightMeta);
    }
    if (d.height.present) {
      context.handle(
          _heightMeta, height.isAcceptableValue(d.height.value, _heightMeta));
    } else if (height.isRequired && isInserting) {
      context.missing(_heightMeta);
    }
    if (d.isMale.present) {
      context.handle(
          _isMaleMeta, isMale.isAcceptableValue(d.isMale.value, _isMaleMeta));
    } else if (isMale.isRequired && isInserting) {
      context.missing(_isMaleMeta);
    }
    if (d.isRetarded.present) {
      context.handle(_isRetardedMeta,
          isRetarded.isAcceptableValue(d.isRetarded.value, _isRetardedMeta));
    } else if (isRetarded.isRequired && isInserting) {
      context.missing(_isRetardedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {identifier};
  @override
  Setting map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Setting.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(SettingsCompanion d) {
    final map = <String, Variable>{};
    if (d.identifier.present) {
      map['identifier'] = Variable<int, IntType>(d.identifier.value);
    }
    if (d.initialWeight.present) {
      map['initial_weight'] = Variable<double, RealType>(d.initialWeight.value);
    }
    if (d.objectiveWeight.present) {
      map['objective_weight'] =
          Variable<double, RealType>(d.objectiveWeight.value);
    }
    if (d.height.present) {
      map['height'] = Variable<double, RealType>(d.height.value);
    }
    if (d.isMale.present) {
      map['is_male'] = Variable<bool, BoolType>(d.isMale.value);
    }
    if (d.isRetarded.present) {
      map['is_retarded'] = Variable<bool, BoolType>(d.isRetarded.value);
    }
    return map;
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(const SqlTypeSystem.withDefaults(), e);
  $WeightsTable _weights;
  $WeightsTable get weights => _weights ??= $WeightsTable(this);
  $SettingsTable _settings;
  $SettingsTable get settings => _settings ??= $SettingsTable(this);
  @override
  List<TableInfo> get allTables => [weights, settings];
}
