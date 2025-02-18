import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FbDatabaseController extends GetxController {
  final FirebaseFirestore _database;
  late Box _localBox;

  FbDatabaseController(this._database);

  // Status do carregamento (para UI reativa)
  var isLoading = false.obs;

  // Inicializar o banco local e outras configurações
  @override
  Future<void> onInit() async {
    super.onInit();
    _localBox = await Hive.openBox('localData');
  }

  // Fetch Offline-First com GetX
  Future<List<Map<String, dynamic>>> fetchData({required String collectionPath, bool forceOnline = false}) async {
    final cacheKey = collectionPath;
    isLoading.value = true; // Ativa o indicador de carregamento

    try {
      // Verificar cache local
      if (!forceOnline && _localBox.containsKey(cacheKey)) {
        print("Carregando dados do cache local...");
        final cachedData = _localBox.get(cacheKey);
        return List<Map<String, dynamic>>.from(cachedData);
      }

      // Buscar dados do Firestore
      print("Carregando dados do Firestore...");
      final querySnapshot = await _database.collection(collectionPath).get();
      final data = querySnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

      // Atualizar o cache local
      await _localBox.put(cacheKey, data);
      return data;
    } catch (e) {
      print("Erro ao buscar dados: $e");
      if (_localBox.containsKey(cacheKey)) {
        print("Retornando dados do cache local...");
        return List<Map<String, dynamic>>.from(_localBox.get(cacheKey));
      }
      rethrow;
    } finally {
      isLoading.value = false; // Desativa o indicador de carregamento
    }
  }

  // Salvar dados no Firestore e atualizar o cache
  Future<void> saveData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final cacheKey = collectionPath;

    try {
      // Salvar no Firestore
      final docRef = await _database.collection(collectionPath).add(data);

      // Atualizar cache local
      final List<Map<String, dynamic>> cachedData = _localBox.get(cacheKey, defaultValue: []).cast<Map<String, dynamic>>();
      cachedData.add({'id': docRef.id, ...data});
      await _localBox.put(cacheKey, cachedData);
    } catch (e) {
      print("Erro ao salvar dados: $e");
      rethrow;
    }
  }
}
