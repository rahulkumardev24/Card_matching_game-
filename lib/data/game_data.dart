// game_models.dart
import 'database_helper.dart';

class GameData {
  static const String _levelsKey = 'saved_levels_progress';
  static const String _currentLevelKey = 'current_level';

  // These methods will be updated to use SQLite
  static Future<void> saveLevelProgress(int level, int stars) async {
    final dbHelper = DatabaseHelper();

    // Save current level progress
    await dbHelper.saveLevelProgress(
      level: level,
      stars: stars,
      completed: true,
      unlocked: true,
      completedAt: DateTime.now().toIso8601String(),
    );

    // Unlock next level
    final nextLevel = level + 1;
    final nextLevelProgress = await dbHelper.getLevelProgress(nextLevel);
    if (nextLevelProgress == null) {
      await dbHelper.saveLevelProgress(
        level: nextLevel,
        stars: 0,
        completed: false,
        unlocked: true,
      );
    }
  }

  static Future<Map<String, dynamic>> getLevelProgress(int level) async {
    final dbHelper = DatabaseHelper();
    final progress = await dbHelper.getLevelProgress(level);

    if (progress != null) {
      return progress;
    }

    // First level is always unlocked
    return {
      'stars': 0,
      'completed': false,
      'unlocked': level == 1,
      'moves': 0,
      'time': 0,
      'completedAt': null,
    };
  }

  static Future<Map<String, dynamic>> getAllLevelsProgress() async {
    final dbHelper = DatabaseHelper();
    final progress = await dbHelper.getAllLevelsProgress();

    if (progress.isNotEmpty) {
      return progress;
    }

    // Initialize with level 1 unlocked
    await dbHelper.saveLevelProgress(
      level: 1,
      stars: 0,
      completed: false,
      unlocked: true,
    );

    return {
      '1': {'stars': 0, 'completed': false, 'unlocked': true},
    };
  }

  static Future<void> resetAllProgress() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.resetAllProgress();
  }
}
