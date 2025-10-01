import 'dart:async';
import 'dart:convert';
import 'package:card_match_memory/widgets/game_box_card.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/level_generator.dart';
import '../../widgets/game_stats.dart';
import '../models/game_models.dart';
import '../widgets/game_result_dialog.dart';

class GameScreen extends StatefulWidget {
  final GameLevel level;
  final VoidCallback? onLevelComplete;

  const GameScreen({
    super.key,
    required this.level,
    this.onLevelComplete,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<CardItem> cards;
  int? firstSelectedIndex;
  int? secondSelectedIndex;
  int moves = 0;
  int matches = 0;
  int timeElapsed = 0;
  bool isGameOver = false;
  bool isPreviewMode = true;
  late Timer gameTimer;
  late Timer previewTimer;
  late ConfettiController confettiController;
  int starsEarned = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
    confettiController = ConfettiController(duration: const Duration(seconds: 5));
    startPreview();
  }

  @override
  void dispose() {
    gameTimer.cancel();
    previewTimer.cancel();
    confettiController.dispose();
    super.dispose();
  }

  void initializeGame() {
    List<String> cardImages = LevelGenerator.generateCardImages(widget.level.totalPairs);

    cards = List.generate(
      cardImages.length,
          (index) => CardItem(
        id: index,
        imagePath: cardImages[index],
        isFlipped: true,
      ),
    );
  }

  void startPreview() {
    // Show all cards for 3 seconds
    previewTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        isPreviewMode = false;
        // Flip all cards back
        for (var card in cards) {
          card.isFlipped = false;
        }
      });
      startTimer();
    });
  }

  void startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameOver && !isPreviewMode) {
        setState(() {
          timeElapsed++;
        });

        // Check if time limit exceeded
        if (timeElapsed >= widget.level.timeLimit) {
          gameOver(false);
        }
      }
    });
  }

  void onCardTap(int index) {
    if (isPreviewMode || isGameOver ||
        cards[index].isFlipped ||
        cards[index].isMatched ||
        (firstSelectedIndex != null && secondSelectedIndex != null)) {
      return;
    }

    setState(() {
      cards[index].isFlipped = true;

      if (firstSelectedIndex == null) {
        firstSelectedIndex = index;
      } else {
        secondSelectedIndex = index;
        moves++;
        checkForMatch();
      }
    });
  }

  void checkForMatch() {
    final firstCard = cards[firstSelectedIndex!];
    final secondCard = cards[secondSelectedIndex!];

    if (firstCard.imagePath == secondCard.imagePath) {
      // Match found
      setState(() {
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        matches++;
      });

      if (matches == widget.level.totalPairs) {
        calculateStars();
        gameOver(true);
      }

      resetSelection();
    } else {
      // No match
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          firstCard.isFlipped = false;
          secondCard.isFlipped = false;
          resetSelection();
        });
      });
    }
  }

  void calculateStars() {
    // Calculate stars based on performance
    double performanceScore = 0;

    // Time performance (50% weight)
    double timeScore = (widget.level.timeLimit - timeElapsed) / widget.level.timeLimit;
    timeScore = timeScore.clamp(0.0, 1.0);

    // Moves performance (50% weight)
    double movesScore = (widget.level.maxMoves - moves) / widget.level.maxMoves;
    movesScore = movesScore.clamp(0.0, 1.0);

    performanceScore = (timeScore * 0.5) + (movesScore * 0.5);

    if (performanceScore >= 0.8) {
      starsEarned = 3;
    } else if (performanceScore >= 0.5) {
      starsEarned = 2;
    } else {
      starsEarned = 1;
    }
  }

  void resetSelection() {
    firstSelectedIndex = null;
    secondSelectedIndex = null;
  }

  Future<void> saveLevelProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Get current saved progress
    final String? savedData = prefs.getString('levels_progress');
    Map<String, dynamic> levelsProgress = {};

    if (savedData != null) {
      levelsProgress = Map<String, dynamic>.from(json.decode(savedData));
    }

    // Update progress for this level
    levelsProgress[widget.level.level.toString()] = {
      'stars': starsEarned,
      'completed': true,
      'completedAt': DateTime.now().toIso8601String(),
      'moves': moves,
      'time': timeElapsed,
    };

    // Unlock next level
    final nextLevel = widget.level.level + 1;
    if (nextLevel <= 100) {
      levelsProgress[nextLevel.toString()] = {
        'stars': 0,
        'completed': false,
        'unlocked': true,
      };
    }

    // Save updated progress
    await prefs.setString('levels_progress', json.encode(levelsProgress));
  }

  void gameOver(bool isWin) {
    setState(() {
      isGameOver = true;
    });
    gameTimer.cancel();

    if (isWin) {
      confettiController.play();
      saveLevelProgress().then((_) {
        if (widget.onLevelComplete != null) {
          widget.onLevelComplete!();
        }
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameResultDialog(
        isWin: isWin,
        level: widget.level,
        moves: moves,
        timeElapsed: timeElapsed,
        stars: starsEarned,
        onNextLevel: isWin ? () {
          Navigator.pop(context);
          navigateToNextLevel();
        } : null,
        onRetry: () {
          Navigator.pop(context);
          restartGame();
        },
        onLevelSelect: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void navigateToNextLevel() {
    final nextLevelNumber = widget.level.level + 1;
    if (nextLevelNumber <= 100) {
      final nextLevel = LevelGenerator.generateLevels().firstWhere(
            (level) => level.level == nextLevelNumber,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            level: nextLevel,
            onLevelComplete: widget.onLevelComplete,
          ),
        ),
      );
    } else {
      // All levels completed
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎉 Congratulations! 🎉'),
          content: const Text('You have completed all 100 levels! You are a true Memory Master!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void restartGame() {
    setState(() {
      initializeGame();
      moves = 0;
      matches = 0;
      timeElapsed = 0;
      isGameOver = false;
      isPreviewMode = true;
      starsEarned = 0;
      resetSelection();
    });
    startPreview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ------- App bar ------ ///
      appBar: AppBar(
        title: Text('Level ${widget.level.level} - ${widget.level.difficulty}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: restartGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade50,
                  Colors.purple.shade50,
                ],
              ),
            ),
            child: Column(
              children: [
                /// Game Stats
                GameStatsWidget(
                  moves: moves,
                  matches: matches,
                  timeElapsed: timeElapsed,
                  level: widget.level,
                ),

                // Preview Indicator
                if (isPreviewMode) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility, color: Colors.orange, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          'Memorize the cards!',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                /// ------- Cards Grid ---- ///
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.level.gridSize,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) => GameBoxCard(
                        card: cards[index],
                        onTap: () => onCardTap(index),
                        isPreviewMode: isPreviewMode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

