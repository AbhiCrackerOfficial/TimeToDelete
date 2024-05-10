import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/file_system_picker/lib/src/utils/models/file_system_mini_item.dart';
import 'package:timetodelete/provider/databaseProvider.dart';
import 'package:timetodelete/utils/helper/db.dart';

class Scheduler extends ConsumerStatefulWidget {

  Iterable<FileSystemMiniItem> selectedFiles = [];
  
  Scheduler({Key? key, required Iterable<FileSystemMiniItem> selectedFiles}) : super(key: key);

  @override
  ConsumerState<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends ConsumerState<Scheduler> {
  late DBHelper _db;

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduler', style: TextStyle(fontSize: 28.0)),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          const Text('Select the time and date to delete the files'),
          const SizedBox(
            height: 10,
          ),
          const Text('Selected files:'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.selectedFiles.elementAt(index).name),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              // show date picker
            },
            child: const Text('Select date'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              // show time picker
            },
            child: const Text('Select time'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              // schedule the deletion
            },
            child: const Text('Schedule deletion'),
          ),
        ],
      ),
    );
  }
}
