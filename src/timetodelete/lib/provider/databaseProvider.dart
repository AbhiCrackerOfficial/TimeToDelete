import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetodelete/utils/helper/db.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  Database db = await DbHelper().db;
  db.close();
  return db;
});
