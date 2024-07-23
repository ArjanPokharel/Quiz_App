import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _previousResults = 'No previous results found';

  @override
  void initState() {
    super.initState();
    _loadPreviousResults();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadPreviousResults() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> results = prefs.getStringList('quizResults') ?? [];
    setState(() {
      if (results.isNotEmpty) {
        // Get the last 5 results
        final last5Results = results.length > 5 
            ? results.sublist(results.length - 5) 
            : results;
        _previousResults = last5Results.isNotEmpty
            ? last5Results.join('\n')
            : 'No previous results found';
      } else {
        _previousResults = 'No previous results found';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF497B78),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'QUIZ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text widget added above the TextField
                        const Text(
                          'Enter your name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8), // Add some spacing
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white), // Set text color to white
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF497B78), // Match background color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.white), // White border color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.white), // White border color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.white), // White border color
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Added horizontal padding
                            // hintText: '',
                            // hintStyle: const TextStyle(color: Colors.white70), // Hint text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7C942),
                    padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    String name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/quiz',
                        arguments: name,
                      );
                    }
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6AD7A5),
                    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Previous Quiz Results'),
                        content: Text(_previousResults),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'View Quiz Result',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}