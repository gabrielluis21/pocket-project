import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/data/models/gym_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class GymController extends GetxController {
  final _database = FbDatabase();
  final RxList<GymModel> gyms = <GymModel>[].obs;

  void loadAll() {
    gyms.bindStream(_database.getAllGym());
  }

  List<GymModel> getByLocation(double lat, double long) {
    var searched = List<GymModel>.empty(growable: true);
    this.gyms.forEach(
      (element) {
        if (element.location?['latitude'] >= lat && element.location?['longitude'] <= long) {
          searched.add(element);
        }
      },
    );

    return searched;
  }

  List<GymModel> search(String text) {
    var filteredList = this.gyms.where((item) => item.name!.toLowerCase().contains(text.toLowerCase())).toList();
    return filteredList;
  }
}
