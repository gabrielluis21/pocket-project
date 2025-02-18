import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-up/sign_up_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_exercise_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_view.dart';
import 'package:pocketpersonaltrainer/src/ui/to-do/todo_list_view.dart';

import '../ui/authentication/sign-in/sign_in_view.dart';
import '../ui/home/home_view.dart';
import '../ui/splash/splash_view.dart';
import '../ui/settings/settings_view.dart';
part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsPage(),
    ),
    GetPage(name: Routes.CATEGORYEXERCISE, page: () => CategoryExercisePage(language: "", categoryTitle: "", id: "")),
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.CADASTRO, page: () => const SignUpPage()),
    GetPage(name: Routes.CATEGORIA, page: () => const CategoryPage()),
    GetPage(
      name: Routes.TODO,
      page: () => ToDoListScreen(),
    ),
  ];
}
