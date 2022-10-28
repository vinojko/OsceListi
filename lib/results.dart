import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osce/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Results extends StatefulWidget {
  final List<Map>? results;
  final String? name;
  final String ocenjevalec;
  const Results(
      {Key? key,
      required this.results,
      required this.name,
      required this.ocenjevalec})
      : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  var correctAnswers = 0;
  getData() {
    //print(widget.results!.length);

    for (var i = 0; i < widget.results!.length; i++) {
      //print(widget.results![0][0]);
      correctAnswers += widget.results![i].entries
          .where((e) => e.value == "Je opravil")
          .toList()
          .length;
    }
    print(correctAnswers);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezultati"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(children: [
            Text(
              '${widget.name}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            const Text(
              "Opravljene naloge:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              "$correctAnswers / ${widget.results!.length}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //createExcel(widget.name);
                      createDir(widget.name!);
                    },
                    child: const Text("Shrani rezultate")),
                const SizedBox(width: 25),
                ElevatedButton(
                    onPressed: () {}, child: const Text("Posreduj rezultate"))
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              "Povzetek",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.results!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 400, top: 5, right: 400),
                      child: Card(
                        color:
                            (widget.results![index].containsValue("Je opravil")
                                ? Colors.teal
                                : Colors.red[400]),
                        elevation: 10,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              widget.results![index]['question'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
}

void createExcel(String? name) {
  new Directory(name!).create();

  String datetime = DateTime.now().toString();
  _localFile(name);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  print(path);
  return File('$path/name.txt');
}

void insertExcel() {}
Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<bool> createDir(String fileName) async {
  Directory? dir;
  try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        dir = await getExternalStorageDirectory();
        print(dir!.path);

        var newDir = await Directory('${dir.path}/"$fileName"').create(recursive: true);
      } else {
        return false;
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}
