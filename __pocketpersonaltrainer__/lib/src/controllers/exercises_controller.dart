import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/services/exercise_service.dart';

class ExerciseController extends GetxController {
  final ExerciseService repository;
  ExerciseController(this.repository);

  final RxList<ExerciseModel> allExercises = RxList<ExerciseModel>();

  void loadAll(String id) {
    allExercises.bindStream(repository.loadAll(id));
  }
}
