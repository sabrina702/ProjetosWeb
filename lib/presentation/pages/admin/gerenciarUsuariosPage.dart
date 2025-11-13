import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/presentation/pages/perfil/perfilEditarPage.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/service/user_service.dart';
import 'package:myapp/theme/colors.dart';

class GerenciarUsuariosPage extends StatefulWidget {
  const GerenciarUsuariosPage({super.key});

  @override
  State<GerenciarUsuariosPage> createState() => _GerenciarUsuariosPage();
}

class _GerenciarUsuariosPage extends State<GerenciarUsuariosPage> {
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

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tipoUsuario = _userData?["tipoUsuario"] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações do Perfil"),
        backgroundColor: AppColors.primary,
      ),
      body: tipoUsuario == "Administrador"
          ? _buildAdminView() // 🔹 Mostra todos os usuários se for admin
          : _buildUserView(user),
    );
  }

  /// 🔹 Visualização para usuários normais
  Widget _buildUserView(User? user) {
    return ListView(
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
                builder: (context) => PerfilEditarPage(
                  userId: user!.uid, // passa o ID do próprio usuário
                ),
              ),
            );
            if (atualizado == true) carregarDados();
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
    );
  }

  /// 🔹 Visualização para administradores — lista todos os usuários
  Widget _buildAdminView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        if (users.isEmpty) {
          return const Center(child: Text("Nenhum usuário encontrado."));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final data = user.data() as Map<String, dynamic>;

            return ListTile(
              leading: const Icon(Icons.person, color: Colors.black54),
              title: Text(data['nome'] ?? 'Sem nome'),
              subtitle: Text(
                "${data['email'] ?? 'Sem e-mail'} • ${data['tipoUsuario'] ?? ''}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerfilEditarPage(
                            userId:
                                user.id, // 🔹 passa o ID do usuário selecionado
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _userService.deleteUser(userId: user.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Usuário "${data['nome']}" excluído com sucesso',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _divider() => Divider(color: Colors.grey.shade300, thickness: 1);

  Widget _infoTile(String title, String value) => ListTile(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    trailing: Text(value, style: const TextStyle(fontSize: 16)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  );

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
