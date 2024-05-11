import 'package:flutter/material.dart';

class ScheduledFileTile extends StatelessWidget {
  final int id;
  final String name;
  final String scheduledTime;
  final String path;
  const ScheduledFileTile(
      {super.key,
      required this.id,
      required this.name,
      required this.scheduledTime,
      required this.path});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(path),
      trailing: Text(scheduledTime),
      // show delete icon
      leading: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
        },
      ),
    );
  }
}
