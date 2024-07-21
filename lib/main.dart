import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => ResultScreen(
          score: (ModalRoute.of(context)!.settings.arguments as Map)['score'],
          totalQuestions: (ModalRoute.of(context)!.settings.arguments as Map)['totalQuestions'],
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
