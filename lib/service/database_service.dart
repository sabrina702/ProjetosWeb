import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salvar respostas de formulário ou quiz
  Future<void> salvarRespostas({
    required String userId,
    required Map<String, dynamic> respostas,
    required int pontuacao,
  }) async {
    await _db.collection('respostas').add({
      'userId': userId,
      'respostas': respostas,
      'pontuacao': pontuacao,
      'data': DateTime.now(),
    });
  }

  // Buscar resultados salvos
  Stream<QuerySnapshot> getResultados(String userId) {
    return _db
        .collection('respostas')
        .where('userId', isEqualTo: userId)
        .orderBy('data', descending: true)
        .snapshots();
  }
}
