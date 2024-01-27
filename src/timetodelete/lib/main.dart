import 'package:flutter/material.dart';
import 'package:timetodelete/pages/home.dart';
import 'package:permission_handler/permission_handler.dart';

void checkPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkPermissions();
  runApp(const Home());
}
