import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_from_maps.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym/gym_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';
import 'package:pocketpersonaltrainer/src/services/gps_service.dart';

class GymController extends GetxController {
  final _database = FbDatabase();
  final _gpsServices = GpsService();
  final RxList<GymModel> gyms = <GymModel>[].obs;
  final RxList<Gym> userPremiumGyms = <Gym>[].obs;

  void loadAll() {
    gyms.bindStream(_database.getAllGym());
  }

  List<GymModel> getByLocation(double lat, double long) {
    var searched = List<GymModel>.empty(growable: true);
    for (var element in gyms) {
      if (element.location?['latitude'] >= lat && element.location?['longitude'] <= long) {
        searched.add(element);
      }
    }

    return searched;
  }

  List<GymModel> search(String text) {
    var filteredList = gyms.where((item) => item.name!.toLowerCase().contains(text.toLowerCase())).toList();
    return filteredList;
  }

  Future<Gym?> searchGymForPremiumUsers(String gymName) async {
    try {
      var located = await _gpsServices.getPlaceByGeoCodeFromAPI(
        input: gymName,
        lat: Get.find(tag: 'user').user?.location?['latitude'] ?? 0.0,
        long: Get.find(tag: 'user').user?.location?['longitude'] ?? 0.0,
      );

      return Gym.fromJson(located['result']);
    } catch (e) {
      return null;
    }
  }

  loadAllForPremiumUsers() async {
    var all = await _gpsServices.getAllPlacesByGeoCodeFromAPI(
      latitude: Get.find<UserController>(tag: 'user').user?.location?['latitude'] ?? 0.0,
      longitude: Get.find<UserController>(tag: 'user').user?.location?['longitude'] ?? 0.0,
    );
    userPremiumGyms.addAll(all);
  }
}
