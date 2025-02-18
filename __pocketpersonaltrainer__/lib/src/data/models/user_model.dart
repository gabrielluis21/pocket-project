import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.address,
    this.city,
    this.location,
    this.photoUrl,
    this.password,
    this.hasPremium = false,
    this.acceptedTerms,
    //this.myExercises,
  });

  String? uid;
  String? name;
  String? email;
  String? password;
  String? address;
  String? photoUrl;
  String? city;
  bool? hasPremium;
  bool? acceptedTerms;
  Map<String, dynamic>? location;
  //List<UserExercises>? myExercises;
  List<UserExercises>? myExercises;

  factory UserModel.fromDocumentSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    List<UserExercises>? myExercise,
  }) =>
      UserModel(
        uid: doc.id,
        name: doc.data()!["name"],
        email: doc.data()!["email"],
        address: doc.data()!["address"],
        city: doc.data()!["city"],
        photoUrl: doc.data()!["photoUrl"],
        location: doc.data()!["location"],
        hasPremium: doc.data()!["hasPremium"],
        acceptedTerms: doc.data()!["acceptedTerms"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "address": address,
        "photoUrl": photoUrl,
        "city": city,
        "location": location,
        "hasPremium": hasPremium,
        'acceptedTerms': acceptedTerms,
      };
}
