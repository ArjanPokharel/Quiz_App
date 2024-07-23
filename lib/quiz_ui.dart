import 'package:flutter/material.dart';
import 'timer.dart';

class QuizUI extends StatelessWidget {
  final String question;
  final List<String> options;
  final bool isOptionSelected;
  final String selectedOption;
  final String correctAnswer;
  final int currentQuestionIndex;
  final int totalQuestions;
  final void Function(String) onSelectOption;
  final void Function() onNext;
  final void Function() onTimerEnd;
  final void Function() onTick;

  const QuizUI({
    super.key,
    required this.question,
    required this.options,
    required this.isOptionSelected,
    required this.selectedOption,
    required this.correctAnswer,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onSelectOption,
    required this.onNext,
    required this.onTimerEnd,
    required this.onTick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6), // Change background color here
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '${currentQuestionIndex + 1} / $totalQuestions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        backgroundColor: const Color(0xFFF1F2F6), // Change app bar background color here
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // Add some space for the timer
                Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    question,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 50),
                ...options.map((option) {
                  Color optionColor;
                  Widget? icon;

                  if (isOptionSelected) {
                    if (option == selectedOption) {
                      optionColor = option == correctAnswer
                          ? const Color(0xFFB5D6CD) // Correct option color
                          : const Color(0xFFD6A4A3); // Incorrect option color
                      icon = option == correctAnswer
                          ? Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                    } else if (option == correctAnswer) {
                      optionColor = const Color(0xFFB5D6CD); // Correct option color
                      icon = Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.brown,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    } else {
                      optionColor = Colors.white;
                      icon = null;
                    }
                  } else {
                    optionColor = Colors.white;
                    icon = null;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GestureDetector(
                      onTap: () => onSelectOption(option),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (icon != null) icon,
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isOptionSelected ? onNext : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                        backgroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Next', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 20, // Center horizontally
              top: 10,
              child: QuizTimer(
                duration: 60,
                onTimerEnd: onTimerEnd,
                onTick: onTick,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF004D40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
