import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/provider/databaseProvider.dart';
import 'package:timetodelete/utils/helper/db.dart';

class ScheduledFiles extends ConsumerStatefulWidget {
  const ScheduledFiles({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduledFiles> createState() => _ScheduledFilesState();
}

class _ScheduledFilesState extends ConsumerState<ScheduledFiles> {
  late final DBHelper _db;
  bool isSearchBarVisible = false;
  SearchController searchController = SearchController();
  late List<Map<String, dynamic>> files;
  late List<Map<String, dynamic>> filteredFiles;

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
    fetchData();
  }

  Future<void> fetchData() async {
    final db = await _db.database;
    files = await db.query('scheduled_files');
    filteredFiles = List.from(files);
    setState(() {});
  }

  void deleteFile(Map<String, dynamic> file) {
    setState(() {
      _db.delete(file['id']).then((value) {
        if (value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${file['name']} deleted successfully'),
            ),
          );
          fetchData(); // Refetch data after deletion
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete ${file['name']}'),
            ),
          );
        }
      });
    });
  }

  void filterFiles(String query) {
    setState(() {
      filteredFiles = files
          .where((file) =>
              file['name'].toLowerCase().contains(query.toLowerCase()) ||
              file['path'].toLowerCase().contains(query.toLowerCase()) ||
              file['scheduled_time']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Files', style: TextStyle(fontSize: 28.0)),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                fetchData();
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
              controller: searchController,
              onSubmitted: (value) {
                filterFiles(value);
              },
              onChanged: (value) {
                filterFiles(value);
              },
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (BuildContext context, int index) {
                final file = filteredFiles.elementAt(index);
                return ListTile(
                  title: Text(file['name']),
                  subtitle: Text(file['path']),
                  leading: Text(file['scheduled_time'].substring(0, 16)),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      deleteFile(file);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
