import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/formulario/PageFormulario2.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/theme/colors.dart';

class PageFormulario1 extends StatefulWidget {
  const PageFormulario1({super.key});

  @override
  State<PageFormulario1> createState() => _PageFormulario1State();
}

class _PageFormulario1State extends State<PageFormulario1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PerfilDrawer(),
      appBar: AppBar(
        title: const Text('Cuide-se Mais'),
        actions: const [Padding(padding: EdgeInsets.only(right: 16.0))],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo Nome
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nome:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Idade
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Idade:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ex: 18',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe sua idade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botão Próximo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Campos validados com sucesso!'),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PageFormulario2(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Próximo',
                    style: TextStyle(
                      color: AppColors
                          .background, // supondo que você tenha AppColors.white
                      fontWeight: FontWeight.bold, // opcional
                      fontSize: 16, // opcional
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Builder(
        builder: (context) => BottomNavigationBar(
          backgroundColor: AppColors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ),
    );
  }
}
