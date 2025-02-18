import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/binding/initial.binding.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-in/sign_in_view.dart';
import 'package:pocketpersonaltrainer/src/ui/authentication/sign-up/sign_up_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_exercise_view.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_view.dart';
import 'package:pocketpersonaltrainer/src/ui/home/home_view.dart';
import 'package:pocketpersonaltrainer/src/ui/settings/settings_view.dart';
import 'package:pocketpersonaltrainer/src/ui/to-do/todo_list_view.dart';

import '../controllers/settings_controller.dart';
import '../ui/splash/splash_view.dart';

import 'app_theme.dart';
import 'app_pages.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    GetNavigator;
    return Obx(() {
      return GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialBinding: InitialBinding(),
        supportedLocales: const [
          Locale('pt', 'BR'), // Portugues, Brazil code
          Locale('en', ''), // English, no country code
          Locale('es', 'ES'), // English, no country code
          Locale('fr', 'FR'), // English, no country code
          Locale('ch', 'ZH'), // English, no country code
          Locale('de', 'DE'), // English, no country code
        ],
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
        onGenerateRoute: (RouteSettings routeSettings) {
          ReceivedAction? receivedAction;
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case Routes.HOME:
                  return HomePage();
                case Routes.LOGIN:
                  return LoginPage();
                case Routes.CADASTRO:
                  return const SignUpPage();
                case Routes.CATEGORIA:
                  return const CategoryPage();
                case Routes.SETTINGS:
                  return SettingsPage();
                case Routes.CATEGORYEXERCISE:
                  return CategoryExercisePage(
                    language: '',
                    id: '',
                    categoryTitle: '',
                  );
                case Routes.TODO:
                  return ToDoListScreen();
                default:
                  return SplashPage();
              }
            },
          );
        },
        theme: AppTheme.appLightTheme,
        darkTheme: AppTheme.appDarkTheme,
        themeMode: Get.find<SettingsController>().themeMode,
        getPages: AppPages.pages,
        defaultTransition: Transition.fade,
        home: SplashPage(),
      );
    });
  }
}
