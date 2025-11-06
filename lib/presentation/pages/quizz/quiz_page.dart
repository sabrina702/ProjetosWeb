import 'package:flutter/material.dart';
import 'package:myapp/data/models/quiz_question.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/presentation/pages/quizz/quiz_rusultado_page.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<int> userAnswers = [];

  void _handleAnswer(int selectedIndex) {
    final currentQuestion = quizQuestions[currentQuestionIndex];
    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      correctAnswers++;
    }
    userAnswers.add(selectedIndex);

    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              QuizResultPage(score: correctAnswers, userAnswers: []),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizQuestions[currentQuestionIndex];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const PerfilDrawer(),
      appBar: AppBar(
        title: const Text('Cuide-se Mais'),
        actions: const [Padding(padding: EdgeInsets.only(right: 16.0))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / quizQuestions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema 1: Saúde e Qualidade de Vida',
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${currentQuestionIndex + 1}. ${currentQuestion.question}',
                      style: AppTextStyles.title.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      currentQuestion.options.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () => _handleAnswer(index),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.radio_button_unchecked,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    currentQuestion.options[index],
                                    style: AppTextStyles.body,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
