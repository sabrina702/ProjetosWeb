import 'package:flutter/material.dart';
import 'package:myapp/presentation/login/loginPage.dart';
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
    );
  }
}
