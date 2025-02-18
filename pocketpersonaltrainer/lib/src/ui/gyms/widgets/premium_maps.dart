import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/gym_controller.dart';
import 'package:pocketpersonaltrainer/src/widgets/inputs/autocomplete_text_input.dart';

class PremiumMap extends StatefulWidget {
  const PremiumMap({super.key, required this.items, required this.controller, required this.searchText, required this.lat, required this.lng});

  final String searchText;
  final GymController controller;
  final double lat;
  final double lng;
  final List<String> items;

  @override
  _PremiumMapState createState() => _PremiumMapState();
}

class _PremiumMapState extends State<PremiumMap> {
  late GoogleMapController controller;
  List<String> filteredItems = [];
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  /* Future<void> searchAndDisplayGym() async {
    final gym = await widget.controller.searchGymForPremiumUsers(
      widget.searchText,
    );

    if (gym != null) {
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(gym.placeId!),
            position: LatLng(
              gym.geometry!.location!.lat!,
              gym.geometry!.location!.lng!,
            ),
            infoWindow: InfoWindow(
              title: gym.name,
              snippet: gym.vicinity,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        // Centraliza o mapa na localização da academia
        controller.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              gym.geometry!.location!.lat!,
              gym.geometry!.location!.lng!,
            ),
          ),
        );
      });
    }
  } */

  void moveCamera(LatLng position) {
    controller.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  loadMarker() {
    setState(() {
      markers.addAll(
        widget.controller.userPremiumGyms.map((gym) {
          return Marker(
            markerId: MarkerId('gym_${gym.placeId!}'),
            position: LatLng(
              gym.geometry!.location!.lat!,
              gym.geometry!.location!.lng!,
            ),
            infoWindow: InfoWindow(
              title: gym.name,
              snippet: gym.vicinity,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );
        }).toSet(),
      );
      markers = markers.where((marker) {
        // Adicione lógica para identificar apenas academias, se necessário
        return marker.markerId.value.startsWith("gym_");
      }).toSet();
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
    _gymSelected(query);
  }

  void _gymSelected(String searchedItem) async {
    widget.controller.userPremiumGyms
        .where(
      (gym) => gym.name!.toLowerCase().contains(searchedItem.toLowerCase()),
    )
        .forEach((gym) {
      setState(() {
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId('gym_${gym.placeId!}'),
          position: LatLng(
            gym.geometry!.location!.lat!,
            gym.geometry!.location!.lng!,
          ),
          infoWindow: InfoWindow(
            title: gym.name,
            snippet: gym.vicinity,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoCompleteTextInput(
          labelText: "buscar academia",
          canChangeViewMode: false,
          items: widget.items,
          filtered: _filterItems,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _filterItems(value);
            } else {
              setState(() {
                markers.clear();
                loadMarker();
              });
            }
          },
          onChangedViewMode: (value) {},
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: true,
            myLocationEnabled: true, // Mostra a localização atual do usuário
            myLocationButtonEnabled: true, // Botão de localização
            mapType: MapType.normal, // Tipo de mapa
            zoomGesturesEnabled: true, // Habilita o gesto de zoom
            scrollGesturesEnabled: true, // Habilita o gesto de rolar
            rotateGesturesEnabled: true, // Habilita o gesto de rotação
            tiltGesturesEnabled: true, // Habilita o gesto de inclinação
            onMapCreated: (mapController) {
              loadMarker();
              controller = mapController;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lng), // Localização inicial
              zoom: 13.5,
            ),
            markers: markers,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    color: colorFromHueToRGBO(BitmapDescriptor.hueBlue),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Academias")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
