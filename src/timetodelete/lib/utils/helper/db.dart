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
            name TEXT,
            path TEXT UNIQUE,
            scheduled_time TEXT
          )
        ''');
      },
    );
  }

  // Insert a row into the 'scheduled_files' table
  Future<Map<bool, String>> insert(Map<String, dynamic> row) async {
    try {
      final dbClient = await database;
      int res = await dbClient.insert('scheduled_files', row);
      if (res != 0) {
        return {true: 'Success'};
      } else {
        return {false: 'Failed'};
      }
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return {false: 'File already scheduled for deletion'};
      }
      return {false: 'Failed For This File'};
    }

    
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


// =============== FAQ =============== //
// what type of input is expected for the 'row' parameter?
// The 'row' parameter is a Map<String, dynamic> object that represents a row in the 'scheduled_files' table.
// The keys in the map represent the column names in the table, and the values represent the corresponding column values.
// The 'row' parameter should contain the following keys:
// - 'path': The path of the file to be deleted.
// - 'name': The name of the file to be deleted.
// - 'scheduled_time': The time at which the file should be deleted.
// row should be like this:
// {
//   'path': '/path/to/file',
//   'name': 'file.txt',
//   'scheduled_time': '2022-01-01T12:00:00Z',
// }