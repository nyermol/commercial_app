import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static const String _databaseName = 'MyDatabase.db';
  static const int _databaseVersion = 1;
  static const String table = 'my_table';

  DatabaseServices._privateConstructor();
  static final DatabaseServices instance =
      DatabaseServices._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY,
        key TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  Future<void> insert(String key, String data) async {
    Database db = await database;
    await db.insert(
      table,
      <String, Object?>{'key': key, 'data': data},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(String key, String data) async {
    Database db = await database;
    await db.update(
      table,
      <String, Object?>{'data': data},
      where: 'key = ?',
      whereArgs: <Object?>[key],
    );
  }

  Future<String?> fetch(String key) async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query(table, where: 'key = ?', whereArgs: <Object?>[key]);
    if (maps.isNotEmpty) {
      return maps.first['data'];
    }
    return null;
  }

  Future<void> clearDatabase() async {
    Database db = await database;
    await db.execute('DROP TABLE IF EXISTS $table');
    await _onCreate(db, _databaseVersion);
  }
}
