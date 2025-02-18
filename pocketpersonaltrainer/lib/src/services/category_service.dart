import 'package:pocketpersonaltrainer/src/data/models/category_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class CategoryService {
  final _database = FbDatabase.instance;

  Stream<List<CategoryModel>> loadAll() {
    return _database.getAllCategories();
  }
}
