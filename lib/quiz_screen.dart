import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_ui.dart';
import 'result_screen.dart';
import 'package:logging/logging.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  final Logger _logger = Logger('QuizScreen');

  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isOptionSelected = false;
  String _selectedOption = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _setupLogging();
    _fetchQuizData();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      _logger.info('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

Future<void> _fetchQuizData() async {
  try {
    final response = await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      _logger.fine('Response data: $data');

      setState(() {
        _questions = data.map((dynamic item) {
          final question = item as Map<String, dynamic>;

          _logger.fine('Question: $question');

          final correctAnswer = question['correctAnswer'] as String;
          final options = [
            ...List<String>.from(question['incorrectAnswers'] as List<dynamic>),
            correctAnswer,
          ]..shuffle();

          final questionText = question['question'] is String
              ? question['question'] as String
              : (question['question'] is Map ? question['question']['text'] as String : 'Unknown question format');

          return {
            'question': questionText,
            'correctAnswer': correctAnswer,
            'options': options,
            'selectedOption': null,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load quiz data: ${response.statusCode}');
    }
  } catch (error) {
    _logger.severe('Error fetching quiz data: $error');
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

    return QuizUI(
      question: question['question'],
      options: options,
      isOptionSelected: _isOptionSelected,
      selectedOption: _selectedOption,
      correctAnswer: correctAnswer,
      currentQuestionIndex: _currentQuestionIndex,
      totalQuestions: _questions.length,
      onSelectOption: _selectOption,
      onNext: _nextQuestionOrResult,
      onTimerEnd: _onTimerEnd,
      onTick: _onTick,
    );
  }
}
