// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/level_progress.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'memory_game.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Levels progress table
    await db.execute('''
      CREATE TABLE levels_progress (
        level INTEGER PRIMARY KEY,
        stars INTEGER DEFAULT 0,
        completed INTEGER DEFAULT 0,
        unlocked INTEGER DEFAULT 0,
        moves INTEGER DEFAULT 0,
        time INTEGER DEFAULT 0,
        completed_at TEXT
      )
    ''');

    // Challenges table (for future use)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS challenges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type INTEGER,
        title TEXT,
        description TEXT,
        time_limit INTEGER,
        max_moves INTEGER,
        grid_size INTEGER DEFAULT 4
      )
    ''');

    // Challenge results table (for future use)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS challenge_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        challenge_type INTEGER,
        score INTEGER,
        matches INTEGER,
        time_used INTEGER,
        moves_used INTEGER,
        completed_at TEXT
      )
    ''');
  }

  // Level progress methods
  Future<void> saveLevelProgress({
    required int level,
    required int stars,
    required bool completed,
    required bool unlocked,
    int moves = 0,
    int time = 0,
    String? completedAt,
  }) async {
    final db = await database;

    final levelProgress = LevelProgress(
      level: level,
      stars: stars,
      completed: completed,
      unlocked: unlocked,
      moves: moves,
      time: time,
      completedAt: completedAt != null ? DateTime.parse(completedAt) : null,
    );

    await db.insert(
      'levels_progress',
      levelProgress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LevelProgress?> getLevelProgressData(int level) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'levels_progress',
      where: 'level = ?',
      whereArgs: [level],
    );

    if (maps.isNotEmpty) {
      return LevelProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLevelProgress(int level) async {
    final progress = await getLevelProgressData(level);
    return progress?.toLegacyMap();
  }

  Future<List<LevelProgress>> getAllLevelsProgressData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('levels_progress');
    return maps.map((map) => LevelProgress.fromMap(map)).toList();
  }

  Future<Map<String, dynamic>> getAllLevelsProgress() async {
    final progressList = await getAllLevelsProgressData();
    Map<String, dynamic> result = {};

    for (var progress in progressList) {
      result[progress.level.toString()] = progress.toLegacyMap();
    }

    return result;
  }

  Future<void> resetAllProgress() async {
    final db = await database;
    await db.delete('levels_progress');
  }

  // Debug methods for testing
  Future<void> unlockAllLevels() async {
    final db = await database;
    final batch = db.batch();

    for (int i = 1; i <= 100; i++) {
      final progress = LevelProgress(
        level: i,
        stars: 3,
        completed: true,
        unlocked: true,
        completedAt: DateTime.now(),
      );
      batch.insert(
        'levels_progress',
        progress.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}