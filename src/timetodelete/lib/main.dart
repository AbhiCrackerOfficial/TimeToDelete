import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/pages/splash.dart';
import 'package:timetodelete/service/background_service.dart';
import 'package:timetodelete/utils/functions.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: Splash(),
    ),
  );
}

Future<bool> isBatteryOptimizationDisable() async {
  return await checkAndHandleBatteryOptimization();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'TimeToDelete',
    'TimeToDelete is running',
    description: 'TimeToDelete is running in the background',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      notificationChannelId: 'TimeToDelete',
      initialNotificationTitle: 'TimeToDelete is running',
      initialNotificationContent: 'TimeToDelete is running in the background',
      foregroundServiceNotificationId: 111,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  BackgroundService backgroundService = BackgroundService();
  Timer.periodic(const Duration(minutes: 1), (timer) {
    backgroundService.checkFiles();
  });
}
