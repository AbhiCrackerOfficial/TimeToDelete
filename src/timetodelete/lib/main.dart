import 'package:flutter/material.dart';
import 'package:timetodelete/pages/layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Layout()));
}
