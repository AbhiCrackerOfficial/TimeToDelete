import 'package:timetodelete/file_system_picker/lib/src/utils/models/file_system_mini_item.dart';
// Create a model class for ScheduledFile
// its schema designed is extended version of FileSystemMiniItem
// with additional properties like scheduledTime

class ScheduledFile {
  final String path;
  final String name;
  final String extension;
  final DateTime scheduledTime;

  ScheduledFile({
    required this.path,
    required this.name,
    required this.extension,
    required this.scheduledTime,
  });

  factory ScheduledFile.fromFileSystemMiniItem(
      FileSystemMiniItem item, DateTime scheduledTime) {
    return ScheduledFile(
      name: item.name,
      path: item.absolutePath,
      extension: item.absolutePath.split('.').last,
      scheduledTime: scheduledTime,
    );
  }
}
