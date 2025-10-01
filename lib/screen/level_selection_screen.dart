import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/level_generator.dart';
import '../../widgets/level_card.dart';
import 'game_screen.dart';
import '../models/game_models.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  List<GameLevel> levels = [];
  Map<String, dynamic> levelsProgress = {};

  @override
  void initState() {
    super.initState();
    levels = LevelGenerator.generateLevels(); // Generate levels internally
    loadLevelsProgress();
  }

  Future<void> loadLevelsProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('levels_progress');

    setState(() {
      if (savedData != null) {
        levelsProgress = Map<String, dynamic>.from(json.decode(savedData));
      } else {
        // Initialize with level 1 unlocked
        levelsProgress = {
          '1': {'stars': 0, 'completed': false, 'unlocked': true},
        };
      }
    });
  }

  bool isLevelUnlocked(int levelNumber) {
    final levelData = levelsProgress[levelNumber.toString()];
    return levelData != null &&
        (levelData['unlocked'] == true || levelData['completed'] == true);
  }

  int getStarsEarned(int levelNumber) {
    final levelData = levelsProgress[levelNumber.toString()];
    if (levelData != null && levelData['stars'] != null) {
      return (levelData['stars'] as num).toInt();
    }
    return 0;
  }

  void refreshLevels() {
    loadLevelsProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// --- app bar --- ///
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshLevels,
            tooltip: 'Refresh Progress',
          ),
        ],
      ),

      /// ------- Body ------- ///
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: Column(
          children: [
            /// level and star
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressItem(
                    'Levels',
                    '${_getCompletedLevelsCount()}/100',
                  ),
                  _buildProgressItem('Total Stars', '${_getTotalStars()}/300'),
                ],
              ),
            ),

            /// ------- Levels Grid (Level) ------ ///
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final isUnlocked = isLevelUnlocked(level.level);
                  final starsEarned = getStarsEarned(level.level);
                  return LevelCard(
                    level: level,
                    isUnlocked: isUnlocked,
                    starsEarned: starsEarned,
                    onTap: isUnlocked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameScreen(
                                  level: level,
                                  onLevelComplete: refreshLevels,
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  int _getCompletedLevelsCount() {
    return levelsProgress.values.where((level) {
      final completed = level['completed'];
      return completed == true;
    }).length;
  }

  int _getTotalStars() {
    int total = 0;
    levelsProgress.forEach((key, value) {
      if (value['stars'] != null) {
        total += (value['stars'] as num).toInt();
      }
    });
    return total;
  }
}
