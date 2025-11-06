import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';

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
              backgroundColor: AppColors.primary,
              child: Text(
                user?.displayName != null
                    ? user!.displayName![0]
                    : user?.email?[0] ?? "U",
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
          ),
          ListTile(
            leading: const Icon(Icons.quiz_outlined),
            title: const Text("Resultado do Quiz"),
            /*onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuizResultsPage()),
              );
            },*/
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text("Resultado do Formulário"),
            /*onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormResultsPage()),
              );
            },*/
          ),
          const Divider(),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // desloga o usuário
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ), // vai para login
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair', style: AppTextStyles.button),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
