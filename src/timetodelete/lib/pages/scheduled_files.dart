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
  final searchController = TextEditingController();
  late List<Map<String, dynamic>> files = [];
  late List<Map<String, dynamic>> filteredFiles = [];
  late Icon icon;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
    fetchData();
    icon = const Icon(Icons.access_time);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchData() async {
    final db = await _db.database;
    files = await db.query('scheduled_files');
    if (!_isDisposed) {
      filteredFiles = List.from(files);
      setState(() {});
    }
  }

  void toggleSearchBarVisibility() {
    if (!_isDisposed) {
      setState(() {
        isSearchBarVisible = !isSearchBarVisible;
      });
    }
  }

  void deleteFile(Map<String, dynamic> file) {
    if (!_isDisposed) {
      _db.delete(file['id']).then((value) {
        if (!_isDisposed) {
          if (value == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("${file['name']}'s Schedule cancelled successfully"),
              ),
            );
            fetchData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to cancel ${file['name']}'s Schedule"),
              ),
            );
          }
        }
      });
    }
  }

  void filterFiles(String query) {
    if (!_isDisposed) {
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
  }

  void sortByScheduledTime() {
    if (!_isDisposed) {
      setState(() {
        filteredFiles.sort((a, b) {
          return a['scheduled_time'].compareTo(b['scheduled_time']);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Files', style: TextStyle(fontSize: 28.0)),
        actions: <Widget>[
          IconButton(
            onPressed: fetchData,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: icon,
            onPressed: () {
              if (!_isDisposed) {
                setState(() {
                  if (icon.icon == Icons.access_time) {
                    icon = const Icon(Icons.access_time_filled);
                    sortByScheduledTime();
                  } else {
                    icon = const Icon(Icons.access_time);
                    fetchData();
                  }
                });
              }
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
          if (isSearchBarVisible)
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'Search for Scheduled files',
                  prefixIcon: Icon(Icons.search)),
              onChanged: filterFiles,
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (BuildContext context, int index) {
                final file = filteredFiles[index];
                return ListTile(
                  title: Text(file['name']),
                  subtitle: Text(file['path']),
                  leading: Text(file['scheduled_time']
                      .substring(0, 16)
                      .split('T')
                      .join('\n')),
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
