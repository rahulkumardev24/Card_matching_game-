import 'dart:async';
import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/widgets/game_box_card.dart';
import 'package:card_match_memory/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/level_generator.dart';
import '../../widgets/game_stats.dart';
import '../data/database_helper.dart';
import '../models/card_item.dart';
import '../models/game_models.dart';
import '../widgets/game_result_dialog.dart';

class GameScreen extends StatefulWidget {
  final GameLevel level;
  final VoidCallback? onLevelComplete;

  const GameScreen({super.key, required this.level, this.onLevelComplete});

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
  Timer? gameTimer;
  Timer? previewTimer;
  late ConfettiController confettiController;
  int starsEarned = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    initializeGame();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    startPreview();
  }

  @override
  void dispose() {
    _isDisposed = true;
    gameTimer?.cancel();
    previewTimer?.cancel();
    confettiController.dispose();
    super.dispose();
  }

  void initializeGame() {
    List<String> cardImages = LevelGenerator.generateCardImages(
      widget.level.totalPairs,
    );

    cards = List.generate(
      cardImages.length,
      (index) =>
          CardItem(id: index, imagePath: cardImages[index], isFlipped: true),
    );
  }

  int getPreviewDuration() {
    if (widget.level.level >= 1 && widget.level.level <= 10) {
      return 800;
    } else if (widget.level.level >= 11 && widget.level.level <= 20) {
      return 1300;
    } else if (widget.level.level >= 21 && widget.level.level <= 50) {
      return 1800;
    } else if (widget.level.level >= 51 && widget.level.level <= 80) {
      return 2300;
    } else if (widget.level.level >= 81 && widget.level.level <= 100) {
      return 2500;
    }
    return 3000;
  }

  void startPreview() {
    previewTimer = Timer(Duration(milliseconds: getPreviewDuration()), () {
      if (_isDisposed) return;

      _safeSetState(() {
        isPreviewMode = false;
        for (var card in cards) {
          card.isFlipped = false;
        }
      });
      startTimer();
    });
  }

  void startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (!isGameOver && !isPreviewMode) {
        _safeSetState(() {
          timeElapsed++;
        });

        // Check if time limit exceeded
        if (timeElapsed >= widget.level.timeLimit) {
          gameOver(false);
        }
      }
    });
  }

  void _safeSetState(VoidCallback callback) {
    if (!_isDisposed && mounted) {
      setState(callback);
    }
  }

  void onCardTap(int index) {
    if (isPreviewMode ||
        isGameOver ||
        cards[index].isFlipped ||
        cards[index].isMatched ||
        (firstSelectedIndex != null && secondSelectedIndex != null)) {
      return;
    }

    _safeSetState(() {
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
      _safeSetState(() {
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        matches++;
      });

      // Check if level completed
      if (matches == widget.level.totalPairs) {
        calculateStars();
        gameOver(true);
      }

      resetSelection();
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (_isDisposed) return;

        _safeSetState(() {
          firstCard.isFlipped = false;
          secondCard.isFlipped = false;
          resetSelection();
        });
      });
    }

    // 🎯 MOVES LIMIT CHECK - Game over if exceeds max moves
    if (moves >= widget.level.maxMoves && matches < widget.level.totalPairs) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_isDisposed) {
          gameOver(false);
        }
      });
    }
  }

  void calculateStars() {
    double performanceScore = 0;

    // Time performance (50% weight)
    double timeScore =
        (widget.level.timeLimit - timeElapsed) / widget.level.timeLimit;
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
    final dbHelper = DatabaseHelper();

    // Save current level progress
    await dbHelper.saveLevelProgress(
      level: widget.level.level,
      stars: starsEarned,
      completed: true,
      unlocked: true,
      moves: moves,
      time: timeElapsed,
      completedAt: DateTime.now().toIso8601String(),
    );

    // Unlock next level
    final nextLevel = widget.level.level + 1;
    if (nextLevel <= 100) {
      final nextLevelProgress = await dbHelper.getLevelProgress(nextLevel);
      if (nextLevelProgress == null) {
        await dbHelper.saveLevelProgress(
          level: nextLevel,
          stars: 0,
          completed: false,
          unlocked: true,
        );
      }
    }
  }

  void gameOver(bool isWin) {
    if (_isDisposed) return;

    _safeSetState(() {
      isGameOver = true;
    });
    gameTimer?.cancel();

    if (isWin) {
      confettiController.play();
      saveLevelProgress().then((_) {
        if (!_isDisposed && widget.onLevelComplete != null) {
          widget.onLevelComplete!();
        }
      });
    }

    if (!_isDisposed && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GameResultDialog(
          isWin: isWin,
          level: widget.level,
          moves: moves,
          timeElapsed: timeElapsed,
          stars: starsEarned,
          onNextLevel: isWin
              ? () {
                  Navigator.pop(context);
                  navigateToNextLevel();
                }
              : null,
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
  }

  void navigateToNextLevel() {
    if (_isDisposed) return;

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
      if (!_isDisposed && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🎉 Congratulations! 🎉'),
            content: const Text(
              'You have completed all 100 levels! You are a true Memory Master!',
            ),
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
  }

  void restartGame() {
    if (_isDisposed) return;

    gameTimer?.cancel();
    previewTimer?.cancel();

    _safeSetState(() {
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

  // Calculate optimal grid columns based on level and screen size
  int calculateGridColumns() {
    // For lower levels (1-20), use fixed grid size
    if (widget.level.level <= 20) {
      return widget.level.gridSize;
    }

    // For higher levels, calculate based on card count for better sizing
    final totalCards = widget.level.totalPairs * 2;

    // Calculate approximate columns to maintain reasonable card size
    if (totalCards <= 12) return 3;
    if (totalCards <= 20) return 4;
    if (totalCards <= 30) return 5;
    if (totalCards <= 42) return 6;
    if (totalCards <= 56) return 7;
    return 8; // Maximum columns for very high levels
  }

  @override
  Widget build(BuildContext context) {
    final gridColumns = calculateGridColumns();
    return Scaffold(
      /// ------- App bar ------ ///
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: NavigationButton(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColor.secondaryColor,
        title: Text(
          'Level ${widget.level.level} - ${widget.level.difficulty}',
          style: AppTextStyle.titleSmall(
            color: Colors.white,
            fontFamily: "secondary",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColor.lightText),
            onPressed: restartGame,
          ),
        ],
      ),
      backgroundColor: AppColor.primaryColor,
      body: Column(
        children: [
          /// Game Stats
          GameStatsWidget(
            moves: moves,
            matches: matches,
            timeElapsed: timeElapsed,
            level: widget.level,
          ),

          /*    // Preview Indicator
          if (isPreviewMode) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
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
          ],*/

          /// ------- Cards Grid ---- ///
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(6.0).copyWith(top: 2.h),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) => GameBoxCard(
                  card: cards[index],
                  onTap: () => onCardTap(index),
                  isPreviewMode: isPreviewMode,
                  gridSize: gridColumns,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
