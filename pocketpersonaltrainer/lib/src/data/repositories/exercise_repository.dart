import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class ExerciseRepository {
  final FbDatabase api;

  ExerciseRepository(this.api);

  getAll(categoryId) {
    return api.getAllExserciseByCategory(categoryId);
  }
}
