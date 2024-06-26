import 'dart:async';

import 'package:flutter/material.dart';

class TimeOTP extends StatefulWidget {
  const TimeOTP({super.key});

  @override
  State<TimeOTP> createState() => _TimeOTPState();
}

class _TimeOTPState extends State<TimeOTP> {
  late Timer _timer;
  int _remainingTime = 60; // 5 minutes in seconds

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void resetTimer() {
    setState(() {
      _remainingTime = 60;
    });
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Resend OTP Verifiacation code ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            if (_remainingTime == 0) {
              resetTimer();
            }
          },
          child: Text(
            _remainingTime > 0 ? getFormattedTime(_remainingTime) : 'Resend',
            style: TextStyle(
            fontSize: 16,
            color: _remainingTime > 0 ? Colors.red : Colors.blue,
            fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}