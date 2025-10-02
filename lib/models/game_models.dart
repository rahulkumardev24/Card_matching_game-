import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'gridSize': gridSize,
      'totalPairs': totalPairs,
      'timeLimit': timeLimit,
      'maxMoves': maxMoves,
      'difficulty': difficulty,
    };
  }

  factory GameLevel.fromMap(Map<String, dynamic> map) {
    return GameLevel(
      level: map['level'],
      gridSize: map['gridSize'],
      totalPairs: map['totalPairs'],
      timeLimit: map['timeLimit'],
      maxMoves: map['maxMoves'],
      difficulty: map['difficulty'],
    );
  }

  String toJson() => json.encode(toMap());
  factory GameLevel.fromJson(String source) => GameLevel.fromMap(json.decode(source));
}