import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  
  DbHelper._internal();

  static late Database _db;

  // Initialize the database if not already initialized, and return the instance
  Future<Database> get db async {
    if (!(_db.isOpen)) {
      _db = await _initDb();
    }
    return _db;
  }

  // Initialize the database with proper error handling
  Future<Database> _initDb() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'timetodelete.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  // Create a function that tells if db is opened or not returns true or false
  Future<bool> get isOpen async {
    return _db.isOpen;
  }  

  // Create the necessary tables upon database creation
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

  // Insert a row into the 'scheduled_files' table
  Future<int> insert(Map<String, dynamic> row) async {
    final dbClient = await db;
    return await dbClient.insert('scheduled_files', row);
  }

  // Retrieve all rows from the 'scheduled_files' table
  Future<List<Map<String, dynamic>>> queryAll() async {
    final dbClient = await db;
    return await dbClient.query('scheduled_files');
  }

  // Delete a row from the 'scheduled_files' table based on id
  Future<int> delete(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'scheduled_files',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a row in the 'scheduled_files' table based on id
  Future<int> update(Map<String, dynamic> row) async {
    final dbClient = await db;
    return await dbClient.update(
      'scheduled_files',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  // Close the database connection
  Future<void> close() async {
    final dbClient = await db;
    dbClient.close();
  }

  // Delete all rows from the 'scheduled_files' table
  Future<void> deleteAll() async {
    final dbClient = await db;
    await dbClient.delete('scheduled_files');
  }

  // Delete the entire 'scheduled_files' table
  Future<void> deleteTable() async {
    final dbClient = await db;
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
    final dbClient = await db;
    await dbClient.execute('DELETE FROM scheduled_files');
  }
}
