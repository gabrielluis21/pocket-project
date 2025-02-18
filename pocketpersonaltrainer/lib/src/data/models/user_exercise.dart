import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';

class UserExercises {
  String? id;

  String? categoryExercise;
  String? exerciseId;
  int? quantity;
  DateTime? dateMarked;
  DateTime? doneIn;
  bool? isDone = false;

  ExerciseModel? exerciseData;

  UserExercises({
    this.id,
    this.categoryExercise,
    this.exerciseId,
    this.quantity,
    this.dateMarked,
    this.doneIn,
    this.isDone,
    this.exerciseData,
  });

  factory UserExercises.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => UserExercises(
        id: doc.id,
        categoryExercise: doc.data()!["category"],
        exerciseId: doc.data()!["exerciseId"],
        quantity: doc.data()!["quantity"],
        isDone: doc.data()!["isDone"],
        dateMarked: DateTime.tryParse(doc.data()!["date"]),
        doneIn: doc.data()!["doneIn"] != null ? DateTime.tryParse(doc.data()!["doneIn"]) : null,
        exerciseData: ExerciseModel.fromMap(doc.data()!["exercise"]),
      );

  Map<String, dynamic> toMap() {
    return {
      "category": categoryExercise,
      "exerciseId": exerciseId,
      "quantity": quantity,
      "isDone": isDone,
      "date": dateMarked.toString(),
      "doneIn": doneIn.toString(),
      "exercise": exerciseData?.toMap(),
    };
  }
}
