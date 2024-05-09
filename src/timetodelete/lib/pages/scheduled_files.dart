import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetodelete/provider/databaseProvider.dart';
import 'package:timetodelete/utils/helper/db.dart';

class ScheduledFiles extends ConsumerStatefulWidget {
  const ScheduledFiles({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduledFiles> createState() => _ScheduledFilesState();
}

class _ScheduledFilesState extends ConsumerState<ScheduledFiles> {
  DbHelper? _db; // Make it nullable since it's initialized asynchronously
  bool isSearchBarVisible = false;

  void toggleSearchBarVisibility() {
    setState(() {
      isSearchBarVisible = !isSearchBarVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  Future<void> _initializeDB() async {
  _db = await ref.read(databaseProvider.future);
  await _db?.db;
  
  debugPrint('Database initialized: ${_db?.isOpen}');
}


  @override
  void dispose() async {
    await _db?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Files', style: TextStyle(fontSize: 28.0)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort_outlined),
            onPressed: () {
              debugPrint(_db?.isOpen.toString() ?? 'Database is not initialized');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: toggleSearchBarVisibility,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          if (isSearchBarVisible)
            SearchBar(
              hintText: "Search for files",
              shadowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              onSubmitted: (value) {
                // search for the file
              },
              onChanged: (value) {
                // filter the list of files
              },
            ),
        ],
      ),
    );
  }
}
