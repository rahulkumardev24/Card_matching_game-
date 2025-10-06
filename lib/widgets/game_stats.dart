import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(color: AppColor.secondaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_buildTimeStat(), _buildMovesStat(), _buildMatchesStat()],
      ),
    );
  }

  Widget _buildTimeStat() {
    double timeProgress = timeElapsed / level.timeLimit;
    if (timeProgress > 1.0) timeProgress = 1.0;

    return _buildStatItem(
      'Time',
      '$timeElapsed',
      '${level.timeLimit}s',
      timeProgress,
      AppColor.primaryColor,
    );
  }

  Widget _buildMovesStat() {
    double movesProgress = moves / level.maxMoves;
    if (movesProgress > 1.0) movesProgress = 1.0;

    return _buildStatItem(
      'Moves',
      '$moves',
      '${level.maxMoves}',
      movesProgress,
      Colors.lightBlueAccent,
    );
  }

  Widget _buildMatchesStat() {
    double matchesProgress = matches / level.totalPairs;
    if (matchesProgress > 1.0) matchesProgress = 1.0;

    return _buildStatItem(
      'Matches',
      '$matches',
      '${level.totalPairs}',
      matchesProgress,
      Colors.lightGreenAccent.shade700,
    );
  }

  Widget _buildStatItem(
    String label,
    String topValue,
    String bottomValue,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60.px,
              height: 60.px,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8.px,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  topValue,
                  style: AppTextStyle.subtitleMedium(
                    color: Colors.white,
                    fontFamily: "secondary",
                  ),
                ),

                /// -------- Divider -------- ///
                SizedBox(
                  width: 5.h,
                  child: Divider(
                    thickness: 2,
                    height: 2,
                    color: AppColor.darkText.withValues(alpha: 0.5),
                    radius: BorderRadiusGeometry.circular(100),
                  ),
                ),

                /// ---------
                Text(
                  bottomValue,
                  style: AppTextStyle.subtitleMedium(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.5.h),

        /// ----- Label-------- ///
        ClayContainer(
          width: 20.w,
          height: 24.px,
          borderRadius: 10,
          depth: 70,
          surfaceColor: AppColor.secondaryColor,
          parentColor: AppColor.secondaryColor,
          spread: 1,
          curveType: CurveType.concave,
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.subtitleMedium(color: AppColor.lightText),
            ),
          ),
        ),
      ],
    );
  }
}
