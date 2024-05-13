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

  bool validateDateTime() {
    return dateTime != null && dateTime!.isAfter(DateTime.now());
  }

  void _saveScheduledDeletion() async {
    if (validateDateTime()) {
      for (final file in widget.selectedFiles) {
        print(dateTime!.toUtc().toIso8601String().substring(0, 16));
        Map<bool, String> res = await _db.insert({
          'name': file.name,
          'path': file.absolutePath,
          'scheduled_time': dateTime!.toUtc().toIso8601String().substring(0, 16),
        });
        
        if (res.keys.first) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${file.name} scheduled for deletion'),
                duration: const Duration(seconds: 1)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${file.name} already scheduled for deletion'),
                duration: const Duration(seconds: 1)),
          );
        }
      }
      Navigator.of(context).pop();
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Date/Time'),
            content: const Text(
                'Please select a date and time in the future to schedule the deletion.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
