import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';

class ExerciseService {
  final _database = FbDatabase();

  Stream<List<ExerciseModel>> loadAll(id) {
    return _database.getAllExserciseByCategory(id);
  }
}
