import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../models/game_models.dart';
import 'star_rating.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(8.sp),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Main Clay Container
            ClayContainer(
              borderRadius: 2.h,
              depth: 30,
              surfaceColor: AppColor.primaryColor,
              parentColor: isUnlocked
                  ? AppColor.primaryColor
                  : Colors.black.withValues(alpha: 0.80),
              spread: 2,
              curveType: CurveType.concave,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// Main Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// ---- Level Number ---- ///
                      ClayContainer(
                        width: 28.sp,
                        height: 28.sp,
                        borderRadius: 100,
                        spread: 2,
                        color: AppColor.primaryColor,
                        curveType: CurveType.concave,

                        child: Center(
                          /// --------- Level Number -------- ///
                          child: Text(
                            '${level.level}',
                            style: AppTextStyle.titleSmall(
                              color: AppColor.darkText,
                              weight: FontWeight.w500,
                              fontFamily: "secondary",
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      /// ---- Difficulty Badge ---- ///
                      ClayContainer(
                        borderRadius: 2.h,
                        depth: isUnlocked ? 20 : 10,
                        surfaceColor: isUnlocked
                            ? AppColor.primaryColor
                            : Colors.grey.shade400,
                        parentColor: AppColor.primaryColor,

                        spread: 2,
                        curveType: CurveType.concave,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2,
                          ),
                          child: Text(
                            level.difficulty.toUpperCase(),
                            style: AppTextStyle.subtitleSmall(
                              color: AppColor.darkText,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      /// ---- Grid Size ---- ///
                      Text(
                        '${level.gridSize}×${level.gridSize}',
                        style: AppTextStyle.subtitleSmall(
                          color: AppColor.darkText,
                          weight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      /// ---- Stars ---- ///
                      StarRating(
                        stars: starsEarned,
                        size: 18.sp,
                        activeColor: Colors.black,
                        inactiveColor: Colors.white,
                      ),
                    ],
                  ),

                  /// Lock Overlay
                  if (!isUnlocked)
                    ClayContainer(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 2.h,
                      depth: 40,
                      parentColor: Colors.black.withValues(alpha: 0.70),
                      surfaceColor: Colors.black.withValues(alpha: 0.85),
                      spread: 0,
                      curveType: CurveType.concave,

                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Shiny effect
                          Positioned(
                            top: -10.sp,
                            right: -20.sp,
                            child: Container(
                              width: 40.sp,
                              height: 40.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// --- Lock ----- ///
                              ClayContainer(
                                width: 28.sp,
                                height: 28.sp,
                                borderRadius: 100,

                                spread: 3,
                                color: AppColor.darkText.withValues(alpha: 0.9),
                                curveType: CurveType.concave,

                                child: Icon(
                                  Icons.lock,
                                  size: 24.sp,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 2.h),

                              /// Unlock Text
                              ClayContainer(
                                spread: 2,
                                color: AppColor.darkText.withValues(alpha: 0.9),
                                curveType: CurveType.concave,
                                emboss: true,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'LEVEL ${level.level - 1}',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.subtitleSmall(
                                      color: Colors.grey.shade300,
                                      weight: FontWeight.w700,
                                      size: 12,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),

                              /// Complete Text
                              Text(
                                'COMPLETE',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.subtitleSmall(
                                  color: AppColor.lightText,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
