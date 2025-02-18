import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/app/app_pages.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/ui/counter/counter_view.dart';
import 'package:pocketpersonaltrainer/src/ui/exercise/exercise_view.dart';
import 'package:pocketpersonaltrainer/src/ui/timer/timer_view.dart';

class CustomList extends StatefulWidget {
  const CustomList({
    Key? key,
    required this.controller,
    required this.list,
  }) : super(key: key);

  final UserExercisesController controller;
  final List<UserExercises> list;

  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  String language = '';
  var toDoList = List<UserExercises>.empty(growable: true);

  @override
  void initState() {
    toDoList = widget.list;
    super.initState();
  }

  Future<Null> _refresh(List toDoList) async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b) {
        if (a["isDone"] == true && b["isDone"] == false)
          return 1;
        else if (a["isDone"] == false && b["isDone"] == true)
          return -1;
        else
          return 0;
      });
    });
    return null;
  }

  Widget buildTitle(UserExercises exercise) {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        language = 'en';
        return Text(exercise.exerciseData?.name?['en']);
      case AppLanguages.ES:
        language = 'es';
        return Text(exercise.exerciseData?.name?['es']);
      case AppLanguages.FR:
        language = 'fr';
        return Text(exercise.exerciseData?.name?['fr']);
      case AppLanguages.CH:
        language = 'zh';
        return Text(exercise.exerciseData?.name?['zh']);
      case AppLanguages.DE:
        language = 'de';
        return Text(exercise.exerciseData?.name?['de']);
      default:
        language = 'pt-br';
        return Text(exercise.exerciseData?.name?['pt-br']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            if (toDoList.length != 0) {
              return GestureDetector(
                onLongPressUp: () {
                  print(toDoList[index].toMap());
                  _bottomSheet(context, toDoList[index]);
                },
                child: Dismissible(
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment(-0.9, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  child: CheckboxListTile(
                    value: toDoList[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        toDoList[index].isDone = value;
                        widget.controller.updateUserExercise(toDoList[index]);
                      });
                    },
                    title: buildTitle(toDoList[index]),
                    secondary: CircleAvatar(
                      child: Icon(toDoList[index].isDone! ? Icons.check : Icons.error),
                    ),
                  ),
                ),
              );
            } else {
              return ListTile(
                trailing: Icon(
                  MdiIcons.plus,
                  color: AppColorTheme().customLightColorScheme.primary,
                ),
                onTap: () {
                  Get.toNamed(Routes.CATEGORIA);
                },
                title: Text(
                  'Que tal começar um novo treino?',
                  style: TextStyle(
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                ),
              );
            }
          },
        ),
        onRefresh: () => _refresh(toDoList));
    /* return ; */
  }

  _bottomSheet(BuildContext context, UserExercises exercise) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {
            widget.controller.removeExercise(exercise);
          },
          backgroundColor: Colors.white,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    TextButton(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(Icons.description),
                            Text(AppLocalizations.of(context)!.myExerciseActions),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExerciseScreen(
                              language: language,
                              exercise: exercise.exerciseData!,
                            ),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer),
                            Text("Timer"),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimerScreen(exercise: exercise)));
                      },
                    ),
                    TextButton(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(MdiIcons.plusMinusBox),
                              const Text("Steps"),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CounterScreen(
                                    exercises: exercise,
                                  )));
                        }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
