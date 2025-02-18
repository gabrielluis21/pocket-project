import 'package:cloud_firestore/cloud_firestore.dart';

class GymModel {
  GymModel({this.uid, this.name, this.address, this.city, this.location, this.state, this.images, this.phones});

  String? uid;
  String? name;
  String? address;
  String? state;
  String? city;
  List<String>? phones;
  List<dynamic>? images;
  Map<String, dynamic>? location;

  factory GymModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => GymModel(
        uid: doc.id,
        name: doc.data()!["name"],
        address: doc.data()!["address"],
        city: doc.data()!["city"],
        location: doc.data()!["location"],
        state: doc.data()!["state"],
        images: doc.data()!["images"] == null ? [] : List.from(doc.data()!["images"].map((e) => e)),
        phones: doc.data()!["phones"] == null ? [] : List.from(doc.data()!["phones"].map((e) => e)),
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "address": address,
        "state": state,
        "city": city,
        "location": location,
      };
}
