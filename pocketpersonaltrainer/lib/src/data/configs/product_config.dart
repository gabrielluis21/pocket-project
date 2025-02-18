// config/product_config.dart
class ProductConfig {
  // IDs de Produtos
  static const String premiumAccessID = 'premium_access';

  // Recursos Premium
  static final Map<String, bool> premiumFeatures = {
    'removeAds': true,
    'gymLocator': true,
    'advancedPlanner': true,
    'detailedReports': true,
  };
}
