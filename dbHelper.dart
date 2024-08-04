import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthsync.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType,
        number1 $textType,
        number2 $textType,
        number3 $textType,
        gender $textType,
        healthIssue $textType
      )
    ''');
  }

  Future<int> addUser(Map<String, dynamic> userData) async {
    final db = await instance.database;
    return await db.insert('users', userData);
  }

  Future<int> editFirstRow(Map<String, dynamic> userData) async {
    final db = await instance.database;
    return await db.update('users', userData, where: 'id = ?', whereArgs: [1]);
  }

  Future<String?> getFirstUserName() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        'users',
        columns: ['name'],
        where: 'id = ?',
        whereArgs: [1]
    );
    if (results.isNotEmpty) {
      return results.first['name'] as String;
    }
    return null;
  }

  Future<List<String>> getEmergencyContacts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        'users',
        columns: ['number1', 'number2', 'number3'],
        where: 'id = ?',
        whereArgs: [1]
    );
    if (results.isNotEmpty) {
      return [
        results.first['number1'] as String,
        results.first['number2'] as String,
        results.first['number3'] as String
      ];
    }
    return [];
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Map<String, dynamic>?> getFirstUserData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> users = await db.query('users', limit: 1);
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getFirstUserNameAndEmail() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
        'users',
        columns: ['name', 'email'],
        limit: 1
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

}
