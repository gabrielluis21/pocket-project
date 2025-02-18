import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/gym_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_from_maps.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_model.dart';
import 'package:pocketpersonaltrainer/src/mixings/purchase_mixin.dart';
import 'package:pocketpersonaltrainer/src/ui/gyms/gym_page.dart';
import 'package:pocketpersonaltrainer/src/ui/gyms/widgets/premium_maps.dart';
import 'package:pocketpersonaltrainer/src/utils/calculators.dart';
import 'package:pocketpersonaltrainer/src/widgets/inputs/autocomplete_text_input.dart';

class GymsView extends StatefulWidget {
  const GymsView({
    super.key,
    required this.controller,
  });

  final GymController controller;

  @override
  State<GymsView> createState() => _GymsViewState();
}

class _GymsViewState extends State<GymsView> with PremiumFeaturesMixin {
  late final List<String> items;
  List<String> filteredItems = [];
  List<GymModel> nearByGyms = List<GymModel>.empty(growable: true);
  List<Gym> nearByGymsPremium = List<Gym>.empty(growable: true);
  bool viewOnMap = false;
  String searchText = '';
  late double latitude, longitude;

  @override
  void initState() {
    latitude = Get.find<UserController>(tag: 'user').user?.location!['latitude'];
    longitude = Get.find<UserController>(tag: 'user').user?.location!['longitude'];

    if (purchaseController.isPremium.value == true) {
      widget.controller.loadAllForPremiumUsers();
      items = widget.controller.userPremiumGyms.map((e) => e.name!).toList();
    } else {
      widget.controller.loadAll();
      items = widget.controller.gyms.map((e) => e.name!).toList();
    }
    super.initState();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Widget _buildAllNearByGymsOnMapView() {
    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                latitude,
                longitude,
              ),
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
                    child: Icon(Icons.person_pin, color: Theme.of(context).primaryColor),
                    point: LatLng(latitude, longitude),
                  ),
                  ..._showNearByGymsMarkers(context),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoCompleteTextInput(
            items: items,
            labelText: "Buscar academias",
            filtered: _filterItems,
            onChanged: (value) => _filterItems(value),
            onChangedViewMode: (value) => setState(() => viewOnMap = value),
          ),
        ),
      ],
    );
  }

  List<Marker> _showNearByGymsMarkers(BuildContext context) {
    if (filteredItems.isEmpty) {
      for (var establishment in widget.controller.gyms) {
        double distance = Calc.calculateDistance(
          latitude,
          longitude,
          establishment.location!['latitude'],
          establishment.location!['latitude'],
        );
        if (distance <= 5) {
          nearByGyms.add(establishment);
        }
      }
      return nearByGyms.map((gym) {
        return Marker(
          width: 40.0,
          height: 50.0,
          point: LatLng(
            gym.location?['latitude'],
            gym.location?['longitude'],
          ),
          child: Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Theme.of(context).primaryColor,
              iconSize: 25.0,
              onPressed: () {},
            ),
          ),
        );
      }).toList();
    } else {
      //_filterItems(selected!);
      for (var establishment in widget.controller.gyms.where((gym) => filteredItems.contains(gym.name!)).toList()) {
        double distance = Calc.calculateDistance(
          latitude,
          longitude,
          establishment.location!['latitude'],
          establishment.location!['latitude'],
        );
        if (distance <= 5) {
          nearByGyms.add(establishment);
        }
      }
      return nearByGyms.map((gym) {
        return Marker(
          width: 40.0,
          height: 50.0,
          point: LatLng(
            gym.location?['latitude'],
            gym.location?['longitude'],
          ),
          child: Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Theme.of(context).primaryColor,
              iconSize: 25.0,
              onPressed: () {},
            ),
          ),
        );
      }).toList();
    }
  }

  Widget _buildGymsListView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoCompleteTextInput(
            items: items,
            labelText: "Buscar academia",
            filtered: _filterItems,
            onChanged: (value) => _filterItems(value),
            onChangedViewMode: (value) => setState(() => viewOnMap = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              if (filteredItems.isEmpty) {
                return Center(
                  child: Text(
                    "Faça uma pesquisa para exibir os itens",
                    style: AppTextTheme.theme.bodyLarge?.copyWith(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                );
              }
              var gym = widget.controller.gyms.firstWhere((element) => element.name != null && element.name == filteredItems[index]);
              return GestureDetector(
                child: Card(
                  shadowColor: Colors.transparent,
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: (gym.images != null && gym.images!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: gym.images!.first,
                                fit: BoxFit.cover,
                                height: 100.0,
                                errorWidget: (context, url, error) => Image.asset("assets/images/empty.png"),
                              )
                            : Image.asset("assets/images/empty.png"),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                gym.name ?? "",
                                style: AppTextTheme.theme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GymPage(
                        academia: gym,
                        language: '',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (purchaseController.isPremium.value == true) {
      return PremiumMap(
        items: items,
        controller: widget.controller,
        searchText: searchText,
        lat: latitude,
        lng: longitude,
      );
    }
    return viewOnMap == true ? _buildAllNearByGymsOnMapView() : _buildGymsListView();
  }
}
