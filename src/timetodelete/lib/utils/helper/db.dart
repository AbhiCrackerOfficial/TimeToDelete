import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  bool get isOpen => _database?.isOpen ?? false;

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'timetodelete.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scheduled_files (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            name TEXT,
            extension TEXT,
            scheduled_time TEXT
          )
        ''');
      },
    );
  }

  // Insert a row into the 'scheduled_files' table
  Future<int> insert(Map<String, dynamic> row) async {
    final dbClient = await database;
    return await dbClient.insert('scheduled_files', row);
  }

  // Retrieve all rows from the 'scheduled_files' table
  Future<List<Map<String, dynamic>>> queryAll() async {
    final dbClient = await database;
    return await dbClient.query('scheduled_files');
  }

  // Delete a row from the 'scheduled_files' table based on id
  Future<int> delete(int id) async {
    final dbClient = await database;
    return await dbClient.delete(
      'scheduled_files',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a row in the 'scheduled_files' table based on id
  Future<int> update(Map<String, dynamic> row) async {
    final dbClient = await database;
    return await dbClient.update(
      'scheduled_files',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  // Close the database connection
  Future<void> close() async {
    final dbClient = await database;
    dbClient.close();
  }

  // Delete all rows from the 'scheduled_files' table
  Future<void> deleteAll() async {
    final dbClient = await database;
    await dbClient.delete('scheduled_files');
  }

  // Delete the entire 'scheduled_files' table
  Future<void> deleteTable() async {
    final dbClient = await database;
    await dbClient.execute('DROP TABLE IF EXISTS scheduled_files');
  }

  // Delete the entire database
  Future<void> deleteDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'timetodelete.db');
    await deleteDatabase(path);
  }

  // Delete all rows from the 'scheduled_files' table
  Future<void> deleteAllFiles() async {
    final dbClient = await database;
    await dbClient.execute('DELETE FROM scheduled_files');
  }
}
