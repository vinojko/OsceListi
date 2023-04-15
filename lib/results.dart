import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mime/mime.dart';

class Results extends StatefulWidget {
  final List<Map>? results;
  final String title;
  final String? name;
  final String ocenjevalec;
  final String minutes;
  final String seconds;
  const Results(
      {Key? key,
      required this.results,
      required this.title,
      required this.name,
      required this.ocenjevalec,
      required this.minutes,
      required this.seconds})
      : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  var correctAnswers = 0;

  String? fileLocation;
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
    createDir(widget.name!);
  }

  Future<String> createDir(String fileName) async {
    Directory? dir;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          dir = await getExternalStorageDirectory();
          print(dir!.path);
        } else if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        }

        if (dir == null) {
          throw Exception("Failed to get directory");
        }
        createXlsx(dir, fileName);
        print(dir);
        print(fileName);
      }
    } catch (e) {
      print(e);
    }
    return "false";
  }

  Future<String> createXlsx(Directory dir, String fileName) async {
    final now = DateTime.now();

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    final sheet = excel.sheets[excel.getDefaultSheet() as String];
    sheet!.setColWidth(0, 70);
    /* --- STATIC FIELDS --- */

    //IME IN PRIIMEK
    var cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    CellStyle? cellStyle =
        CellStyle(bold: true, horizontalAlign: HorizontalAlign.Right);
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = "Ime in priimek:";
    //OCENJEVALEC
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = "Ocenjevalec:";
    //DATUM
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2));
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = "Datum:";
    // NASLOV
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3));
    cellStyle = CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = widget.title;

    // JE OPRAVIL
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3));
    cellStyle = CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = "Je opravil";
    // NI OPRAVIL
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 3));
    cellStyle = CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = "Ni opravil";

    /* --- DYNAMIC FIELDS --- */

    //IME IN PRIIMEK
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    cellStyle = CellStyle(bold: false, horizontalAlign: HorizontalAlign.Left);
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = widget.name;
    //OCENJEVALEC
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1));
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = widget.ocenjevalec;
    //DATUM
    cellStatic = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2));
    cellStatic.cellStyle = cellStyle;
    cellStatic.value = '${now.day}/${now.month}/${now.year}';

    for (var i = 0; i < widget.results!.length; i++) {
      CellStyle? cellStyle;
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 4));
      print(widget.results![i]["state"]);

      if (widget.results![i]["state"] == "Je opravil") {
        cellStyle = CellStyle(backgroundColorHex: "#C6EFCE");
        cell.cellStyle = cellStyle;
        cell.value = widget.results![i]["question"];

        cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: "#C6EFCE",
        );
        cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 4));
        cell.cellStyle = cellStyle;
        cell.value = "X";

        cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 4));
        cell.cellStyle = cellStyle;
        cell.value = "";
      } else if (widget.results![i]["state"] == "Ni opravil") {
        cellStyle = CellStyle(backgroundColorHex: "#FFC7CE");

        cell.cellStyle = cellStyle;
        cell.value = widget.results![i]["question"];

        cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: "#FFC7CE",
        );
        cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 4));
        cell.cellStyle = cellStyle;
        cell.value = "X";

        cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 4));
        cell.cellStyle = cellStyle;
        cell.value = " ";
      }
    }

    //Ime Priimek - 2022-31-10 1926

    var fileBytes = excel.save();

    File(
        ('${dir.path}/$fileName/$fileName - ${now.year}-${now.day}-${now.month} ${now.hour}-${now.minute}.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    fileLocation =
        '$fileName/$fileName - ${now.year}-${now.day}-${now.month} ${now.hour}-${now.minute}.xlsx';

    return '${dir.path}/$fileName';
  }

  Future<bool> shareFile() async {
    Directory? dir;
    try {
      if (Platform.isIOS) {
        if (await Permission.storage.request().isGranted) {
          dir = await getApplicationDocumentsDirectory();

          Share.shareXFiles([XFile('${dir!.path}/$fileLocation')]);

          return true;
        } else {
          return false;
        }
      } else if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          dir = await getExternalStorageDirectory();

          Share.shareXFiles([XFile('${dir!.path}/$fileLocation')],
              text: 'Rezultati');

          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
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
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            const Text(
              "Končni čas:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.minutes}:${widget.seconds}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      shareFile();
                    },
                    child: const Text("Posreduj rezultate"))
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
                      padding: const EdgeInsets.only(left: 0, top: 5, right: 0),
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

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

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

Future get _localDir async {
  Directory? dir;
  try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        dir = await getExternalStorageDirectory();
        return dir!.path;

        //var newDir = await Directory('${dir.path}/"$fileName"').create(recursive: true);
        //var newFile = File('${dir.path}/"$fileName/"test.txt"');
      } else {
        return false;
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}
