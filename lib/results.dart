import 'package:flutter/material.dart';
import 'package:osce/home_page.dart';

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
  getData() {

    print(widget.results!.length);
    for(var i = 0; i< widget.results!.length; i++){
      print(widget.results![0][0]);
    }
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
              "Pravilni odgovori:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Text(
              "50 / 50",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
      ),
    );
  }
}
