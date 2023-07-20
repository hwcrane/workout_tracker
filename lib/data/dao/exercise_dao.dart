import 'package:workout_tracker/data/database.dart';
import 'package:workout_tracker/models/exercise_model.dart';
import 'package:workout_tracker/utils/utils.dart';

class ExerciseDAO {
  static Future<List<Exercise>> getAll() async {
    final connection = await Db.connect();

    final List<Map<String, dynamic>> maps = await connection.query("Exercise");

    return List.generate(maps.length, (i) {
      return Exercise(
          exerciseId: maps[i]['exercise_id'],
          name: maps[i]['name']
              .toString()
              .replaceAll("-", " ")
              .replaceAll("\n", "")
              .toTitleCase(),
          instructions: maps[i]['instructions'],
          type: maps[i]['type'],
          bodyPart: maps[i]['body_part'],
          equipment: maps[i]['equipment'],
          level: maps[i]['level']);
    });
  }
}
