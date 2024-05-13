import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/pages/layout.dart';
import 'package:timetodelete/service/background_service.dart';
import 'package:timetodelete/utils/functions.dart';
import 'package:workmanager/workmanager.dart';

BackgroundService backgroundService = BackgroundService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool batteryOptimizationDisabled = await isBatteryOptimizationDisable();
  if (!batteryOptimizationDisabled) {
    // Handle case where battery optimization is not disabled
    return;
  }

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    '1',
    'simplePeriodicFileScheduledTask',
    frequency: const Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );

  runApp(
    const ProviderScope(
      child: Layout(),
    ),
  );
}

Future<bool> isBatteryOptimizationDisable() async {
  return await checkAndHandleBatteryOptimization();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('Background service started and checking files...');
    await backgroundService.checkFiles();
    return Future.value(true); // Or false if problems arise
  });
}
