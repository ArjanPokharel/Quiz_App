import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'result_screen.dart';
import 'timer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isOptionSelected = false;
  String _selectedOption = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    final response = await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _questions = data.map((question) {
          final correctAnswer = question['correctAnswer'];
          final options = [
            ...question['incorrectAnswers'],
            correctAnswer,
          ]..shuffle();
          return {
            'question': question['question'],
            'correctAnswer': correctAnswer,
            'options': options,
            'selectedOption': null,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load quiz data');
    }
  }

  Future<void> _saveQuizResult(int score, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList('quizResults') ?? [];
    String result = 'Score: $score / $totalQuestions';
    results.add(result);
    await prefs.setStringList('quizResults', results);
  }

  void _selectOption(String option) {
    if (!_isOptionSelected) {
      setState(() {
        _isOptionSelected = true;
        _selectedOption = option;
        _questions[_currentQuestionIndex]['selectedOption'] = option;

        if (option == _questions[_currentQuestionIndex]['correctAnswer']) {
          _score++;
        }
      });
    }
  }

  void _nextQuestionOrResult() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isOptionSelected = false;
        _selectedOption = '';
      });
    } else {
      _saveQuizResult(_score, _questions.length).then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              score: _score,
              totalQuestions: _questions.length,
            ),
          ),
        );
      });
    }
  }

  void _onTimerEnd() {
    _nextQuestionOrResult();
  }

  void _onTick() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF1F2F6),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final correctAnswer = question['correctAnswer'];
    final options = question['options'];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Quiz App',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF1F2F6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: QuizTimer(
                duration: 60,
                onTimerEnd: _onTimerEnd,
                onTick: _onTick,
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF194F46), // Timer text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Question ${_currentQuestionIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['question']['text'],
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ...options.map((option) {
                    Color optionColor;
                    IconData? icon;

                    if (_isOptionSelected) {
                      if (option == _selectedOption) {
                        optionColor = option == correctAnswer ? Colors.green : Colors.red;
                        icon = option == correctAnswer ? Icons.check : Icons.close;
                      } else if (option == correctAnswer) {
                        optionColor = Colors.green;
                        icon = Icons.check;
                      } else {
                        optionColor = Colors.white;
                        icon = null;
                      }
                    } else {
                      optionColor = Colors.white;
                      icon = null;
                    }

                    return GestureDetector(
                      onTap: () => _selectOption(option),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: optionColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            if (icon != null)
                              Icon(
                                icon,
                                size: 24,
                                color: optionColor == Colors.green ? Colors.green : Colors.red,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isOptionSelected ? _nextQuestionOrResult : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: const Color(0xFF194F46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Next', style: TextStyle(color: Colors.white)),
                    ),
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
