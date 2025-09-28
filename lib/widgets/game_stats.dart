import 'package:flutter/material.dart';

import '../models/game_models.dart';

class GameStatsWidget extends StatelessWidget {
  final int moves;
  final int matches;
  final int timeElapsed;
  final GameLevel level;

  const GameStatsWidget({
    super.key,
    required this.moves,
    required this.matches,
    required this.timeElapsed,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.timer, 'Time', '$timeElapsed/${level.timeLimit}s'),
          _buildStatItem(Icons.swap_horiz, 'Moves', '$moves/${level.maxMoves}'),
          _buildStatItem(Icons.check_circle, 'Matches', '$matches/${level.totalPairs}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}