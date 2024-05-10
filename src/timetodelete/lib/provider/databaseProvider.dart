import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetodelete/utils/helper/db.dart';

final databaseProvider = Provider((ref) {
  DBHelper db = DBHelper();
  db.database;
  return db;
});

