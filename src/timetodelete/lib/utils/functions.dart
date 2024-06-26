import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';

final Color purple = hexToColor("#7630fa");
final Color yellow = hexToColor("#f5d547");
final Color black = hexToColor("#121212");

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

String colorToHexColor(Color color) {
  return '#${color.value.toRadixString(16).substring(2)}';
}

MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};

  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

class StyledText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final String? fontFamily;

  const StyledText(
      {super.key,
      required this.text,
      this.color,
      this.size,
      this.fontWeight,
      this.letterSpacing,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily));
  }
}

Future<bool> checkAndHandleBatteryOptimization() async {
  bool? isAutoStartEnabled = await DisableBatteryOptimization.isAutoStartEnabled;

  if (isAutoStartEnabled ?? false) {
    await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
  }

  bool? isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;

  if (!(isBatteryOptimizationDisabled ?? false)) {
    bool? showManufacturerSettings = await DisableBatteryOptimization
        .showDisableManufacturerBatteryOptimizationSettings(
            "Your device has additional battery optimization",
            "Follow the steps and disable the optimizations to allow smooth functioning of this app");

    return showManufacturerSettings ?? false;
  }
  return isBatteryOptimizationDisabled ?? false;
}


Future<bool> storagePermission() async {
  final DeviceInfoPlugin info = DeviceInfoPlugin();
  final AndroidDeviceInfo androidInfo = await info.androidInfo;
  final int androidVersion = int.parse(androidInfo.version.release);
  bool havePermission = false;

  if (androidVersion >= 13) {
    final request = await [
      Permission.videos,
      Permission.photos,
      Permission.manageExternalStorage,
    ].request();
    havePermission =
        request.values.every((status) => status == PermissionStatus.granted);
  } else {
    final status = await Permission.storage.request();
    havePermission = status.isGranted;
  }

  if (!havePermission) {
    await openAppSettings();
  }
  return havePermission;
}
