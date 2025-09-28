class GameLevel {
  final int level;
  final int gridSize;
  final int totalPairs;
  final int timeLimit;
  final int maxMoves;
  final String difficulty;

  GameLevel({
    required this.level,
    required this.gridSize,
    required this.totalPairs,
    required this.timeLimit,
    required this.maxMoves,
    required this.difficulty,
  });
}

class GameStats {
  int moves;
  int matches;
  int timeElapsed;
  bool isCompleted;

  GameStats({
    this.moves = 0,
    this.matches = 0,
    this.timeElapsed = 0,
    this.isCompleted = false,
  });
}

class CardItem {
  final int id;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}