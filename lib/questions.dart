import 'package:flutter/material.dart';
import 'package:osce/questions_test.dart';

class Questions extends StatefulWidget {

  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

List<String> questions = <String>['Umiti si roke.', 'Pripraviti delovno površino.'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocenjevanje')),
      body: const QuestionsTest(),
    );
  }
}
