import 'package:card_match_memory/setting_screen.dart';
import 'package:card_match_memory/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'level_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.purple.shade600],
          ),
        ),
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Icon(Icons.memory, size: 80, color: Colors.white),
                    const SizedBox(height: 20),
                    Text(
                      'Memorify',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Brain Challenge',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Train Your Memory • Improve Concentration',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Buttons
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LevelSelectionScreen(), // No parameters
                          ),
                        );
                      },
                      text: 'Start Game',
                      icon: Icons.play_arrow,
                    ),

                    GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      text: 'Settings',
                      icon: Icons.settings,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
