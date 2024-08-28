import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;

  /// Getter for the database instance.
  Future<Database> get database async {
    // If the database instance already exists, return it.
    if (_database != null) return _database!;

    // Otherwise, initialize the database.
    _database = await initDatabase();
    return _database!;
  }

  /// Initialize the database.
  Future<Database> initDatabase() async {
    // Get the path to the database file.
    String path = join(await getDatabasesPath(), 'health_tracker.db');

    // Open the database and create the MyHealthRecords table if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE MyHealthRecords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            duration INTEGER,
            caloriesBurned REAL,
            bpStatus TEXT,
            sugarStatus TEXT,
            sleephour INTEGER
          )
        ''');
      },
    );
  }

  /// Insert a health record into the MyHealthRecords table.
  Future<void> insertHealthRecord(Map<String, dynamic> record) async {
    final Database db = await database;
    await db.insert(
      'MyHealthRecords',
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get the latest calories from the database.
  Future<double?> getLatestCalories() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT caloriesBurned
      FROM MyHealthRecords
      WHERE date = (SELECT MAX(date) FROM MyHealthRecords)
    ''');
    if (result.isNotEmpty) {
      return result.first['caloriesBurned'] as double;
    } else {
      return 0;
    }
  }

  /// Get the latest sleep hour from the database.
  Future<int?> getLatestSleepHour() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT sleephour
      FROM MyHealthRecords
      WHERE date = (SELECT MAX(date) FROM MyHealthRecords)
    ''');
    if (result.isNotEmpty) {
      return result.first['sleephour'] as int;
    } else {
      return 0;
    }
  }
}
