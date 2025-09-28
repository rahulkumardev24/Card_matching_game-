import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../models/star_rating.dart';

class LevelCard extends StatelessWidget {
  final GameLevel level;
  final bool isUnlocked;
  final int starsEarned;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.starsEarned,
    this.onTap,
  });

  Color getDifficultyColor() {
    switch (level.difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      case 'Expert':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isUnlocked ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: isUnlocked
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getDifficultyColor().withOpacity(0.1),
                getDifficultyColor().withOpacity(0.3),
              ],
            )
                : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade400,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: isUnlocked
                ? Border.all(color: getDifficultyColor().withOpacity(0.5), width: 2)
                : null,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${level.level}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level.difficulty,
                    style: TextStyle(
                      fontSize: 10,
                      color: isUnlocked ? getDifficultyColor() : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${level.gridSize}x${level.gridSize}',
                    style: TextStyle(
                      fontSize: 9,
                      color: isUnlocked ? Colors.grey : Colors.grey.shade500,
                    ),
                  ),

                  if (starsEarned > 0) ...[
                    const SizedBox(height: 8),
                    StarRating(stars: starsEarned, size: 14),
                  ],
                ],
              ),

              if (!isUnlocked)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete\nLevel ${level.level - 1}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}