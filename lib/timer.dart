import 'dart:async';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerEnd;
  final VoidCallback onTick;
  final TextStyle textStyle;

  const QuizTimer({
    super.key,
    required this.duration,
    required this.onTimerEnd,
    required this.onTick,
    required this.textStyle,
  });

  @override
  QuizTimerState createState() => QuizTimerState();
}

class QuizTimerState extends State<QuizTimer> {
  late int _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining == 0) {
        timer.cancel();
        widget.onTimerEnd();
      } else {
        setState(() {
          _timeRemaining--;
        });
        widget.onTick();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    value: _timeRemaining / widget.duration,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF194F46)),
                  ),
                ),
                Center(
                  child: Text(
                    '$_timeRemaining',
                    style: widget.textStyle,
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
