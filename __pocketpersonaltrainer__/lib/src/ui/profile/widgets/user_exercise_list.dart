import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class UserExercisesList extends StatelessWidget {
  const UserExercisesList({Key? key, required this.userUID})
      : super(key: key);

  final String userUID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      future: FbDatabase()
          .database
          .collection("users")
          .doc(userUID)
          .collection("MyExercises")
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        int? isDone = snapshot.data!.docs
            .where((e) => e.data()["isDone"] == true)
            .toList()
            .length;
        int? notDone = snapshot.data!.docs
            .where((e) => e.data()["isDone"] == false)
            .toList()
            .length;
        return Center(
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Wrap(
                children: [
                  Icon(MdiIcons.target),
                  Text(
                    "Todos os exercícios: ${snapshot.data!.docs.length.toString()}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
              Wrap(
                children: [
                  const Icon(Icons.done_all),
                  Text(
                    " Todos os exercícios feitos: ${isDone.toString()}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
              Wrap(
                children: [
                  const Icon(Icons.error),
                  Text(
                    " Todos os exercícios a fazer: ${notDone.toString()}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
