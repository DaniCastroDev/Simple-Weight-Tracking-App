import 'package:moor_flutter/moor_flutter.dart';

// assuming that your file is called filename.dart. This will give an error at first,
// but it's needed for moor to know about the generated code
part 'weights.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Weights extends Table {
  DateTimeColumn get date => dateTime()();
  RealColumn get weight => real()();
}

class Settings extends Table {
  IntColumn get identifier => integer().autoIncrement()();
  RealColumn get initialWeight => real()();
  RealColumn get objectiveWeight => real()();
  RealColumn get height => real()();
  BoolColumn get isMale => boolean()();
  BoolColumn get isRetarded => boolean()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Weights, Settings])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  @override
  int get schemaVersion => 1;

  Future<List<Weight>> get allWeightEntries => (select(weights)..orderBy([(u) => OrderingTerm(expression: u.date, mode: OrderingMode.asc)])).get();
  Stream<List<Weight>> get allWeightEntriesStream => (select(weights)..orderBy([(u) => OrderingTerm(expression: u.date, mode: OrderingMode.asc)])).watch();

  // watches all todo entries in a given category. The stream will automatically
  // emit new items whenever the underlying data changes.
  Future<List<Weight>> weightsFromDateRange(DateTime from, DateTime to) {
    return (select(weights)..where((t) => t.date.isBiggerOrEqualValue(from))..where((t) => t.date.isSmallerOrEqualValue(to))).get();
  }

  void addSettings(Setting setting) {
    into(settings).insert(setting);
  }

  Future<int> updateSettings(Setting setting) {
    return (update(settings)..where((w) => w.identifier.equals(setting.identifier))).write(setting);
  }

  void addWeight(Weight weight) {
    into(weights).insert(weight);
  }

  Future<int> updateWeight(Weight weight) {
    return (update(weights)..where((w) => w.date.equals(weight.date))).write(weight);
  }
}
