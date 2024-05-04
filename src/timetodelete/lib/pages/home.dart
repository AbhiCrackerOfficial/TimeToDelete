import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
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
          IconButton(onPressed: (){
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
          }, icon: const Icon(Icons.info)),
          
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
                String? rpath = await FilesystemPicker.open(
                  title: 'Select file',
                  context: context,
                  rootDirectory: Directory('/storage/emulated/0/'),
                  fsType: FilesystemType.file,
                  fileTileSelectMode: FileTileSelectMode.checkButton,
                  allowedExtensions: null,
                  requestPermission: () async {
                    return await storagePermission();
                  },
                );
                if (rpath != null) {
                  File file = File(rpath);
      
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Files Picked Successfully'),
                      duration: Duration(seconds: 1),
                    ),
                  );
      
                  // if (file.existsSync()) {
                  //   debugPrint("FILE EXISTS");
                  // } else {
                  //   debugPrint("FILE DOES NOT EXIST");
                  // }
      
                  file.delete().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Files Deleted Successfully'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  });
      
                  // if (file.existsSync()) {
                  //   debugPrint("FILE EXISTS");
                  // } else {
                  //   debugPrint("FILE DOES NOT EXIST");
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
