/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketpersonaltrainer/src/controllers/fbdatabase_controller.dart'; */
import 'package:pocketpersonaltrainer/src/controllers/purchase_controller.dart';
import 'package:pocketpersonaltrainer/src/services/notefication_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pocketpersonaltrainer/src/app/app.dart';
import 'package:pocketpersonaltrainer/src/controllers/settings_controller.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final purchaseController = Get.put(PurchaseController());
  final notificationService = Get.put(NotificationServices());
  final settingsController = Get.put(SettingsController());

  purchaseController.buyPremium();
  settingsController.handlePermissions();
  await notificationService.configuration();
  await notificationService.initializeIsolateReceivePort();
  await settingsController.loadTheme();
  await MobileAds.instance.initialize();
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    MyApp(),
  );
}
