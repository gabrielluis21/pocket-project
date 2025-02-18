import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/purchase_controller.dart';

mixin PremiumFeaturesMixin<T extends StatefulWidget> on State<T> {
  final PurchaseController _purchaseController = Get.find<PurchaseController>();

  @override
  void initState() {
    super.initState();
    _initializePremiumFeatures();
  }

  void _initializePremiumFeatures() async {
    // Verificar e atualizar o status premium ao iniciar
    _purchaseController.loadPremiumStatus();

    if (_purchaseController.isPremium.isTrue) {
      _unlockPremiumFeatures();
    } else {
      _lockPremiumFeatures();
    }

    // Listener para mudanças no status premium
    _purchaseController.isPremium.listen((isPremium) {
      if (isPremium) {
        _unlockPremiumFeatures();
      } else {
        _lockPremiumFeatures();
      }
    });
  }

  void _unlockPremiumFeatures() {
    // Liberar os recursos comprados
    print("Premium features unlocked: Removing ads, enabling notifications, etc.");
  }

  void _lockPremiumFeatures() {
    // Bloquear recursos para não-premium
    print("Premium features locked: Ads shown, notifications limited, etc.");
  }

  // Expor a controller para manipulação manual, se necessário
  PurchaseController get purchaseController => _purchaseController;
}
