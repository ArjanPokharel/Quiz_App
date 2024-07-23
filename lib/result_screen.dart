import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    _saveResult(score, totalQuestions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: const Color(0xFF497B78),
      ),
      backgroundColor: const Color(0xFF497B78), // Changed background color to 0xFF497B78
      body: Center(
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Set default text color to white and bold
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Text(
                'Your score is $score / $totalQuestions',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveResult(int score, int totalQuestions) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList('quizResults') ?? [];
    String result = 'Score: $score / $totalQuestions';
    results.add(result);
    await prefs.setStringList('quizResults', results);
  }
}
