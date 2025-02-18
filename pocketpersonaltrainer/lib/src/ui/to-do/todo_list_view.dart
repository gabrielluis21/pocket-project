import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_model.dart';
import 'package:pocketpersonaltrainer/src/ui/to-do/widgets/custom_list.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({
    super.key,
    this.currentUSer,
    this.controller,
    this.selectedDate,
  });

  final DateTime? selectedDate;
  final UserExercisesController? controller;
  final UserModel? currentUSer;

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  @override
  void initState() {
    if (widget.controller?.myExercises.isEmpty ?? true) {
      widget.controller?.loadAll();
    }
    super.initState();
  }

  Future<void> _refresh(List toDoList) async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b) {
        if (a["isDone"] == true && b["isDone"] == false) {
          return 1;
        } else if (a["isDone"] == false && b["isDone"] == true) {
          return -1;
        } else {
          return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        /* decoration: BoxDecoration(
          gradient: settingsController.themeMode == ThemeMode.dark ? AppColorTheme().customDarkColorScheme.surface, : AppColorTheme().customLightColorScheme.surface,
        ), */
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)!.toDoTitle),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _refresh(widget.controller!.myExercises);
            },
          ),
        ],
      ),
      body: widget.currentUSer!.myExercises?.isEmpty == true
          ? const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: FlareActor(
                  'assets/animations/WeightSpin.flr',
                  animation: 'Spin',
                ),
              ),
            )
          : CustomList(controller: widget.controller!, list: widget.currentUSer!.myExercises!),
    ));
  }
}
