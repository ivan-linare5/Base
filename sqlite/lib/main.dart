import 'package:flutter/material.dart';
import 'package:sqlite/base.dart';
import 'package:sqlite/home.dart';

final dbHelper = DatabaseHelper();

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized(); //Inicializa los widgets

  await dbHelper.init(); // initialize the database

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
    );
  }
}
