import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_from_maps.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class GpsService {
  final apiKey = "AIzaSyCRQ0f8EsZJ0WXPNu80O0OhwlTJXz3P7IM";

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

  Future<Map<String, dynamic>> getPlaceByGeoCodeFromAPI({
    required String input,
    required double lat,
    required double long,
    int? radius = 5000,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?query=$input&location=$lat,$long&radius=${radius ?? 5000}&type=gym&key=$apiKey"),
      );

      return response.statusCode == 200 ? json.decode(response.body) : {};
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<List<Gym>> getAllPlacesByGeoCodeFromAPI({
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    List<Gym> allGyms = [];
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String nextPageToken = '';

    do {
      final response = await http.get(
        Uri.parse(
          '$baseUrl?location=$latitude,$longitude&radius=$radius&type=gym&key=$apiKey'
          '${nextPageToken.isNotEmpty ? '&pagetoken=$nextPageToken' : ''}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          allGyms.addAll(List<Gym>.from(data['results'].map((e) => Gym.fromJson(e))));
        }

        // Atualiza o `next_page_token`, se existir.
        nextPageToken = data['next_page_token'] ?? '';
        if (nextPageToken.isNotEmpty) {
          // Aguarda alguns segundos para ativar o token.
          await Future.delayed(Duration(seconds: 2));
        }
      } else {
        throw Exception('Erro ao buscar academias: ${response.reasonPhrase}');
      }
    } while (nextPageToken.isNotEmpty);

    return allGyms;
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
