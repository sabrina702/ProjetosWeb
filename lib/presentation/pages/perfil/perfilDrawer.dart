import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/formulario/PageFormularioResultado.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/presentation/pages/quizz/quiz_page_resultado.dart';
import 'package:myapp/theme/colors.dart';

class PerfilDrawer extends StatelessWidget {
  const PerfilDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "Usuário"),
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white, // círculo branco
              child: Text(
                user?.displayName != null
                    ? user!.displayName![0]
                    : user?.email?[0] ?? "U",
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primary, // letra roxa
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
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
          const Divider(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 42, // 🔹 botão menor
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ), // 🔹 ícone branco
                label: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white, // 🔹 texto branco
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
