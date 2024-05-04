import 'package:flutter/material.dart';

import '../data/theme_data.dart';

class Recieve extends StatelessWidget {
  const Recieve({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeToDelete',
      theme: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? darkTheme
          : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Schedule', style: TextStyle(fontSize: 28.0)),
        ),
        body: const Center(
          child: Text('Schedule'),
        ),
      ),
    );
  }
}
