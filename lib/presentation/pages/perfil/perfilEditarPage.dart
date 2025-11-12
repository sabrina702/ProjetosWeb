import 'package:flutter/material.dart';
import 'package:myapp/service/user_service.dart';
import 'package:myapp/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilEditarPage extends StatefulWidget {
  final String? userId; // ✅ Adicionado para receber ID de outro usuário

  const PerfilEditarPage({super.key, this.userId});

  @override
  State<PerfilEditarPage> createState() => _PerfilEditarPageState();
}

class _PerfilEditarPageState extends State<PerfilEditarPage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nomeController = TextEditingController();
  String? _tipoUsuarioSelecionado;
  String _email = '';
  bool _loading = true;

  final List<String> _tiposUsuario = ['Aluno', 'Professor', 'Administrador'];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    setState(() => _loading = true);

    try {
      final userId = widget.userId ?? _auth.currentUser?.uid;
      if (userId == null) return;

      final userData = await _userService.getUserDataById(userId);

      if (userData != null) {
        _email = userData['email'] ?? '';
        _nomeController.text = userData['nome'] ?? '';
        _tipoUsuarioSelecionado =
            userData['tipoUsuario'] ?? _tiposUsuario.first;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar dados: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _loading = true);

        final userId = widget.userId ?? _auth.currentUser?.uid;
        if (userId == null) return;

        await _userService.updateUserDataById(userId, {
          'nome': _nomeController.text.trim(),
          'tipoUsuario': _tipoUsuarioSelecionado,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados atualizados com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: AppColors.primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildLabel("Nome"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.edit, color: Colors.grey),
                        border: const OutlineInputBorder(),
                        hintText: 'Digite seu nome',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("E-mail"),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _email,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.lock, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("Tipo de Usuário"),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _tipoUsuarioSelecionado,
                      items: _tiposUsuario.map((tipo) {
                        return DropdownMenuItem(value: tipo, child: Text(tipo));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoUsuarioSelecionado = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton.icon(
                      onPressed: _salvarAlteracoes,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Salvar alterações",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
