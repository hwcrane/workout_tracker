import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Db {
  /// Establishes a connection to the database
  static Future<sql.Database> connect() async {
    var databasesPath = await sql.getDatabasesPath();
    var path = join(databasesPath, "database.db");

    var exists = await sql.databaseExists(path);

    // If the database does not exist copy it over from the assets folder
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "database.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await sql.openDatabase(path);
  }
}
