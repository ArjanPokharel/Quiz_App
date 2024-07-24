import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultsProvider with ChangeNotifier {
  List<String> _results = [];

  List<String> get results => _results;

  Future<void> loadPreviousResults() async {
    final prefs = await SharedPreferences.getInstance();
    final storedResults = prefs.getStringList('quiz_results') ?? [];
    _results = storedResults;
    notifyListeners();
  }

  Future<void> addResult(String result) async {
    final prefs = await SharedPreferences.getInstance();
    _results.add(result);
    await prefs.setStringList('quiz_results', _results);
    notifyListeners();
  }
}
