import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class CategoryRepository {
  final FbDatabase api;

  CategoryRepository(this.api);

  getAll() {
    return api.getAllCategories();
  }
}
