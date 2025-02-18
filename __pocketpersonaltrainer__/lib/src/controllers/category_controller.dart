import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/data/models/category_model.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService repository;
  CategoryController(this.repository);

  final RxList<CategoryModel> categories = RxList<CategoryModel>();

  @override
  void onReady() {
    loadAll();
    super.onReady();
  }

  void loadAll() {
    categories.bindStream(repository.loadAll());
  }
}
