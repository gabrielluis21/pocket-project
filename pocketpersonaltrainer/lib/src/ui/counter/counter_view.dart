import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';

class CounterScreen extends StatefulWidget {
  final UserExercises exercises;

  const CounterScreen({super.key, required this.exercises});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> with TickerProviderStateMixin {
  int _n = 0;

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  void add() {
    setState(() {
      _n++;
    });
  }

  Widget buildTitle() {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        return Text(
          widget.exercises.exerciseData?.name?['en'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
      case AppLanguages.ES:
        return Text(
          widget.exercises.exerciseData?.name?['es'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
      case AppLanguages.FR:
        return Text(
          widget.exercises.exerciseData?.name?['fr'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
      case AppLanguages.CH:
        return Text(
          widget.exercises.exerciseData?.name?['zh'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
      case AppLanguages.DE:
        return Text(
          widget.exercises.exerciseData?.name?['de'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
      default:
        return Text(
          widget.exercises.exerciseData?.name?['pt-br'],
          style: const TextStyle(fontSize: 25.0, color: Colors.white),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        backgroundColor: themeData.primaryColor,
        body: Container(
          padding: const EdgeInsets.only(top: 150.0),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Align(alignment: FractionalOffset.center, child: buildTitle()),
            const SizedBox(
              height: 25.0,
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      add();
                      if (_n == widget.exercises.quantity) {
                        widget.exercises.isDone = true;
                        widget.exercises.doneIn = DateTime.now();
                        Get.find<UserExercisesController>().updateUserExercise(widget.exercises);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  Text('$_n', style: const TextStyle(fontSize: 60.0)),
                  const SizedBox(
                    width: 25.0,
                  ),
                  ElevatedButton(
                    onPressed: minus,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Icon(Icons.remove, color: Colors.black),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
