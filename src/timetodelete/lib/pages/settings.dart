import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void checkForUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print('Current version: $currentVersion');
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/AbhiCrackerOfficial/TimeToDelete/releases/latest'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String latestVersion = data['tag_name'];
      if (latestVersion != currentVersion) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Available'),
              content: const Text(
                  'A new version of the app is available. Please update to the latest version.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse(
                        'https://github.com/AbhiCrackerOfficial/TimeToDelete/releases/latest'));
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('No Updates Available'),
              content: const Text(
                  'You are already using the latest version of the app.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Updates Available'),
            content: const Text(
                'You are already using the latest version of the app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 28.0)),
      ),
      body: ListView(
        children: [
          GestureDetector(
            child: const ListTile(
              title: Text('Check for updates'),
              subtitle: Text('Check for updates to the app'),
              trailing: Icon(Icons.update_sharp),
            ),
            onTap: () {
              checkForUpdate();
            },
          ),
        ],
      ),
    );
  }
}
