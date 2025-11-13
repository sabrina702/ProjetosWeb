import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salvar respostas do Quizz
  Future<void> salvarResultadoQuizz(Map<String, dynamic> resultado) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não logado');

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('quizzResultado')
        .add({...resultado, 'data': FieldValue.serverTimestamp()});
  }

  // Salvar respostas do Formulário
  Future<void> salvarResultadoFormulario(Map<String, dynamic> respostas) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não logado');

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('formularioResultado')
        .add({...respostas, 'data': FieldValue.serverTimestamp()});
  }

  // Buscar resultados do Quizz
  Stream<QuerySnapshot> getResultadosQuizz() {
    final user = _auth.currentUser;
    return _db
        .collection('users')
        .doc(user!.uid)
        .collection('quizzResultado')
        .orderBy('data', descending: true)
        .snapshots();
  }

  // Buscar resultados do Formulário
  Stream<QuerySnapshot> getResultadosFormulario() {
    final user = _auth.currentUser;
    return _db
        .collection('users')
        .doc(user!.uid)
        .collection('formularioResultado')
        .orderBy('data', descending: true)
        .snapshots();
  }
}
