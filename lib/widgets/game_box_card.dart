import 'package:card_match_memory/helper/app_color.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../models/card_item.dart';

class GameBoxCard extends StatelessWidget {
  final CardItem card;
  final VoidCallback onTap;
  final bool isPreviewMode;
  final int? gridSize;

  const GameBoxCard({
    super.key,
    required this.card,
    required this.onTap,
    this.isPreviewMode = false,
    this.gridSize,
  });

  double _calculateIconSize() {
    if (gridSize == null) return 42.sp;
    if (gridSize! <= 3) {
      return 28.sp;
    } else if (gridSize! <= 4) {
      return 24.sp; // Medium
    } else if (gridSize! <= 5) {
      return 20.sp; // Normal
    } else if (gridSize! <= 6) {
      return 25.sp;
    } else {
      return 20.sp;
    }
  }

  double _calculateFontSize() {
    if (gridSize == null) return 18.sp;

    if (gridSize! <= 3) {
      return 32.sp;
    } else if (gridSize! <= 4) {
      return 28.sp;
    } else if (gridSize! <= 5) {
      return 24.sp;
    } else if (gridSize! <= 6) {
      return 20.sp;
    } else {
      return 30.sp;
    }
  }

  // Calculate border radius responsively
  double _calculateBorderRadius() {
    return 10.px;
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = _calculateIconSize();
    final fontSize = _calculateFontSize();
    final borderRadius = _calculateBorderRadius();
    return GestureDetector(
      onTap: isPreviewMode ? null : onTap,
      child: ClayContainer(
        color: AppColor.primaryColor,
        borderRadius: 9.px,
        depth: 50,
        spread: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: card.isFlipped || card.isMatched
                ? Colors.white
                : AppColor.primaryColor,
            borderRadius: BorderRadius.circular(borderRadius)),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: card.isFlipped || card.isMatched || isPreviewMode
                  ? Container(
                      margin: EdgeInsets.all(6.px),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          card.imagePath,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.question_mark_rounded,
                      color: AppColor.darkText,
                      size: iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
