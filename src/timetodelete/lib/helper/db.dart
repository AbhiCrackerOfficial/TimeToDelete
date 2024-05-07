// use sqflite plugin to create a database

// make a DbHelper Class First

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'timetodelete.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scheduled_files (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT,
      name TEXT,
      extension TEXT,
      scheduled_time TEXT
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final Database dbClient = await db as Database;
    return await dbClient.insert('scheduled_files', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final Database dbClient = await db as Database;
    return await dbClient.query('scheduled_files');
  }

  Future<int> delete(int id) async {
    final Database dbClient = await db as Database;
    return await dbClient
        .delete('scheduled_files', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final Database dbClient = await db as Database;
    return await dbClient.update('scheduled_files', row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<void> close() async {
    final Database dbClient = await db as Database;
    dbClient.close();
  }

  Future<void> deleteAll() async {
    final Database dbClient = await db as Database;
    dbClient.delete('scheduled_files');
  }

  Future<void> deleteTable() async {
    final Database dbClient = await db as Database;
    dbClient.execute('DROP TABLE IF EXISTS scheduled_files');
  }

  Future<void> deleteDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'timetodelete.db');
    deleteDatabase(path);
  }

  Future<void> deleteAllFiles() async {
    final Database dbClient = await db as Database;
    dbClient.execute('DELETE FROM scheduled_files');
  }
  
}
