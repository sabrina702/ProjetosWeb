import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/perfil/perfilEditarPage.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/service/user_service.dart';
import 'package:myapp/theme/colors.dart';

class ConfiguracaoPerfilPage extends StatefulWidget {
  const ConfiguracaoPerfilPage({super.key});

  @override
  State<ConfiguracaoPerfilPage> createState() => _ConfiguracaoPerfilPageState();
}

class _ConfiguracaoPerfilPageState extends State<ConfiguracaoPerfilPage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final data = await _userService.getUserData();
    setState(() {
      _userData = data;
      _loading = false;
    });
  }

  Future<void> _excluirConta() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir conta"),
        content: const Text(
          "Tem certeza de que deseja excluir sua conta? Essa ação não pode ser desfeita.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _userService.deleteUserAccount();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao excluir conta: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações do Perfil"),
        backgroundColor: AppColors.primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text("Erro ao carregar dados."))
          : ListView(
              children: [
                _infoTile("Nome", _userData!["nome"] ?? ""),
                _divider(),
                _infoTile("E-mail", user?.email ?? ""),
                _divider(),
                _infoTile("Tipo de Usuário", _userData!["tipoUsuario"] ?? ""),
                _divider(),
                _actionTile(
                  icon: Icons.edit,
                  text: "Editar perfil",
                  color: AppColors.primary,
                  onTap: () async {
                    final atualizado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilEditarPage(),
                      ),
                    );
                    if (atualizado == true) {
                      carregarDados();
                    }
                  },
                ),
                _divider(),
                _actionTile(
                  icon: Icons.delete_forever,
                  text: "Excluir conta",
                  color: Colors.red,
                  onTap: _excluirConta,
                ),
              ],
            ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, thickness: 1);
  }

  Widget _infoTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: Text(value, style: const TextStyle(fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
