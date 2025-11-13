import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Busca os dados do usuário logado
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  // 🔹 Atualiza dados do usuário (usado no PerfilEditarPage)
  Future<void> updateUserData(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update(data);
  }

  // 🔹 Exclui conta do usuário logado (Configuração de Perfil)
  Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Remove do Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Exclui do Authentication
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
          'Por segurança, faça login novamente antes de excluir a conta.',
        );
      } else {
        throw Exception('Erro ao excluir conta: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado ao excluir conta: $e');
    }
  }

  // 🔹 Novo: Busca todos os usuários (usado em GerenciarUsuariosPage)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    }).toList();
  }

  // 🔹 Novo: Exclui um usuário específico pelo ID (para admin)
  Future<void> deleteUser({required String userId}) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // 🔹 Busca dados de qualquer usuário pelo ID
  Future<Map<String, dynamic>?> getUserDataById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  // 🔹 Atualiza dados de qualquer usuário pelo ID
  Future<void> updateUserDataById(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection('users').doc(userId).update(data);
  }
}
