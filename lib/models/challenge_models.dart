enum ChallengeType {
  timeAttack,
  moveLimit,
  survival,
  daily,
}

class Challenge {
  final ChallengeType type;
  final String title;
  final String description;
  final int? timeLimit;
  final int? maxMoves;
  final int gridSize;

  Challenge({
    required this.type,
    required this.title,
    required this.description,
    this.timeLimit,
    this.maxMoves,
    this.gridSize = 4,
  });
}

class ChallengeResult {
  final ChallengeType challengeType;
  final int score;
  final int matches;
  final int timeUsed;
  final int movesUsed;
  final DateTime completedAt;

  ChallengeResult({
    required this.challengeType,
    required this.score,
    required this.matches,
    required this.timeUsed,
    required this.movesUsed,
    required this.completedAt,
  });
}