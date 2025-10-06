import 'package:card_match_memory/helper/responsive_helper.dart';
import 'package:clay_containers/constants.dart';
import 'package:flutter/material.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../helper/app_color.dart';

class LevelAndStarCard extends StatelessWidget {
  final int completedLevels;
  final int totalLevels;
  final int totalStars;
  final int maxStars;

  const LevelAndStarCard({
    super.key,
    required this.completedLevels,
    required this.totalLevels,
    required this.totalStars,
    required this.maxStars,
  });

  @override
  Widget build(BuildContext context) {
    double levelsProgress = totalLevels > 0 ? completedLevels / totalLevels : 0;
    double starsProgress = maxStars > 0 ? totalStars / maxStars : 0;
    final width = ResponsiveHelper.screenWidth(context);
    final height = ResponsiveHelper.screenHeight(context);

    return Container(
      width: width,
      height: height * 0.2,
      color: AppColor.secondaryColor,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildProgressItem(
              icon: Icons.flag_circle_rounded,
              title: 'Levels',
              value: '$completedLevels',
              total: '$totalLevels',
              progress: levelsProgress,
              color: const Color(0xFF4CAF50),
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
            ),
            _buildVerticalDivider(),
            _buildProgressItem(
              icon: Icons.star_rate_rounded,
              title: 'Total Stars',
              value: '$totalStars',
              total: '$maxStars',
              progress: starsProgress,
              color: const Color(0xFFFFD700),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFEB3B)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2,
      height: 12.h,
      decoration: BoxDecoration(
        color: AppColor.lightText.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String title,
    required String value,
    required String total,
    required double progress,
    required Color color,
    required Gradient gradient,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClayContainer(
            width: 30.sp,
            height: 30.sp,
            borderRadius: 200,
            spread: 2,
            color: color,
            parentColor: Colors.black,
            curveType: CurveType.convex,
            depth: 80,

            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),

          SizedBox(height: 12.sp),

          // Title
          Text(
            title,
            style: AppTextStyle.subtitleMedium(
              color: AppColor.darkText,
              weight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),

          SizedBox(height: 1.h),

          // Progress numbers
          ClayContainer(
            width: 33.w,
            borderRadius: 20,
            depth: 70,
            surfaceColor: AppColor.secondaryColor,
            parentColor: AppColor.secondaryColor,
            spread: 2,
            curveType: CurveType.concave,

            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '$value/$total',
                  style: AppTextStyle.titleSmall(
                    color: Colors.white,
                    size: 18,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          Container(
            width: 30.w,
            height: 12.sp,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  width: 30.w * progress,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Progress percentage text
                Positioned(
                  right: 8,
                  top: -12.sp,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyle.titleSmall(
                      color: Colors.white,
                      size: 10,
                      weight: FontWeight.w700,
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
