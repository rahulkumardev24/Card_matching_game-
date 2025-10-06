import 'package:card_match_memory/helper/app_color.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

@immutable
class NavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  const NavigationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClayContainer(
        borderRadius: 200,
        color: AppColor.secondaryColor,
        spread: 2,
        emboss: true,
        curveType: CurveType.convex,
        depth: 50,
        child: Icon(Icons.backspace_outlined, color: AppColor.lightText),
      ),
    );
  }
}
