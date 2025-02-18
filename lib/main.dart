import 'package:canzi/screens/hero.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0xffffc2c2),
          selectionHandleColor: Color(0xffff0000),
        ),
      ),
      home: const CanziHero(),
    );
  }
}

