import 'package:card_match_memory/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorify: Brain Challenge',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
