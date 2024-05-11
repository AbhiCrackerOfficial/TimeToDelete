import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/provider/databaseProvider.dart';
import 'package:timetodelete/utils/helper/db.dart';
import 'package:timetodelete/widgets/scheduledfile_tile.dart';

/// Widget to display a list of scheduled files.
class ScheduledFiles extends ConsumerStatefulWidget {
  const ScheduledFiles({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduledFiles> createState() => _ScheduledFilesState();
}

/// State class for [ScheduledFiles] widget.
class _ScheduledFilesState extends ConsumerState<ScheduledFiles> {
  late final DBHelper _db;
  bool isSearchBarVisible = false;

  /// Toggles the visibility of the search bar.
  void toggleSearchBarVisibility() {
    setState(() {
      isSearchBarVisible = !isSearchBarVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
    debugPrint('Database initialized: ${_db.isOpen}');
  }

  /// Fetches the list of scheduled files from the database.
  Future<List<Map<String, dynamic>>> getFiles() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> files = await db.query('scheduled_files');
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Files', style: TextStyle(fontSize: 28.0)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  // TODO: Implement refresh functionality
                });
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.sort_outlined),
            onPressed: () {},
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
                // TODO: Implement search functionality
              },
              onChanged: (value) {
                // TODO: Implement filter functionality
              },
            ),
          Expanded(
            child: FutureBuilder(
              future: getFiles(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<Map<String, dynamic>> files = snapshot.data!;
                  return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (BuildContext context, int index) {
                      final file = files[index];
                      return ScheduledFileTile(
                        id: file['id'],
                        name: file['name'],
                        path: file['path'],
                        scheduledTime: file['scheduled_time'],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
