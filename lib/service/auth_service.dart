import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/models/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cadastro de novo usuário
  Future<UserModel?> register({
    required String nome,
    required String email,
    required String senha,
    required String tipoUsuario,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final user = userCredential.user;

      if (user != null) {
        final newUser = UserModel(
          id: user.uid,
          nome: nome,
          email: email,
          senha: senha,
          tipoUsuario: tipoUsuario,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        await user.updateDisplayName(nome);

        return newUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print('❌ Erro inesperado no cadastro: $e');
      rethrow;
    }
  }

  // 🔹 Login modificado — agora retorna também o nome e tipoUsuario
  Future<UserModel?> login(String email, String senha) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = userCredential.user;
      if (user == null) return null;

      // 🔹 Busca as informações do usuário no Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        return UserModel(
          id: user.uid,
          nome: data['nome'],
          email: data['email'],
          senha: data['senha'],
          tipoUsuario: data['tipoUsuario'],
        );
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Usuário atual
  User? get currentUser => _auth.currentUser;
}
