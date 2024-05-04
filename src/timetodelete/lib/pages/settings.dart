import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 28.0)),
      ),
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}