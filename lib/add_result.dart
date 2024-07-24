import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultsProvider with ChangeNotifier {
  List<String> _results = [];

  List<String> get results => _results;

  QuizResultsProvider() {
    loadPreviousResults();
  }

  // Method to load previous quiz results from SharedPreferences
  Future<void> loadPreviousResults() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList('quizResults') ?? [];
    _results = results.reversed.take(5).toList().reversed.toList();
    notifyListeners();
  }

  // Method to add a new result and update the list in SharedPreferences
  Future<void> addResult(String result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList('quizResults') ?? [];

    // Avoid adding the same result consecutively
    if (results.isEmpty || results.last != result) {
      results.add(result);
      await prefs.setStringList('quizResults', results);
      _results = results.reversed.take(5).toList().reversed.toList();
      notifyListeners();
    }
  }
}
