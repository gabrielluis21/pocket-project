// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class UserExercisesController extends GetxController {
  final RxList<UserExercises> _myExercises = RxList<UserExercises>(List.empty(growable: true));
  List<UserExercises> get myExercises => _myExercises.value;

  final _database = FbDatabase();

  loadAll() {
    var userUID = Get.find<UserController>(tag: "user").user?.uid;
    _myExercises.bindStream(_database.getAllUserExercises(userUID!));
  }

  Future<void> saveExercise(UserExercises exercise) async {
    var userUID = Get.find<UserController>(tag: "user").user?.uid;
    exercise.isDone = false;
    await _database.addUserExercise(userId: userUID!, obj: exercise).then((value) {
      Get.find<UserController>(tag: "user").user?.myExercises?.add(exercise);
      Get.snackbar(
        "Sucesso",
        "Salvo com sucesso!",
        backgroundColor: Colors.green,
      );
    }).catchError((error) {
      print(error);
      Get.snackbar("Sucesso", "Salvo com sucesso!", backgroundColor: Colors.green, animationDuration: const Duration(milliseconds: 30));
    });
  }

  getExercisesForDay(DateTime day) {
    var schedulated = List<UserExercises>.empty(growable: true);
    if (Get.find<UserController>(tag: 'user').user!.myExercises != null) {
      Get.find<UserController>(tag: 'user').user!.myExercises?.forEach((item) {
        if (item.dateMarked != null && item.dateMarked == day) {
          print(item.toMap());
          schedulated.add(item);
        }
      });
    }
    myExercises.assignAll(schedulated);
  }

  List<UserExercises> getExercisesForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = _daysInRange(start, end);

    return [
      for (final d in days) ...getExercisesForDay(d),
    ];
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  removeExercise(UserExercises exercise) {
    Get.find<UserController>(tag: 'user').user!.myExercises?.remove(exercise);
    _database.deleteUserExercise(exercise, Get.find<UserController>(tag: 'user').user!.uid!);
  }

  void updateUserExercise(UserExercises marked) {
    marked.doneIn = DateTime.now();
    _database.updateUserExercise(marked, Get.find<UserController>(tag: 'user').user!.uid!);
  }
}
