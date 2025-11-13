import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/presentation/pages/home/homePage.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _tipoUsuario; // dropdown
  final _authService = AuthService();

  bool _loading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      // Verifica se as senhas coincidem
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _loading = false);
        return;
      }

      try {
        final user = await _authService.register(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          senha: _passwordController.text.trim(),
          tipoUsuario: _tipoUsuario ?? 'Aluno', // padrão
        );

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta criada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );

          // Redireciona para a HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Erro ao criar conta.';

        if (e.code == 'email-already-in-use') {
          message = 'Este e-mail já está em uso.';
        } else if (e.code == 'invalid-email') {
          message = 'E-mail inválido.';
        } else if (e.code == 'weak-password') {
          message = 'Senha muito fraca.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastre-se')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add,
                    color: AppColors.primary,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Crie sua conta',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os campos abaixo para se cadastrar',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // E-mail
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu e-mail';
                      } else if (!value.contains('@')) {
                        return 'Digite um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tipo de usuário
                  DropdownButtonFormField<String>(
                    value: _tipoUsuario,
                    items: const [
                      DropdownMenuItem(value: 'Aluno', child: Text('Aluno')),
                      DropdownMenuItem(
                        value: 'Professor',
                        child: Text('Professor'),
                      ),
                      DropdownMenuItem(
                        value: 'Administrador',
                        child: Text('Administrador'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _tipoUsuario = value),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Usuário',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null ? 'Selecione o tipo de usuário' : null,
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite sua senha';
                      } else if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirmar senha
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botão de cadastro
                  ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Cadastrar', style: AppTextStyles.button),
                  ),

                  const SizedBox(height: 16),

                  // Link para login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Já tem conta? Faça login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
