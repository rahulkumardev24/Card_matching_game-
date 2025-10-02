// Level Progress Model for SQLite
import 'dart:convert';

class LevelProgress {
  final int level;
  final int stars;
  final bool completed;
  final bool unlocked;
  final int moves;
  final int time;
  final DateTime? completedAt;

  LevelProgress({
    required this.level,
    required this.stars,
    required this.completed,
    required this.unlocked,
    this.moves = 0,
    this.time = 0,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'stars': stars,
      'completed': completed ? 1 : 0,
      'unlocked': unlocked ? 1 : 0,
      'moves': moves,
      'time': time,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory LevelProgress.fromMap(Map<String, dynamic> map) {
    return LevelProgress(
      level: map['level'],
      stars: map['stars'],
      completed: map['completed'] == 1,
      unlocked: map['unlocked'] == 1,
      moves: map['moves'] ?? 0,
      time: map['time'] ?? 0,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory LevelProgress.fromJson(String source) => LevelProgress.fromMap(json.decode(source));

  Map<String, dynamic> toLegacyMap() {
    return {
      'stars': stars,
      'completed': completed,
      'unlocked': unlocked,
      'moves': moves,
      'time': time,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}