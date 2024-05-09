import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:timetodelete/utils/helper/db.dart';

// create a provider for the database
final databaseProvider = FutureProvider<DbHelper>((ref) async {
  final dbHelper = DbHelper();
  // await dbHelper.db;
  return dbHelper;
});
