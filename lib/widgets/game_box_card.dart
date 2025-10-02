import 'package:flutter/material.dart';

import '../models/card_item.dart';
import '../models/game_models.dart';

class GameBoxCard extends StatelessWidget {
  final CardItem card;
  final VoidCallback onTap;
  final bool isPreviewMode;

  const GameBoxCard({
    super.key,
    required this.card,
    required this.onTap,
    this.isPreviewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPreviewMode ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched
              ? Colors.white
              : Colors.blue.shade600,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: card.isMatched
              ? Border.all(color: Colors.green, width: 3)
              : isPreviewMode
              ? Border.all(color: Colors.orange, width: 2)
              : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: card.isFlipped || card.isMatched || isPreviewMode
                ? Text(
              card.imagePath,
              style: const TextStyle(fontSize: 24),
            )
                : Icon(
              Icons.question_mark,
              color: Colors.white.withValues(alpha: 0.8),
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}