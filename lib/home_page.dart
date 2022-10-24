import 'dart:io';
import 'package:flutter/material.dart';
import 'package:osce/questions.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

const List<String> letniki = <String>['1. letnik', '2. letnik', '3. letnik'];
const List<String> kontrolniListi = <String>[
  'Aspiracija',
  '2. letnik',
  '3. letnik'
];
const List<String> ocenjevalec = <String>['Študent', 'Profesor'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String letnikChoose = letniki.first;
  String kontrolniListChoose = kontrolniListi.first;
  String ocenjevalecChoose = ocenjevalec.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(25.0),
          //alignment: Alignment.topLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Izberi letnik",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                DropdownButton<String>(
                  hint: const Text("Izberi letnik..."),
                  value: letnikChoose,
                  onChanged: (String? value) {
                    setState(() {
                      letnikChoose = value!;
                    });
                  },
                  items: letniki.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Izberi kontrolni list",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                DropdownButton<String>(
                  hint: const Text("Izberi kontrolni list..."),
                  value: kontrolniListChoose,
                  onChanged: (String? value) {
                    setState(() {
                      kontrolniListChoose = value!;
                    });
                  },
                  items: kontrolniListi
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Ocenjevalec",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                //Ocenjevalec
                DropdownButton<String>(
                  hint: const Text("Ocenjevalec"),
                  value: ocenjevalecChoose,
                  onChanged: (String? value) {
                    setState(() {
                      ocenjevalecChoose = value!;
                      print('Ocenjevalec:  $value');
                    });
                  },
                  items:
                      ocenjevalec.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Vnesi ime in priimek",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 500.0,
                  height: 45.0,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const Questions();
                      }));
                      _read(letnikChoose, kontrolniListChoose, ocenjevalecChoose);
                    },
                    child: const Text(
                      "Začni z ocenjevanjem",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ))
              ]),
        ),
      ),
    );
  }
}

/*void readExcel() {
 // var file = "C:/Users/vinoj/Documents/GitHub/osce/spreadsheets/2letnik.xlsx";
  final Directory directory =  getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/2letnik.xlsx');
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    print(table); //sheet Name
    //print(excel.tables[table].maxCols);
    //print(excel.tables[table].maxRows);
    for (var row in excel.tables[table]!.rows) {
      print("$row");
    }
  }
}*/

Future<String> _read(String letnik, String kontrolniList, String ocenjevalec) async {
  String text ="";
  try {
    print(letnik);
    print(kontrolniList);
    print(ocenjevalec);
    final Directory directory = await getApplicationDocumentsDirectory();
    var bytes = File('${directory.path}/2letnik.xlsx').readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      //print(table); //sheet Name
      //print(excel.tables[table].maxCols);
      print(excel.tables[table]!.maxRows);
      for (var row in excel.tables[table]!.rows) {
        var row1 = row[0];
        //print("$row1");
      }
    }
  } catch (e) {
    print("Napaka pri branju datoteke:");
    print(e);
  }
  return text;
}
