import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/helper/responsive_helper.dart';
import 'package:card_match_memory/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import '../../utils/level_generator.dart';
import '../../widgets/level_card.dart';
import '../data/database_helper.dart';
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

  /// In LevelSelectionScreen class
  Future<void> loadLevelsProgress() async {
    final dbHelper = DatabaseHelper();
    final progress = await dbHelper.getAllLevelsProgress();

    setState(() {
      levelsProgress = progress;

      // Ensure level 1 is always unlocked if no progress exists
      if (levelsProgress.isEmpty || !levelsProgress.containsKey('1')) {
        levelsProgress = {
          '1': {'stars': 0, 'completed': false, 'unlocked': true},
        };
      }
    });
  }

  /// 🔧 DEBUG METHOD: Unlock all levels
  Future<void> unlockAllLevels() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.unlockAllLevels();
    loadLevelsProgress();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All levels unlocked!',
          style: AppTextStyle.subtitleMedium(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 🔧 DEBUG METHOD: Reset all progress
  Future<void> resetAllProgress() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.resetAllProgress();
    loadLevelsProgress(); // Refresh the state

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Progress reset!', style: AppTextStyle.subtitleMedium()),
        backgroundColor: Colors.orange,
      ),
    );
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
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
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
        actions: [
          /* // Debug menu for testing
          PopupMenuButton<String>(
            icon: Icon(Icons.bug_report, color: Colors.white),
            onSelected: (value) {
              if (value == 'unlock_all') {
                unlockAllLevels();
              } else if (value == 'reset_all') {
                resetAllProgress();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'unlock_all',
                child: Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Unlock All Levels'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'reset_all',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Reset All Progress'),
                  ],
                ),
              ),
            ],
          ),*/
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withValues(alpha: 0.9),
              AppColor.secondaryColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            LevelAndStarCard(
              completedLevels: completedLevels,
              totalLevels: levels.length,
              totalStars: totalStars,
              maxStars: maxStars,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 4 : 3,
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
