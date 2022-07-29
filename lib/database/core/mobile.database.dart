import 'dart:io';

import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

AppDatabase constructDb() {
  final db = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'serapdb.sqlite'));
    return NativeDatabase(
      file,
      logStatements: kDebugMode,
    );
  });
  return AppDatabase(db);
}
