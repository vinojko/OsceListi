import 'dart:io';
import 'package:flutter/material.dart';
import 'package:osce/questions.dart';
import 'package:osce/questions_test.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

const List<String> letniki = <String>['1. letnik', '2. letnik', '3. letnik'];
List<String> kontrolniListi = ['Aspiracija'];
const List<String> ocenjevalec = <String>['Študent', 'Visokošolski učitelj'];
List<String> questions = [];
String kontrolniListChoose = kontrolniListi.first;

bool succes = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    downloadFirst();
    downloadSecond();
    downloadThird();

    updateControlList("1. letnik").whenComplete(() => setState(() {
          // Update your UI with the desired changes.
        }));
  }

  void showStatus(BuildContext context) {}

  String letnikChoose = letniki.first;

  String ocenjevalecChoose = ocenjevalec.first;

  var myController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(25.0),
          //alignment: Alignment.topLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
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
                letnikChoose = value!;
                updateControlList(letnikChoose).whenComplete(() => setState(() {
                      // Update your UI with the desired changes.
                    }));
              },
              items: letniki.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
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
              items:
                  kontrolniListi.map<DropdownMenuItem<String>>((String value) {
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
              items: ocenjevalec.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              "Vnesi ime in priimek študenta",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 500.0,
              height: 45.0,
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                onPressed: () {
                  _read(letnikChoose, kontrolniListChoose, ocenjevalecChoose);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Questions(
                          questions: questions,
                          name: myController.text,
                          ocenjevalec: ocenjevalecChoose)));
                },
                child: const Text(
                  "Začni z ocenjevanjem",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
                Expanded(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start,
                  children: [ 
                  Image.asset('assets/images/evropskiSklad.png',
                  scale: 2),
                  SizedBox(width: 30,),
                  Image.asset('assets/images/ministrstvo.png',
                  scale: 4),
                  SizedBox(width: 30,),
                  Image.asset('assets/images/fzv.png',
                  scale: 2.7)
                  ],),
                )
            
             
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

Future<String> _read(
    String letnik, String kontrolniList, String ocenjevalec) async {
  String text = "";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    var bytes = File('${directory.path}/${letnik}.xlsx').readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var table = decoder.tables[kontrolniList];
    var values = table!.rows[0];

    questions.clear();

    for (var row in decoder.tables[kontrolniList]!.rows) {
      questions.add(row[0]);
    }

    print(questions.length);

    //print(table); //sheet Name
    //print(excel.tables[table].maxCols);
    //print(excel.tables[table]!.maxRows);


  } catch (e) {
    print("Napaka pri branju datoteke:");
    print(e);
  }
  return text;
}

Future<String> updateControlList(String letnikChoose) async {
  String text = "";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    var bytes =
        File('${directory.path}/${letnikChoose}.xlsx').readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    kontrolniListi.clear();

    for (var table in excel.tables.keys) {
      kontrolniListi.add(table);

      //print(table); //sheet Name
      //print(excel.tables[table].maxCols);

    }
    kontrolniListChoose = kontrolniListi[0];
    print(kontrolniListi);
  } catch (e) {
    print("Napaka pri branju datoteke:");
    print(e);
  }
  return text;
}

Future<void> downloadFirst() async {
  final storageRef = FirebaseStorage.instance.ref();

  final pathReference = storageRef.child("OSCE/1. letnik.xlsx");

  final Directory dir = await getApplicationDocumentsDirectory();
  final filePath = "${dir.path}/1. letnik.xlsx";
  final file = File(filePath);

  final downloadTask = pathReference.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // TODO: Handle this case.
        break;
      case TaskState.paused:
        // TODO: Handle this case.
        break;
      case TaskState.success:
        print("succes");
        Fluttertoast.showToast(
          msg: "1. letnik uspešno posodobljen.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case TaskState.canceled:
        // TODO: Handle this case.
        break;
      case TaskState.error:
        Fluttertoast.showToast(
          msg: "Povezava z bazo ni uspela. Preverite internetno povezavo.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
    }
  });
}

Future<void> downloadSecond() async {
  final storageRef = FirebaseStorage.instance.ref();

  final pathReference = storageRef.child("OSCE/2. letnik.xlsx");

  final Directory dir = await getApplicationDocumentsDirectory();
  final filePath = "${dir.path}/2. letnik.xlsx";
  final file = File(filePath);

  final downloadTask = pathReference.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // TODO: Handle this case.
        break;
      case TaskState.paused:
        // TODO: Handle this case.
        break;
      case TaskState.success:
        print("succes");
        Fluttertoast.showToast(
          msg: "2. letnik uspešno posodobljen.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case TaskState.canceled:
        // TODO: Handle this case.
        break;
      case TaskState.error:
        Fluttertoast.showToast(
          msg: "Povezava z bazo ni uspela. Preverite internetno povezavo.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
    }
  });
}

Future<void> downloadThird() async {
  final storageRef = FirebaseStorage.instance.ref();

  final pathReference = storageRef.child("OSCE/3. letnik.xlsx");

  final Directory dir = await getApplicationDocumentsDirectory();
  final filePath = "${dir.path}/3. letnik.xlsx";
  final file = File(filePath);

  final downloadTask = pathReference.writeToFile(file);
  downloadTask.snapshotEvents.listen((taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        // TODO: Handle this case.
        break;
      case TaskState.paused:
        // TODO: Handle this case.
        break;
      case TaskState.success:
        print("succes");
        Fluttertoast.showToast(
          msg: "3. letnik uspešno posodobljen.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
      case TaskState.canceled:
        // TODO: Handle this case.
        break;
      case TaskState.error:
        Fluttertoast.showToast(
          msg: "Povezava z bazo ni uspela. Preverite internetno povezavo.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        break;
    }
  });
}
