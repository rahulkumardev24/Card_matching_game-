import 'package:card_match_memory/screen/home_screen.dart';
import 'package:card_match_memory/screen/level_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Memorify: Brain Challenge',
          debugShowCheckedModeBanner: false,
          home: LevelSelectionScreen(),
        );
      },
    );
  }
}
