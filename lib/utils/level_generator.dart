import 'package:card_match_memory/helper/app_constant.dart';

import '../models/game_models.dart';

class LevelGenerator {
  static List<GameLevel> generateLevels() {
    List<GameLevel> levels = [];

    /// Generate 100 level
    for (int i = 1; i <= 100; i++) {
      String difficulty;
      int gridSize;
      int timeLimit;
      int maxMoves;

      if (i <= 10) {
        /// --- Easy levels ---- ///
        difficulty = 'Easy';
        gridSize = i <= 3 ? 2 : 3;
        timeLimit = 20 + (i * 5);
        maxMoves = (gridSize * gridSize) + 5;
      } else if (i <= 50) {
        // Medium levels
        difficulty = 'Medium';
        gridSize = i <= 35 ? 4 : 5;
        timeLimit = 120 + ((i - 20) * 3);
        maxMoves = (gridSize * gridSize) + 3;
      } else if (i <= 80) {
        // Hard levels
        difficulty = 'Hard';
        gridSize = i <= 65 ? 6 : 7;
        timeLimit = 180 + ((i - 50) * 2);
        maxMoves = (gridSize * gridSize) + 2;
      } else {
        // Expert levels
        difficulty = 'Expert';
        gridSize = i <= 90 ? 8 : 9;
        timeLimit = 240 + ((i - 80) * 2);
        maxMoves = (gridSize * gridSize) + 1;
      }

      int totalPairs = (gridSize * gridSize) ~/ 2;

      levels.add(
        GameLevel(
          level: i,
          gridSize: gridSize,
          totalPairs: totalPairs,
          timeLimit: timeLimit,
          maxMoves: maxMoves,
          difficulty: difficulty,
        ),
      );
    }

    return levels;
  }

  static List<String> generateCardImages(int pairs) {
    List<String> images = [];

    for (int i = 0; i < pairs; i++) {
      String emoji = AppConstant.emojis[i % AppConstant.emojis.length];
      images.add(emoji);
      images.add(emoji);
    }

    images.shuffle();
    return images;
  }
}
