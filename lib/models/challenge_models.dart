import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'maxMoves': maxMoves,
      'gridSize': gridSize,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      type: ChallengeType.values[map['type']],
      title: map['title'],
      description: map['description'],
      timeLimit: map['timeLimit'],
      maxMoves: map['maxMoves'],
      gridSize: map['gridSize'] ?? 4,
    );
  }

  String toJson() => json.encode(toMap());
  factory Challenge.fromJson(String source) => Challenge.fromMap(json.decode(source));
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

  Map<String, dynamic> toMap() {
    return {
      'challengeType': challengeType.index,
      'score': score,
      'matches': matches,
      'timeUsed': timeUsed,
      'movesUsed': movesUsed,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory ChallengeResult.fromMap(Map<String, dynamic> map) {
    return ChallengeResult(
      challengeType: ChallengeType.values[map['challengeType']],
      score: map['score'],
      matches: map['matches'],
      timeUsed: map['timeUsed'],
      movesUsed: map['movesUsed'],
      completedAt: DateTime.parse(map['completedAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory ChallengeResult.fromJson(String source) => ChallengeResult.fromMap(json.decode(source));
}