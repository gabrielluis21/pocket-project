import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_model.dart';

class GymMap extends StatelessWidget {
  const GymMap({
    super.key,
    required this.longitude,
    required this.latitude,
    this.currentUser,
  });
  final double longitude;
  final double latitude;
  final UserModel? currentUser;

  //final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 350.0,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(this.latitude, this.longitude),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.br.silva.pocketpersonaltrainer',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 50.0,
                point: LatLng(this.latitude, this.longitude),
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Theme.of(context).primaryColor,
                    iconSize: 25.0,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
