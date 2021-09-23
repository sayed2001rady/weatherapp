import 'package:flutter/material.dart';
import 'package:wheather/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Italianno'
      ),
      home: home_screen(),
    );
  }
}
