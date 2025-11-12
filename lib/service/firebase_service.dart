import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtém um documento específico pelo ID
  Future<DocumentSnapshot> getDoc(String collection, String id) {
    return _db.collection(collection).doc(id).get();
  }

  /// Obtém todos os documentos de uma coleção
  Future<QuerySnapshot> getCollection(String collection) {
    return _db.collection(collection).get();
  }

  /// Atualiza um documento existente
  Future<void> updateDoc(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) {
    return _db.collection(collection).doc(id).update(data);
  }

  /// Exclui um documento
  Future<void> deleteDoc(String collection, String id) {
    return _db.collection(collection).doc(id).delete();
  }

  /// Adiciona um novo documento (ou substitui se já existir)
  Future<void> addDoc(String collection, String id, Map<String, dynamic> data) {
    return _db.collection(collection).doc(id).set(data);
  }
}
