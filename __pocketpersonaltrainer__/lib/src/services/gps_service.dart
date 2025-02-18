import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pocketpersonaltrainer/src/data/models/gym_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class GpsService {
  static Future<Position?> getLocation() async {
    Position? current;
    try {
      var gpsIsPermitted = await Geolocator.checkPermission();
      if (gpsIsPermitted == LocationPermission.always || gpsIsPermitted == LocationPermission.whileInUse) {
        current = await Geolocator.getCurrentPosition();
      }

      return current;
    } catch (e) {
      print(e);
      return current;
    }
  }

  static Future<Address> getAddressByGeoCordinates(double? longitude, double? latitude) async {
    var address;
    try {
      address = await GeoCode().reverseGeocoding(latitude: latitude!, longitude: longitude!);
      print("Endereco: $address");
    } on Exception catch (e) {
      print(e);
    } finally {
      return address;
    }
  }

  Future<Map<String, dynamic>> getPlacesByGeoCodeFromAPI({
    required String input,
    required double lat,
    required double long,
    int? radius,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("https://map-places.p.rapidapi.com/queryautocomplete/json?input=$input&radius=${radius ?? 5000}&location=${lat},${long}"),
        headers: {
          "x-rapidapi-key": "fa7bf02584msh53ca5f86407711fp1b0b75jsn3d4d06547307",
          "x-rapidapi-host": "map-places.p.rapidapi.com",
        },
      );

      return response.statusCode == 200 ? json.decode(response.body) : {};
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<void> setPlaceByGeoCodeOnFirestore({
    required GymModel academia,
    required double lat,
    required double long,
    int? radius,
  }) async {
    var existis = await FbDatabase.instance.database.collection("locals").get();
    if (existis.docs.isEmpty) {
      var position = GeoFirePoint(GeoPoint(lat, long));
      await FbDatabase.instance.database.collection("locals").doc("places").set(
        {
          "academia": academia.toMap(),
          "position": position.data,
        },
      );
    }
  }

  Future<void> setPlacesByGeoCodeOnFirestore({
    required List<GymModel> academias,
    required double lat,
    required double long,
    int? radius,
  }) async {
    var existis = await FbDatabase.instance.database.collection("locals").get();
    if (existis.docs.isEmpty) {
      var position = GeoFirePoint(GeoPoint(lat, long));
      for (var academia in academias) {
        await FbDatabase.instance.database.collection("locals").doc(academia.uid).set(
          {
            "academia": academia.toMap(),
            "position": position.data,
          },
        );
      }
    }
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getPlacesByGeoCodeFromFirestore({
    required double lat,
    required double long,
    int? radius,
  }) {
    var collectionReference = FbDatabase.instance.database.collection('locals');
    var center = GeoFirePoint(GeoPoint(lat, long));
    ;
    double radius = 5;
    String field = 'position';

    return GeoCollectionReference(collectionReference).subscribeWithin(
      center: center,
      radiusInKm: radius,
      field: field,
      geopointFrom: (data) {
        var geo = data[field]['geopoint'] as GeoPoint;
        print('latitude: ${geo.latitude} | longitude: ${geo.longitude}');
        return geo;
      },
      strictMode: true,
    );
  }
}
