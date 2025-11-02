import 'package:flutter/material.dart';
import 'package:myapp/data/models/quiz_question.dart';
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
          builder: (context) => QuizResultPage(score: correctAnswers),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = quizQuestions[currentQuestionIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primary,
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cuide-se Mais',
                    style: AppTextStyles.title.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / quizQuestions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            const Spacer(),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Próxima Pergunta',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.navigationBarBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      Text(
                        'Home',
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      Text(
                        'Perfil',
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}