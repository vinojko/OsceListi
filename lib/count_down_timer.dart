import 'package:flutter/material.dart';
import 'dart:async';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration duration = Duration();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    reset();
    startTimer();
  }

  void reset() {
    setState(() {
      duration = Duration();
    });
  }

  void addTime() {
    final addSeconds = 1;

    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;

        duration = Duration(seconds: seconds);
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child:
            Padding(padding: EdgeInsets.only(right: 12.0), child: buildTime()));
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text('$minutes:$seconds', style: TextStyle(fontSize: 25));
  }
}
