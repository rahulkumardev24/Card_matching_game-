import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  static const String _levelsKey = 'saved_levels_progress';
  static const String _currentLevelKey = 'current_level';

  // Save level progress
  static Future<void> saveLevelProgress(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();

    // Get current saved progress
    final String? savedData = prefs.getString(_levelsKey);
    Map<String, dynamic> levelsProgress = {};

    if (savedData != null) {
      levelsProgress = Map<String, dynamic>.from(json.decode(savedData));
    }

    // Update progress for this level
    levelsProgress[level.toString()] = {
      'stars': stars,
      'completed': true,
      'completedAt': DateTime.now().toIso8601String(),
    };

    // Save updated progress
    await prefs.setString(_levelsKey, json.encode(levelsProgress));

    // Unlock next level if it exists
    final nextLevel = level + 1;
    if (!levelsProgress.containsKey(nextLevel.toString())) {
      levelsProgress[nextLevel.toString()] = {
        'stars': 0,
        'completed': false,
        'unlocked': true,
      };
    }

    await prefs.setString(_levelsKey, json.encode(levelsProgress));
  }

  // Get level progress
  static Future<Map<String, dynamic>> getLevelProgress(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_levelsKey);

    if (savedData != null) {
      final Map<String, dynamic> levelsProgress = Map<String, dynamic>.from(json.decode(savedData));
      return levelsProgress[level.toString()] ?? {'stars': 0, 'completed': false, 'unlocked': level == 1};
    }

    // First level is always unlocked
    return {'stars': 0, 'completed': false, 'unlocked': level == 1};
  }

  // Get all levels progress
  static Future<Map<String, dynamic>> getAllLevelsProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_levelsKey);

    if (savedData != null) {
      return Map<String, dynamic>.from(json.decode(savedData));
    }

    // Initialize with level 1 unlocked
    return {
      '1': {'stars': 0, 'completed': false, 'unlocked': true}
    };
  }

  // Reset all progress
  static Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_levelsKey);
  }
}