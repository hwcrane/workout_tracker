import 'package:flutter/material.dart';
import 'package:workout_tracker/models/exercise_model.dart';
import 'package:workout_tracker/views/exercise_page.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({
    super.key,
    required List<Exercise> exercises,
  }) : _exercises = exercises;

  final List<Exercise> _exercises;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: _exercises.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ExerciseListItem(exercise: _exercises[index]);
      },
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({
    super.key,
    required Exercise exercise,
  }) : _exercise = exercise;

  final Exercise _exercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_exercise.name),
      dense: true,
      subtitle: Text(_exercise.bodyPart),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercisePage(
              exercise: _exercise,
            ),
          ),
        );
      },
    );
  }
}
