import 'package:flutter/material.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';
import 'quiz_home_page.dart';

class QuizResultPage extends StatelessWidget {
  final int score;

  const QuizResultPage({
    super.key,
    required this.score,
  });

  String get _getMessage {
    final percentage = (score / 10) * 100;
    if (percentage >= 90) return 'Excelente!';
    if (percentage >= 70) return 'Muito bom!';
    if (percentage >= 50) return 'Bom!';
    return 'Continue tentando!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuide-se Mais'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Quiz Concluído!',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                '$score/10',
                style: AppTextStyles.score,
                textAlign: TextAlign.center,
              ),
              Text(
                'Respostas corretas',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(score / 10 * 100).toStringAsFixed(0)}%\n${_getMessage}',
                  style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const QuizHomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Tentar Novamente',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            Navigator.pushNamed(context, '/perfil');
          }
        },
      ),
    );
  }
}
