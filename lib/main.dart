import 'dart:io';

import 'package:flutter/material.dart';
import 'package:osce/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
  //downloadFile();
}

Map<int, Color> color = {
  50: Color.fromRGBO(0, 106, 142, .1),
  100: Color.fromRGBO(0, 106, 142, .2),
  200: Color.fromRGBO(0, 106, 142, .3),
  300: Color.fromRGBO(0, 106, 142, .4),
  400: Color.fromRGBO(0, 106, 142, .5),
  500: Color.fromRGBO(0, 106, 142, .6),
  600: Color.fromRGBO(0, 106, 142, .7),
  700: Color.fromRGBO(0, 106, 142, .8),
  800: Color.fromRGBO(0, 106, 142, .9),
  900: Color.fromRGBO(0, 106, 142, 1),
};
MaterialColor myColor = MaterialColor(0xFF006A8E, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: myColor),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Postopki ZN in diagnostično terapevtski posegi pri odraslem pacientu"),
      ),
      body: const HomePage(),
    );
  }
}
