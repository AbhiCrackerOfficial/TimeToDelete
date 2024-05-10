import 'dart:io';
import 'package:flutter/material.dart';
import 'package:timetodelete/file_system_picker/lib/filesystem_picker.dart';
import 'package:timetodelete/file_system_picker/lib/src/utils/models/file_system_mini_item.dart';
import 'package:timetodelete/pages/scheduler.dart';
import '../utils/functions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TimeToDelete', style: TextStyle(fontSize: 28.0)),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  // create a dialog box
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('About TimeToDelete'),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'TimeToDelete is a simple app that allows you to schedule the deletion of files from your device automatically.',
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Developer: AbhiCracker',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'This app is currently under development.',
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.info)),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to TimeToDelete',
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  Iterable<FileSystemMiniItem>? selectedFiles =
                      await FilesystemPicker.open(
                    title: 'Select files',
                    context: context,
                    multiSelect: true,
                    rootDirectories: [Directory('/storage/emulated/0/')],
                    fsType: FilesystemType.file,
                    allowedExtensions: null,
                    requestPermission: () async {
                      return await storagePermission();
                    },
                    folderIconColor: Theme.of(context).highlightColor,
                  );

                  print(selectedFiles?.first.name);

                  if (selectedFiles != null) {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      // isScrollControlled: true,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return Scheduler(selectedFiles: selectedFiles);
                      },
                      useRootNavigator: true,

                    );

                    // List<String> files =
                    //     selectedFiles.map((file) => file.absolutePath).toList();
                    // for (String file in files) {
                    //   File f = File(file);
                    //   f.delete().then((value) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Files Deleted Successfully'),
                    //         duration: Duration(seconds: 1),
                    //       ),
                    //     );
                    //   });
                    // }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 80),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Select File'),
              ),
            ],
          ),
        ));
  }
}
