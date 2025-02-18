// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketpersonaltrainer/src/data/models/category_model.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym_model.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_model.dart';

class FbDatabase {
  final _database = FirebaseFirestore.instance;
  FirebaseFirestore get database => _database;

  static FbDatabase get instance => FbDatabase();

  Stream<List<GymModel>> getAllGym() {
    return _database.collection("academia").snapshots().map((value) {
      return List<GymModel>.from(
        value.docs.map(
          (doc) => GymModel.fromDocumentSnapshot(doc),
        ),
      );
    });
  }

  getAllUser() async {
    try {
      var all = List<UserModel>.empty(growable: true);
      _database.collection("user").snapshots().map((event) {
        var userExercises = List<UserExercises>.empty(growable: true);
        for (var element in event.docs) {
          element.reference.collection("myExercises").snapshots().map((data) {
            for (var dados in data.docs) {
              userExercises.add(UserExercises.fromDocumentSnapshot(dados));
            }
          });
          all.add(UserModel.fromDocumentSnapshot(doc: element, myExercise: userExercises));
        }
      });
      return all;
    } catch (e) {
      print(e);
      return e;
    }
  }

  getUserId(id) async {
    try {
      final result = await _database.collection("users").doc(id).get();
      final currentUser = UserModel.fromDocumentSnapshot(doc: result);

      final myExerciseDoc = await _database.collection("users").doc(id).collection("myExercises").get();
      final myExercises = List<UserExercises>.empty(growable: true);
      if (myExerciseDoc.size > 0) {
        for (var element in myExerciseDoc.docs) {
          myExercises.add(UserExercises.fromDocumentSnapshot(element));
        }
      }
      currentUser.myExercises = myExercises;
      return currentUser;
    } catch (e) {
      print(e);
      return e;
    }
  }

  deleteUser(id) async {
    try {
      await _database.collection("users").doc(id).delete();
      return true;
    } catch (e) {
      print(e);
      return e;
    }
  }

  editUser(id, obj) async {
    try {
      await _database.collection("users").doc(id).update(obj.toMap());
      return true;
    } catch (e) {
      print(e);
      return e;
    }
  }

  addUser(obj) async {
    try {
      await _database.collection("users").doc(obj.uid).set(obj.toMap());
      return true;
    } catch (e) {
      print(e);
      return e;
    }
  }

  getAllExserciseByCategory(categoryId) {
    try {
      print(categoryId);
      return _database.collection("exercicios").doc(categoryId).collection("itens").snapshots().map((event) {
        var all = List<ExerciseModel>.empty(growable: true);
        for (var element in event.docs) {
          var exercise = ExerciseModel.fromDocumentSnapshot(element);
          all.add(exercise);
        }
        return all;
      });
    } catch (e) {
      print(e);
      return e;
    }
  }

  getAllCategories() {
    try {
      return _database.collection("exercicios").snapshots().map((event) {
        var all = List<CategoryModel>.empty(growable: true);
        for (var element in event.docs) {
          all.add(CategoryModel.fromDocumentSnapshot(element));
        }
        return all;
      });
    } catch (e) {
      print(e);
      return e;
    }
  }

  Stream<List<UserExercises>> getAllUserExercises(userId) {
    return _database.collection("users").doc(userId).collection("myExercises").snapshots().map((event) {
      var all = List<UserExercises>.empty(growable: true);
      if (event.size > 0) {
        for (var element in event.docs) {
          all.add(UserExercises.fromDocumentSnapshot(element));
        }
      }
      return all;
    });
  }

  Future<dynamic> addUserExercise({required String userId, required UserExercises obj}) async {
    try {
      await _database.collection("users").doc(userId).collection("myExercises").add(obj.toMap());
    } catch (e) {
      print(e);
      return e;
    }
  }

  deleteUserExercise(UserExercises obj, String userId) async {
    try {
      await _database.collection("users").doc(userId).collection("myExercises").doc(obj.id).delete();
    } catch (e) {
      print(e);
      return e;
    }
  }
}
