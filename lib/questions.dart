import 'package:flutter/material.dart';
import 'package:osce/questions_test.dart';

class Questions extends StatefulWidget {
  final List<String> questions;
  const Questions({Key? key, required this.questions}) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocenjevanje')),
      body: QuestionsTest(widget.questions),
    );
  }
}
