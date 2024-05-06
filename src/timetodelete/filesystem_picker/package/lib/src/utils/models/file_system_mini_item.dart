import 'dart:io';

class FileSystemMiniItem {
  final String absolutePath;
  final FileSystemEntityType type;
  String get name => absolutePath.split('/').last;
  DateTime get modifiedDate => File(absolutePath).lastModifiedSync();
  FileSystemMiniItem(this.absolutePath, this.type);
}
