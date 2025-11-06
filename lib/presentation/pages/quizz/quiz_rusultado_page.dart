import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';
import 'quiz_home_page.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  final List<int> userAnswers;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.userAnswers,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  bool _saving = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _saving = false;
        _error = "Usuário não está logado.";
      });
      return;
    }

    final quizResult = {
      'score': widget.score,
      'totalQuestions': 10,
      'answers': widget.userAnswers,
      'takenAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('QuizzResultado')
          .add(quizResult);

      setState(() => _saving = false);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = "Erro ao salvar resultado: $e";
      });
    }
  }

  String get _getMessage {
    final percentage = (widget.score / 10) * 100;
    if (percentage >= 90) return 'Excelente!';
    if (percentage >= 70) return 'Muito bom!';
    if (percentage >= 50) return 'Bom!';
    return 'Continue tentando!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuide-se Mais')),
      body: SafeArea(
        child: _saving
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                      '${widget.score}/10',
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
                        '${(widget.score / 10 * 100).toStringAsFixed(0)}%\n${_getMessage}',
                        style: AppTextStyles.subtitle.copyWith(
                          color: Colors.white,
                        ),
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
                  ],
                ),
              ),
      ),
    );
  }
}
