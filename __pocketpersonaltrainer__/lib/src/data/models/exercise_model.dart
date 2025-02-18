import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  ExerciseModel({this.category, this.id, this.name, this.description, this.foco, this.images});

  String? category;

  String? id;

  Map<String, dynamic>? name;
  Map<String, dynamic>? description;
  Map<String, dynamic>? foco;

  Map<String, dynamic>? images;

  factory ExerciseModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => ExerciseModel(
        id: doc.id,
        name: doc.data()!["name"],
        description: doc.data()!["description"],
        foco: doc.data()!["foco"],
        images: doc.data()!["images"],
      );

  factory ExerciseModel.fromMap(Map<String, dynamic> exercise) => ExerciseModel(
        id: exercise["id"],
        name: exercise["name"],
        description: exercise["description"],
        foco: exercise["foco"],
        images: exercise["images"],
      );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "category": category,
      "name": name,
      "description": description,
      "foco": foco,
    };
  }

  Map<String, dynamic> toResumeMap() {
    return {"name": name, "description": description};
  }
}
