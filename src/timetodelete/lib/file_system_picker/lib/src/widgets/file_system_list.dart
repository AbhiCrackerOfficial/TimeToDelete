// Imported libraries
import 'dart:async';
import 'dart:io';

// External packages
import 'package:timetodelete/file_system_picker/lib/src/utils/models/file_system_mini_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

// Internal files
import '../constants/enums/file_system_type.dart';
import '../constants/typedefs/typedefs.dart';
import 'filesystem_list_tile.dart';

// FilesystemList class for displaying directory contents
class FilesystemList extends StatelessWidget {
  // Properties
  final List<FileSystemMiniItem> items; // List of filesystem items
  final bool isRoot; // Indicator if the current directory is the root
  final bool isSearching; // Indicator if the user is searching for items
  final Directory rootDirectory; // Root directory
  final FilesystemType fsType; // Type of filesystem items to display
  final Color? folderIconColor; // Color for folder icons
  final List<String>? allowedExtensions; // List of allowed file extensions
  final ValueChanged<Directory> onChange; // Callback for directory change
  final ValueSelected onSelect; // Callback for item selection
  final Iterable<String> selectedItems; // Selected items
  final bool multiSelect; // Indicator if multiple items can be selected
  final ThemeData? themeData; // Theme data
  final TextDirection? textDirection; // Text direction
  final bool isTimeSorting; // Indicator if sorting by time

  // Constructor
  const FilesystemList({
    Key? key,
    required this.items,
    this.isRoot = false,
    required this.rootDirectory,
    this.fsType = FilesystemType.all,
    this.folderIconColor,
    this.allowedExtensions,
    required this.onChange,
    required this.onSelect,
    required this.selectedItems,
    this.multiSelect = false,
    this.themeData,
    this.textDirection,
    this.isSearching = false,
    this.isTimeSorting = false,
  }) : super(key: key);

  String handleSort() {
    if (isTimeSorting) {
      return 'Time';
    } else {
      return 'Alpha';
    }
  }

  // Method to retrieve directory contents asynchronously
  Future<List<FileSystemEntity>> _getDirContents() {
    var items = <FileSystemEntity>[]; // List to hold filesystem entities
    var completer =
        Completer<List<FileSystemEntity>>(); // Completer for async operation

    // If searching, return items without listing directories
    if (isSearching) {
      items.addAll(this.items.map((e) {
        if (e.type == FileSystemEntityType.file) {
          return File(e.absolutePath);
        } else if (e.type == FileSystemEntityType.directory) {
          return Directory(e.absolutePath);
        } else {
          return File(e.absolutePath);
        }
      }));

      if (handleSort() == 'Time') {
        items.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      } else {
        items.sort((a, b) => a.path.compareTo(b.path));
      }

      completer.complete(items);
    } else {
      // If not searching, list contents of root directory
      var lister = rootDirectory.list(recursive: false);
      lister.listen(
        (file) {
          if ((fsType != FilesystemType.folder) || (file is Directory)) {
            if ((file is File) &&
                (allowedExtensions != null) &&
                (allowedExtensions!.isNotEmpty)) {
              if (!allowedExtensions!.contains(path.extension(file.path))) {
                return;
              }
            }
            items.add(file);
          }
        },
        onDone: () {
          if (handleSort() == 'Time') {
            items.sort((a, b) =>
                b.statSync().modified.compareTo(a.statSync().modified));
            print('Sorting by time');
          } else {
            print('No sorting');
            items.sort((a, b) => a.path.compareTo(b.path));
          }
          completer.complete(items);
        },
        onError: (error) {
          completer.completeError(error); // Handle error
        },
      );
    }

    return completer.future; // Return future of directory contents
  }

  // Widget for top navigation to parent directory
  InkWell _topNavigation() {
    return InkWell(
      onTap: () {
        final li = rootDirectory.path.split(Platform.pathSeparator)
          ..removeLast();
        onChange(Directory(
            li.join(Platform.pathSeparator))); // Navigate to parent directory
      },
      child: const ListTile(
        leading: Icon(Icons.arrow_upward, size: 32), // Icon for navigating up
        title:
            Text('...', textScaleFactor: 1.5), // Text indicating navigation up
      ),
    );
  }

  // Build method to create widget
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDirContents(),
      builder: (BuildContext context,
          AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        items.clear(); // Clear existing items
        if (snapshot.hasData) {
          var chs = <Widget>[]; // List of children widgets

          // Add top navigation widget if not root directory
          if (!isRoot) {
            chs.add(_topNavigation()); // Add navigation widget
            chs.add(const Divider(color: Colors.grey, height: 1)); // Divider line
          }

          // Process directory contents
          if (snapshot.data!.isNotEmpty) {
            var dirs = <FileSystemEntity>[]; // List of directories
            var files = <FileSystemEntity>[]; // List of files
            for (var fse in snapshot.data!) {
              if (fse is File) {
                files.add(fse);
              } else if (fse is Directory) {
                dirs.add(fse);
              }
            }

            // Concatenate directories and files
            dirs.followedBy(files).forEach((fse) {
              chs.add(
                FilesystemListTile(
                  fsType: fsType,
                  item: fse,
                  folderIconColor: folderIconColor,
                  onChange: onChange,
                  onSelect: onSelect,
                  isSelected: selectedItems.contains(fse.absolute.path),
                  subItemsSelected: selectedItems.any((ee) => ee
                      .startsWith(fse.absolute.path + Platform.pathSeparator)),
                  multiSelect: multiSelect,
                  themeData: themeData,
                  textDirection: textDirection,
                ),
              );
              chs.add(const Divider(
                  color: Colors.grey, height: 1)); // Divider between items
              items.add(
                FileSystemMiniItem(
                    fse.absolute.path,
                    fse is File
                        ? FileSystemEntityType.file
                        : fse is Directory
                            ? FileSystemEntityType.directory
                            : FileSystemEntityType.notFound),
              );
            });
          }
          return ListView(
            physics: const BouncingScrollPhysics(), // Bouncing scroll physics
            shrinkWrap: true,
            semanticChildCount: chs.length,
            children: chs, // Rendered children
          );
        }
        return const Center(
          child: CircularProgressIndicator(), // Loading indicator
        );
      },
    );
  }
}
