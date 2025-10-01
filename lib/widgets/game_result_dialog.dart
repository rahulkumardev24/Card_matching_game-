import 'package:flutter/material.dart';

import '../models/game_models.dart';
import '../models/star_rating.dart';

class GameResultDialog extends StatelessWidget {
  final bool isWin;
  final GameLevel level;
  final int moves;
  final int timeElapsed;
  final int stars;
  final VoidCallback? onNextLevel;
  final VoidCallback onRetry;
  final VoidCallback onLevelSelect;

  const GameResultDialog({
    super.key,
    required this.isWin,
    required this.level,
    required this.moves,
    required this.timeElapsed,
    required this.stars,
    this.onNextLevel,
    required this.onRetry,
    required this.onLevelSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isWin ? Icons.celebration : Icons.timer_off,
              size: 64,
              color: isWin ? Colors.green : Colors.orange,
            ),

            const SizedBox(height: 16),

            Text(
              isWin ? '🎉 Level Completed! 🎉' : 'Time\'s Up!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            if (isWin) StarRating(stars: stars),

            if (isWin) const SizedBox(height: 16),

            // Performance Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatRow('Level', '${level.level} (${level.difficulty})'),
                  _buildStatRow('Time', '$timeElapsed/${level.timeLimit}s'),
                  _buildStatRow('Moves', '$moves/${level.maxMoves}'),
                  if (isWin) _buildStatRow('Stars', '$stars/3'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLevelSelect,
                    child: const Text('Levels'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ),
                if (onNextLevel != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onNextLevel,
                      child: const Text('Next Level'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}