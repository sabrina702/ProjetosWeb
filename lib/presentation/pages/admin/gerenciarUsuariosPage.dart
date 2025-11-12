import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/perfil/perfilEditarPage.dart';
import 'package:myapp/service/user_service.dart';
import 'package:myapp/theme/colors.dart';

class GerenciarUsuariosPage extends StatefulWidget {
  const GerenciarUsuariosPage({super.key});

  @override
  State<GerenciarUsuariosPage> createState() => _GerenciarUsuariosPageState();
}

class _GerenciarUsuariosPageState extends State<GerenciarUsuariosPage> {
  final UserService _userService = UserService();
  bool _loading = true;
  List<Map<String, dynamic>> _usuarios = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    setState(() => _loading = true);
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _usuarios = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao carregar usuários: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> excluirUsuario(String userId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Deseja realmente excluir este usuário?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _userService.deleteUser(userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuário excluído com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      carregarUsuarios();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao excluir usuário: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Usuários"),
        backgroundColor: AppColors.primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _usuarios.isEmpty
          ? const Center(child: Text("Nenhum usuário cadastrado."))
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(usuario['nome'] ?? 'Sem nome'),
                    subtitle: Text(usuario['email'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final atualizado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PerfilEditarPage(
                                  userId: usuario['uid'], // 🔹 ajustado
                                ),
                              ),
                            );
                            if (atualizado == true) carregarUsuarios();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => excluirUsuario(
                            usuario['uid'] as String,
                          ), // 🔹 ajustado
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
