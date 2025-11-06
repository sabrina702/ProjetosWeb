import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';

class PageFormularioFinal extends StatelessWidget {
  const PageFormularioFinal({super.key});

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                'Formulário Enviado!',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Suas respostas foram registradas com sucesso.\nAgradecemos sua participação!',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // volta pra Home
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Voltar à Home', style: AppTextStyles.button),
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
