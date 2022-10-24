import 'package:flutter/material.dart';

class QuestionsTest extends StatefulWidget {
  const QuestionsTest({super.key});

  @override
  State<QuestionsTest> createState() => _QuestionsTestState();
}

class _QuestionsTestState extends State<QuestionsTest> {
  /*List<String> questions = <String>[
    'Umiti si roke.',
    'Pripraviti delovno površino.'
  ];*/

  List<String> labels = ['Je opravil', 'Ni opravil'];

  List<Map> questions = [];
  Map<String?, String?> opravil = {};

  getData() {
    questions.add({
      'id': 'ID1',
      'question': 'Umiti si roke.',
      'state': 'Ni opravil',
    });

    questions.add({
      'id': 'ID2',
      'question': 'Pripraviti delovno površino.',
      'state': 'Je opravil',
    });

  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (BuildContext context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            elevation: 10,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  questions[index]['question'],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
      
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      //Kolk je oddaljen radio od enega do drugega
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: labels.map((s) {
                        return Column(
                          children: <Widget>[
                            Radio(
                              groupValue: questions[index]['state'],
                              value: s,
                              onChanged: (newValue) {
                                setState(() {
                                  print(newValue);
                                  questions[index]['state'] = newValue;
                                });
                              },
                            ),
                            Text(s, style: const TextStyle(color: Colors.black, fontSize: 17))
                          ],
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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
