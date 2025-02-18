import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/category_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/gym_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/purchase_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/settings_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_controller.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/provider/fbdatabase.dart';
import 'package:pocketpersonaltrainer/src/services/auth_services.dart';
import 'package:pocketpersonaltrainer/src/services/category_service.dart';
import 'package:pocketpersonaltrainer/src/services/exercise_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsController>(
      SettingsController(),
      tag: 'settings',
      permanent: true,
    );
    Get.put<AuthController>(
      AuthController(
        AuthService(
          database: FbDatabase.instance,
        ),
      ),
      permanent: true,
      tag: "auth",
    );
    Get.put<CategoryController>(
      CategoryController(CategoryService()),
      permanent: true,
      tag: 'categories',
    );
    Get.put<ExerciseController>(
      ExerciseController(
        ExerciseService(),
      ),
      permanent: true,
      tag: "exercise",
    );
    Get.put<GymController>(
      GymController(),
      permanent: true,
      tag: 'gyms',
    );
    Get.put<UserController>(
      UserController(),
      permanent: true,
      tag: 'user',
    );
    Get.put<UserExercisesController>(
      UserExercisesController(),
      permanent: true,
      tag: 'user_exercises',
    );
    Get.put<PurchaseController>(
      PurchaseController(),
      permanent: true,
      tag: 'purchase',
    );
  }
}
