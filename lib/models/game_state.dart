import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'moves': moves,
      'matches': matches,
      'timeElapsed': timeElapsed,
      'isCompleted': isCompleted,
    };
  }

  factory GameStats.fromMap(Map<String, dynamic> map) {
    return GameStats(
      moves: map['moves'] ?? 0,
      matches: map['matches'] ?? 0,
      timeElapsed: map['timeElapsed'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory GameStats.fromJson(String source) => GameStats.fromMap(json.decode(source));
}