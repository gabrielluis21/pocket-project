import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-in/sign_in_view.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-up/sign_up_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_exercise_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_view.dart';
import 'package:pocketpersonaltrainer/src/ui/gps/gps_settings.dart';
import 'package:pocketpersonaltrainer/src/ui/home/home_view.dart';
import 'package:pocketpersonaltrainer/src/ui/premium/premium_view.dart';
import 'package:pocketpersonaltrainer/src/ui/settings/settings_view.dart';
import 'package:pocketpersonaltrainer/src/ui/splash/splash_view.dart';
import 'package:pocketpersonaltrainer/src/ui/to-do/todo_list_view.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsPage(),
    ),
    GetPage(name: Routes.CATEGORYEXERCISE, page: () => const CategoryExercisePage(language: "", categoryTitle: "", id: "")),
    GetPage(name: Routes.LOGIN, page: () => const LoginPage()),
    GetPage(name: Routes.PREMIUM, page: () => PremiumView()),
    GetPage(name: Routes.GPS_SETTINGS, page: () => GpsSettings()),
    GetPage(name: Routes.CADASTRO, page: () => const SignUpPage()),
    GetPage(name: Routes.CATEGORIA, page: () => const CategoryPage()),
    GetPage(
      name: Routes.TODO,
      page: () => ToDoListScreen(),
    ),
  ];
}
