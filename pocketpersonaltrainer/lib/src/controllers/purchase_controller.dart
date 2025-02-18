// controllers/premium_controller.dart
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pocketpersonaltrainer/src/data/configs/product_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseController extends GetxController {
  // Estado do acesso premium
  var isPremium = true.obs;

  // Lista de produtos disponíveis
  var availableProducts = <ProductDetails>[].obs;

  // Inicialize o In-App Purchase
  /* @override
  void onInit() {
    super.onInit();
    _loadProducts();
  } */

  // Carregar produtos da loja
  void _loadProducts() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();

    if (isAvailable) {
      // Obtém os IDs de produtos da configuração centralizada
      final Set<String> productIds = {ProductConfig.premiumAccessID};

      // Consulta os produtos disponíveis na Play Store
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(productIds);

      if (response.error != null) {
        print('Erro ao carregar produtos: ${response.error}');
        return;
      }

      if (response.productDetails.isNotEmpty) {
        // Atualiza a lista de produtos disponíveis
        availableProducts.value = response.productDetails;

        // Debug: Exibe informações sobre os produtos
        for (var product in response.productDetails) {
          print('Produto disponível: ${product.id}, ${product.title}, ${product.price}');
        }
      } else {
        print('Nenhum produto encontrado.');
      }
    } else {
      print('Compras no aplicativo não estão disponíveis.');
    }
  }

  // Comprar produto
  Future<void> buyPremium() async {
    /* final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    _savePremiumStatus(true); */
    isPremium.value = true;
    _savePremiumStatus(isPremium.value);
  }

  // Gerenciar mudanças na compra
  void handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.productID == ProductConfig.premiumAccessID && purchase.status == PurchaseStatus.purchased) {
        isPremium.value = true;
        _savePremiumStatus(true); // Salva localmente
      }
    }
  }

  // Salvar o estado premium localmente
  void _savePremiumStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPremium', status);
  }

  // Carregar estado premium salvo
  loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isPremium'));
    isPremium.value = prefs.getBool('isPremium') ?? false;
  }

  bool isFeatureAvailable(String featureKey) {
    if (ProductConfig.premiumFeatures[featureKey] == true) {
      return isPremium.value;
    }
    return true; // Recursos gratuitos sempre disponíveis
  }
}
