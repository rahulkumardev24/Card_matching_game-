import 'dart:convert';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/level_generator.dart';
import '../../widgets/level_card.dart';
import '../helper/app_color.dart';
import '../widgets/level_and_star_card.dart';
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
    levels = LevelGenerator.generateLevels();
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

  int getCompletedLevelsCount() {
    return levelsProgress.values.where((level) {
      final completed = level['completed'];
      return completed == true;
    }).length;
  }

  // Calculate total stars earned
  int getTotalStars() {
    int total = 0;
    levelsProgress.forEach((key, value) {
      if (value['stars'] != null) {
        total += (value['stars'] as num).toInt();
      }
    });
    return total;
  }

  int getMaxStars() {
    return levels.length * 3;
  }

  @override
  Widget build(BuildContext context) {
    final completedLevels = getCompletedLevelsCount();
    final totalStars = getTotalStars();
    final maxStars = getMaxStars();

    return Scaffold(
      /// --- app bar --- ///
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: NavigationButton(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          'Select Level',
          style: AppTextStyle.titleSmall(fontFamily: "secondary"),
        ),
        centerTitle: true,
        backgroundColor: AppColor.secondaryColor,
      ),

      /// ------- Body ------- ///
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withOpacity(0.9),
              AppColor.secondaryColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            /// level and star card with REAL data
            LevelAndStarCard(
              completedLevels: completedLevels,
              totalLevels: levels.length,
              totalStars: totalStars,
              maxStars: maxStars,
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
}
