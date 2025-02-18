import 'package:flutter/material.dart';

class ExerciseImageDetails extends StatelessWidget {
  final String exerciseName;
  final String exerciseImage;

  const ExerciseImageDetails({super.key, required this.exerciseName, required this.exerciseImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.network(exerciseImage)),
    );
  }
}
