import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/pages/layout.dart';
import 'package:timetodelete/utils/functions.dart';
import 'package:workmanager/workmanager.dart';

Future<bool> isBatteryOptimizationDisable() async {
  bool isBatteryOptimizationDisabled =
      await checkAndHandleBatteryOptimization();
  if (isBatteryOptimizationDisabled) {
    return true;
  } else {
    return false;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  isBatteryOptimizationDisable();
  runApp(
    const ProviderScope(
      child: Layout(),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. Get scheduled files from database (ScheduledFileDao)
    // 2. For each file:
    //    a. If current time >= scheduledTime:
    //       i. Delete the file (File class from dart:io)
    //       ii. Remove the file from SQLite
    // 3. If necessary, reschedule the background task
    return Future.value(true); // Or false if problems arise
  });
}
