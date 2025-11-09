import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/formulario/PageFormularioResultado.dart';
import 'package:myapp/presentation/pages/home/homePage.dart';
import 'package:myapp/presentation/pages/login/loginPage.dart';
import 'package:myapp/presentation/pages/quizz/quiz_page_resultado.dart';
import 'package:myapp/theme/colors.dart';
import 'package:myapp/theme/text_styles.dart';

class CuideSeMaisApp extends StatelessWidget {
  const CuideSeMaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuide-se Mais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: AppTextStyles.appBarTitle,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/formularioResultado': (context) => const PageFormularioResultado(),
        '/quizResultado': (context) => const QuizResultsPage(),
      },
    );
  }
}
