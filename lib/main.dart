import 'package:barterit/screens/main/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const mainApp());
}

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barter IT',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        fontFamily: 'Roboto',
      ),
      home: const splashScreen(),
    );
  }
}
