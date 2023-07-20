import 'package:flutter/material.dart';

import 'exercise.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  const ExercisePage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text(exercise.instructions))),
    );
  }
}
