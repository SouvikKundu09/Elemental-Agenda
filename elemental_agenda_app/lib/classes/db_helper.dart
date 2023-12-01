import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'data_new.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE events (
              id INTEGER PRIMARY KEY NOT NULL,
              name STRING NOT NULL,
              description STRING NOT NULL,
              location STRING NOT NULL,
              start DATETIME NOT NULL,
              end DATETIME NOT NULL,
              city STRING NOT NULL
            );
          ''');
      },
    );
  }

  deleteTable() async {
    final db = await database;
    db.rawQuery("DELETE from events");
  }

  deleteEntry(id) async {
    final db = await database;
    print(id);
    db.rawQuery("DELETE from events where id = $id");
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('events', data);
  }

  Future<List<Map<String, dynamic>>> fetchData(DateTime d) async {
    final db = await database;
    final dst = DateTime.parse(DateFormat('yyyy-MM-dd').format(d));
    final start = dst.millisecondsSinceEpoch;
    final end = dst.add(const Duration(days: 1)).millisecondsSinceEpoch;
    // print(start);
    // print("Called this");
    final events = await db.query('events',
        where: "start >= '$start' and start < '$end'", orderBy: "start");
    return (events);
  }
}
