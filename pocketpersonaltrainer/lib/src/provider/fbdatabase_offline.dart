import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class FbDatabaseOffline {
  final FirebaseFirestore _database;

  FbDatabaseOffline(this._database);

  // Inicialize o Hive ou outro banco local
  Future<void> initLocalDatabase() async {
    Hive.init('localData');
    await Hive.openBox('localData'); // Caixa para dados locais
  }

  // Método para buscar dados com offline-first
  Future<List<Map<String, dynamic>>> fetchData({required String collectionPath, bool forceOnline = false}) async {
    final localBox = Hive.box('localData');
    final cacheKey = collectionPath;

    // Retornar do cache local, se existir e não for forçado a buscar online
    if (!forceOnline && localBox.containsKey(cacheKey)) {
      print("Carregando dados do cache local...");
      return List<Map<String, dynamic>>.from(localBox.get(cacheKey));
    }

    try {
      // Buscar do Firestore
      print("Carregando dados do Firestore...");
      final querySnapshot = await _database.collection(collectionPath).get();

      final List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) => doc.data()).toList();

      // Salvar no cache local para futuras buscas offline
      await localBox.put(cacheKey, data);

      return data;
    } catch (e) {
      // Fallback para o cache local em caso de erro
      if (localBox.containsKey(cacheKey)) {
        print("Erro ao carregar dados online. Retornando do cache local.");
        return List<Map<String, dynamic>>.from(localBox.get(cacheKey));
      }
      rethrow; // Se não houver cache, relança o erro
    }
  }

  // Método para salvar dados no Firestore e no cache local
  Future<void> saveData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final localBox = Hive.box('localData');
    final cacheKey = collectionPath;

    try {
      // Adicionar ao Firestore
      final docRef = await _database.collection(collectionPath).add(data);

      // Atualizar o cache local
      final List<Map<String, dynamic>> cachedData = localBox.get(cacheKey, defaultValue: []) as List<Map<String, dynamic>>;
      cachedData.add({'id': docRef.id, ...data});
      await localBox.put(cacheKey, cachedData);
    } catch (e) {
      print("Erro ao salvar dados: $e");
      rethrow;
    }
  }

  // Método para atualizar um documento
  Future<void> updateData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> newData,
  }) async {
    final localBox = Hive.box('localData');
    final cacheKey = collectionPath;

    try {
      // Atualizar no Firestore
      await _database.collection(collectionPath).doc(documentId).update(newData);

      // Atualizar o cache local
      final List<Map<String, dynamic>> cachedData = localBox.get(cacheKey, defaultValue: []) as List<Map<String, dynamic>>;
      final index = cachedData.indexWhere((doc) => doc['id'] == documentId);

      if (index != -1) {
        cachedData[index].addAll(newData);
        await localBox.put(cacheKey, cachedData);
      }
    } catch (e) {
      print("Erro ao atualizar dados: $e");
      rethrow;
    }
  }

  // Método para deletar um documento
  Future<void> deleteData({
    required String collectionPath,
    required String documentId,
  }) async {
    final localBox = Hive.box('localData');
    final cacheKey = collectionPath;

    try {
      // Deletar do Firestore
      await _database.collection(collectionPath).doc(documentId).delete();

      // Atualizar o cache local
      final List<Map<String, dynamic>> cachedData = localBox.get(cacheKey, defaultValue: []) as List<Map<String, dynamic>>;
      cachedData.removeWhere((doc) => doc['id'] == documentId);
      await localBox.put(cacheKey, cachedData);
    } catch (e) {
      print("Erro ao deletar dados: $e");
      rethrow;
    }
  }
}
