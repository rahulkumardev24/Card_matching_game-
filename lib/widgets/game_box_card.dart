import 'dart:math';
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
  final double screenWidth;

  const GameBoxCard({
    super.key,
    required this.card,
    required this.onTap,
    this.isPreviewMode = false,
    this.gridSize,
    required this.screenWidth,
  });

  double _calculateIconSize() {
    if (gridSize == null) return screenWidth > 600 ? 36.sp : 42.sp;
    if (gridSize! <= 3) return screenWidth > 600 ? 32.sp : 28.sp;
    if (gridSize! <= 4) return screenWidth > 600 ? 28.sp : 24.sp;
    if (gridSize! <= 5) return screenWidth > 600 ? 24.sp : 20.sp;
    if (gridSize! <= 6) return screenWidth > 600 ? 22.sp : 25.sp;
    return 20.sp;
  }

  double _calculateFontSize() {
    if (gridSize == null) return screenWidth > 600 ? 22.sp : 18.sp;
    if (gridSize! <= 3) return screenWidth > 600 ? 36.sp : 32.sp;
    if (gridSize! <= 4) return screenWidth > 600 ? 32.sp : 28.sp;
    if (gridSize! <= 5) return screenWidth > 600 ? 28.sp : 24.sp;
    if (gridSize! <= 6) return screenWidth > 600 ? 24.sp : 20.sp;
    return screenWidth > 600 ? 26.sp : 30.sp;
  }

  double _calculateBorderRadius() => screenWidth > 600 ? 12.px : 10.px;

  @override
  Widget build(BuildContext context) {
    final iconSize = _calculateIconSize();
    final fontSize = _calculateFontSize();
    final borderRadius = _calculateBorderRadius();

    return GestureDetector(
      onTap: isPreviewMode ? null : onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(card.isFlipped) != child!.key);
              var tilt = (animation.value - 0.5).abs() - 0.5;
              tilt *= isUnder ? -0.003 : 0.003;
              return Transform(
                transform: Matrix4.rotationY(rotate.value)
                  ..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },

        // ✅ Back and Front Card container dono
        child: card.isFlipped || card.isMatched || isPreviewMode
            ? _buildFrontCard(fontSize, borderRadius)
            : _buildBackCard(iconSize, borderRadius),
      ),
    );
  }

  Widget _buildFrontCard(double fontSize, double borderRadius) {
    return ClayContainer(
      key: const ValueKey(true),
      color: Colors.white,
      borderRadius: borderRadius,
      depth: 20,
      spread: 1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(6.px),
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
        ),
      ),
    );
  }

  Widget _buildBackCard(double iconSize, double borderRadius) {
    return ClayContainer(
      key: const ValueKey(false),
      color: AppColor.primaryColor,
      borderRadius: borderRadius,
      depth: 50,
      spread: 1,
      child: Center(
        child: Icon(
          Icons.question_mark_rounded,
          color: AppColor.darkText,
          size: iconSize,
        ),
      ),
    );
  }
}
