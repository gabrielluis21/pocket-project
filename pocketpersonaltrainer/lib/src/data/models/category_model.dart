import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String? icon;
  Map<String, dynamic>? title;

  CategoryModel({this.id, this.icon, this.title});

  factory CategoryModel.fromDocumentSnapshot(
          DocumentSnapshot<Map<String, dynamic>> doc) =>
      CategoryModel(
          id: doc.id, icon: doc.data()!['icon'], title: doc.data()!['title']);

  Map<String, dynamic> toMap() {
    return {"id": id, "icon": icon, "title": title};
  }
}
