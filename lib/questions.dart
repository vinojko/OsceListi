import 'package:flutter/material.dart';
import 'package:osce/count_down_timer.dart';
import 'package:osce/questions_test.dart';
import 'dart:async';

class Questions extends StatefulWidget {
  final List<String> questions;
  final String name;
  final String ocenjevalec;
  const Questions(
      {Key? key,
      required this.questions,
      required this.name,
      required this.ocenjevalec})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  Duration duration = Duration();
  Timer? timer;
  String? minutes = '00';
  String? seconds = '00';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocenjevanje'),
        actions: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.only(right: 12.0), child: buildTime()))
        ],
      ),
      body: QuestionsTest(
          questions: widget.questions,
          name: widget.name,
          ocenjevalec: widget.ocenjevalec,
          minutes: minutes!,
          seconds: seconds!),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    minutes = twoDigits(duration.inMinutes.remainder(60));
    seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text('$minutes:$seconds', style: TextStyle(fontSize: 25));
  }
}
