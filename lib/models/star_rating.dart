import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int stars;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const StarRating({
    super.key,
    required this.stars,
    this.size = 32.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: index < stars ? activeColor : inactiveColor,
          size: size,
        );
      }),
    );
  }
}