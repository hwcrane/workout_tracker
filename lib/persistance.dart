import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'exercise.dart';

class Persistance {
  static Future<sql.Database> db() async {
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

  static Future<List<Exercise>> getExercises() async {
    final connection = await db();

    final List<Map<String, dynamic>> maps = await connection.query("Exercise");

    return List.generate(maps.length, (i) {
      return Exercise(
          exerciseId: maps[i]['exercise_id'],
          name: maps[i]['name'].toString().replaceAll("-", " ").replaceAll("\n", "").toTitleCase(),
          instructions: maps[i]['instructions'],
          type: maps[i]['type'],
          bodyPart: maps[i]['body_part'],
          equipment: maps[i]['equipment'],
          level: maps[i]['level']);
    });
  }
}

String convertToTitleCase(String text) {
  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);

      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

extension CapitalizedStringExtension on String {
  String toTitleCase() {
    return convertToTitleCase(this);
  }
}
