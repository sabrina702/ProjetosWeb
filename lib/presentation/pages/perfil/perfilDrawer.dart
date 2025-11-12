import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/presentation/pages/admin/gerenciarUsuariosPage.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/presentation/pages/perfil/perfilConfiguracaoPage.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/presentation/pages/formulario/PageFormularioResultado.dart';
import 'package:myapp/presentation/pages/quizz/quiz_page_resultado.dart';

class PerfilDrawer extends StatefulWidget {
  const PerfilDrawer({super.key});

  @override
  State<PerfilDrawer> createState() => _PerfilDrawerState();
}

class _PerfilDrawerState extends State<PerfilDrawer> {
  String? nome;
  String? tipoUsuario;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          nome = doc['nome'];
          tipoUsuario = doc['tipoUsuario'];
        });
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              nome ?? "Carregando...",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // ❌ Removido o e-mail para mostrar só o nome
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (nome != null && nome!.isNotEmpty)
                    ? nome![0].toUpperCase()
                    : (user?.email?[0].toUpperCase() ?? "U"),
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
          ),

          // 🔹 Só aparece para Administradores
          if (tipoUsuario == 'Administrador')
            ListTile(
              leading: const Icon(Icons.manage_accounts_outlined),
              title: const Text("Gerenciar Perfis"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GerenciarUsuariosPage(),
                  ),
                );
              },
            ),

          ListTile(
            leading: const Icon(Icons.quiz_outlined),
            title: const Text("Resultado do Quiz"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizResultsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text("Resultado do Formulário"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageFormularioResultado(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Configurações do Perfil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfiguracaoPerfilPage(),
                ),
              );
            },
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
