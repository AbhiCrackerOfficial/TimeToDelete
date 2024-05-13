import 'dart:io';
import 'package:timetodelete/utils/helper/db.dart';

/// Background service responsible for managing file deletion based on scheduled time.
class BackgroundService {
  late DBHelper _db;
  List<Map<String, dynamic>> allFiles = [];

  /// Constructor initializes the background service.
  BackgroundService() {
    _init();
  }

  /// Initializes the database and fetches all files from it.
  void _init() async {
    _db = DBHelper();
    await _db.database;
    allFiles = await _db.queryAll();
  }

  /// Updates the list of all files by querying the database.
  Future<void> updateAllFiles() async {
    allFiles = await _db.queryAll();
  }

  /// Deletes a file with the given [id] and [file].
  ///
  /// Returns the number of rows affected by the delete operation.
  Future<void> deleteFile(int id, File file) async {
    if (file.existsSync()) {
      await file.delete();
    }
    await _db.delete(id);
    return await updateAllFiles();
  }

  /// Checks all files and deletes those whose scheduled time has passed.
  ///
  /// This method iterates over all files and deletes those whose scheduled time
  /// is earlier than the current time.
  Future<void> checkFiles() async {
    await updateAllFiles();
    print("Checking files : ${allFiles.length} files");
    final currentTime = DateTime.now();
    print("Current time: $currentTime");
    for (final file in allFiles) {
      final scheduledTime = DateTime.parse(file['scheduled_time']);
      print("Name: ${file['name']}");
      print("Scheduled time: $scheduledTime");
      if (currentTime.isAfter(scheduledTime)) {
        print("Deleting file: ${file['path']}");
        await deleteFile(file['id'], File(file['path']));
      }
    }
  }
}
