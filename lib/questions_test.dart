import 'package:flutter/material.dart';
import 'package:osce/results.dart';
import 'package:osce/results/costum_radio_correct.dart';

class QuestionsTest extends StatefulWidget {
  //const QuestionsTest({super.key});

  final List<String>? questions;
  final String name;
  final String ocenjevalec;
  final String minutes;
  final String seconds;
  const QuestionsTest(
      {Key? key,
      required this.questions,
      required this.name,
      required this.ocenjevalec,
      required this.minutes,
      required this.seconds})
      : super(key: key);

  @override
  State<QuestionsTest> createState() => _QuestionsTestState();
}

class _QuestionsTestState extends State<QuestionsTest> {
  /*List<String> questions = <String>[
    'Umiti si roke.',
    'Pripraviti delovno površino.'
  ];*/

  List<String> labels = ['Je opravil', 'Ni opravil'];

  List<Map> results = [];
  Map<String?, String?> opravil = {};

  getData() {
    //print(widget.value!.length);

    for (var i = 1; i < widget.questions!.length; i++) {
      results.add({
        'id': 'ID$i',
        'question': widget.questions![i],
        'state': 'Ni opravil',
      });
    }
    /* questions.add({
      'id': 'ID1',
      'question': 'Umiti si roke.',
      'state': 'Ni opravil',
    });

    questions.add({
      'id': 'ID2',
      'question': 'Pripraviti delovno površino.',
      'state': 'Je opravil',
    });*/
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          results[index]['question'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            //Kolk je oddaljen radio od enega do drugega
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [
                                CostumRadioCorrect(
                                  groupValue: results[index]['state'],
                                  value: 'Je opravil',
                                  selectedColor: Colors.teal,
                                  icon: Icons.check,
                                  label: 'Je opravil',
                                  onChanged: (newValue) {
                                    setState(() {
                                      print(newValue);
                                      results[index]['state'] = newValue;
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                CostumRadioCorrect(
                                  groupValue: results[index]['state'],
                                  value: 'Ni opravil',
                                  selectedColor:
                                      Color.fromARGB(255, 219, 32, 60),
                                  icon: Icons.close,
                                  label: 'Ni opravil',
                                  onChanged: (newValue) {
                                    setState(() {
                                      print(newValue);
                                      results[index]['state'] = newValue;
                                    });
                                  },
                                ),
                              ]),
                              /*Radio(
                             groupValue: results[index]['state'],
                             value: s,
                             onChanged: (newValue) {
                               setState(() {
                                 print(newValue);
                                 results[index]['state'] = newValue;
                               });
                             },
                           ),*/
                            ]),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
      Positioned(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Results(
                            title: widget.questions![0],
                            results: results,
                            name: widget.name,
                            ocenjevalec: widget.ocenjevalec,
                            minutes: widget.minutes,
                            seconds: widget.seconds,
                          )));
                },
                child: const Text(
                  "Končaj z ocenjevanjem",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
          ),
        ),
      )
    ]);
  }
}

/*        return Row(
          
          children: labels.map((s) {
            return Column(
              
              children: <Widget>[
                Text(questions[index]['question']),
                Radio(
                  groupValue: opravil[questions[index]['id']],
                  value: s,
                  onChanged: (newValue) {
                    setState(() {
                      opravil[questions[index]['id']] = newValue;
                    });
                  },
                ),
                Text(s, style: TextStyle(color: Colors.black))
              ],
            );
          }).toList(),
          //Text(questions[index]),
        );*/
