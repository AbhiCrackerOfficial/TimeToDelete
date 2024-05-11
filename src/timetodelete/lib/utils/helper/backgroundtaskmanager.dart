import 'package:timetodelete/main.dart';
import 'package:workmanager/workmanager.dart';

import '../../models/scheduled_file.dart';

class BackgroundTaskManager {
  void initialize() {
    // For Android:
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  void scheduleDeletionTask(ScheduledFile file) {
    // Use Workmanager.registerOneOffTask or similar
    // Provide file.id as inputData 
  }

  void cancelDeletionTask(int fileId) {
    // Workmanager.cancelById or similar 
  }
}