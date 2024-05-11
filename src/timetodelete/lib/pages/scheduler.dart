import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/file_system_picker/lib/src/utils/models/file_system_mini_item.dart';
import 'package:timetodelete/provider/databaseProvider.dart';
import 'package:timetodelete/utils/helper/db.dart';

class Scheduler extends ConsumerStatefulWidget {
  final Iterable<FileSystemMiniItem> selectedFiles;

  const Scheduler({Key? key, required this.selectedFiles}) : super(key: key);

  @override
  ConsumerState<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends ConsumerState<Scheduler> {
  late DBHelper _db;
  DateTime? dateTime;
  bool isListShown = false;
  Icon icon = const Icon(Icons.info_outline);

  @override
  void initState() {
    super.initState();
    _db = ref.read(databaseProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduler')),
      body: Column(
        children: [
          Expanded(child: _buildFileList()),
          _buildDateTimePickerRow(context),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 8.0, bottom: 8.0),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              title: Text('Selected Files (${widget.selectedFiles.length})'),
              trailing: icon,
              onTap: () => _toggleSelectedFilesList(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            itemCount: widget.selectedFiles.length,
            itemBuilder: (BuildContext context, int index) {
              final file = widget.selectedFiles.elementAt(index);
              return ListTile(
                // change the tile color to apps primary color
                tileColor: Theme.of(context).hoverColor,
                title: Text(file.name),
                subtitle: isListShown ? Text(file.absolutePath) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return ListTile(
      title: const Text('Date'),
      subtitle: Text(
          dateTime?.toIso8601String().substring(0, 10) ?? 'No date selected'),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: dateTime ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              dateTime?.hour ?? 0,
              dateTime?.minute ?? 0,
            );
          });
        }
      },
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return ListTile(
      title: const Text('Time'),
      subtitle: Text(
          dateTime?.toIso8601String().substring(11, 16) ?? 'No time selected'),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(dateTime ?? DateTime.now()),
        );
        if (time != null) {
          setState(() {
            dateTime = DateTime(
              dateTime?.year ?? DateTime.now().year,
              dateTime?.month ?? DateTime.now().month,
              dateTime?.day ?? DateTime.now().day,
              time.hour,
              time.minute,
            );
          });
        }
      },
    );
  }

  Widget _buildDateTimePickerRow(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(child: _buildDatePicker(context)),
          Expanded(child: _buildTimePicker(context)),
          ElevatedButton(
              onPressed: _saveScheduledDeletion, child: const Text('Save')),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void _saveScheduledDeletion() async {
    if (dateTime != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scheduled for deletion')),
      );
      Navigator.of(context).pop();
    }
  }

  void _toggleSelectedFilesList() {
    setState(() {
      icon =
          isListShown ? const Icon(Icons.info_outline) : const Icon(Icons.info);
      isListShown = !isListShown;
    });
  }
}
