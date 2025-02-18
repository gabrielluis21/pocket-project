//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/binding/initial.binding.dart';
import 'package:pocketpersonaltrainer/src/controllers/settings_controller.dart';
import 'package:pocketpersonaltrainer/src/mixings/health_hint_mixing.dart';
import 'package:pocketpersonaltrainer/src/mixings/purchase_mixin.dart';
import 'package:pocketpersonaltrainer/src/services/notefication_services.dart';
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

import 'app_theme.dart';
import 'app_pages.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with PremiumFeaturesMixin, HealthHintsMixin {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    Get.find<NotificationServices>().startListeningNotificationEvents();
    super.initState();
    carregarConfiguracoes();
  }

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
        ],
        initialBinding: InitialBinding(),
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
        onGenerateRoute: (RouteSettings routeSettings) {
          //ReceivedAction receivedAction;
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case Routes.HOME:
                  return const HomePage();
                case Routes.LOGIN:
                  return const LoginPage();
                case Routes.CADASTRO:
                  return const SignUpPage();
                case Routes.CATEGORIA:
                  return const CategoryPage();
                case Routes.SETTINGS:
                  return const SettingsPage();
                case Routes.CATEGORYEXERCISE:
                  return const CategoryExercisePage(
                    language: '',
                    id: '',
                    categoryTitle: '',
                  );
                case Routes.TODO:
                  return ToDoListScreen();
                case Routes.PREMIUM:
                  return PremiumView();
                case Routes.GPS_SETTINGS:
                  return GpsSettings();
                default:
                  return const SplashPage();
              }
            },
          );
        },
        theme: AppTheme.appLightTheme,
        darkTheme: AppTheme.appDarkTheme,
        themeMode: Get.find<SettingsController>().themeMode,
        getPages: AppPages.pages,
        defaultTransition: Transition.fade,
        home: const SplashPage(),
      );
    });
  }
}
