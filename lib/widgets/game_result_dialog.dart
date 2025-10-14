import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/app_color.dart';
import '../models/game_models.dart';
import 'star_rating.dart';

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
    final height = ResponsiveHelper.screenHeight(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(1.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if(isWin)
            Lottie.asset("assets/animation/win.json" , height: height * 0.4 ,  fit: BoxFit.cover ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show different icon based on win or lose
                _buildIcon(),

                const SizedBox(height: 16),

                // Show title message
                _buildTitle(),

                const SizedBox(height: 16),

                // Show stars if player won
                if (isWin) StarRating(stars: stars),
                if (isWin) const SizedBox(height: 16),

                // Show game statistics
                _buildStatsContainer(),

                const SizedBox(height: 24),

                /// Show action buttons
                _buildButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the icon based on game result
  Widget _buildIcon() {
    IconData icon;
    Color color;

    if (isWin) {
      icon = Icons.celebration;
      color = Colors.green;
    } else if (timeElapsed >= level.timeLimit) {
      // Time finished
      icon = Icons.timer_off;
      color = Colors.orange;
    } else if (moves >= level.maxMoves) {
      // Moves finished
      icon = Icons.touch_app;
      color = Colors.red;
    } else {
      // Other reason
      icon = Icons.error;
      color = Colors.grey;
    }
    return Icon(icon, size: 64, color: color);
  }

  // Build the title based on game result
  Widget _buildTitle() {
    String title;
    String? description;
    Color? color;

    if (isWin) {
      title = 'Level Completed!';
      color = Colors.green;
    } else if (timeElapsed >= level.timeLimit) {
      title = 'Time\'s Up!';
      color = Colors.orange;
      description = 'Time finished. Try again!';
    } else if (moves >= level.maxMoves) {
      title = 'Moves Finished!';
      color = Colors.red;
      description = 'No moves left. Try again!';
    } else {
      title = 'Game Over!';
      description = 'Try again!';
    }

    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.titleMedium(
            color: color,
            fontFamily: "secondary",
          ),
          textAlign: TextAlign.center,
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyle.subtitle(
              color: AppColor.darkText,
              weight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  // Build the statistics container
  Widget _buildStatsContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          /// Level information
          _buildStatItem('Level', '${level.level} (${level.difficulty})'),

          /// Time information
          _buildStatItem('Time', '$timeElapsed/${level.timeLimit}s'),

          /// Moves information
          _buildStatItem('Moves', '$moves/${level.maxMoves}'),

          // Stars information (only show if won)
          if (isWin) _buildStatItem('Stars', '$stars/3'),
        ],
      ),
    );
  }

  // Build a single statistic row
  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Build action buttons
  Widget _buildButtons() {
    return Row(
      children: [
        /// ------ Exit button ---- ///
        OutlinedButton(
          onPressed: onLevelSelect,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.darkText),
            padding: EdgeInsetsGeometry.all(0),
          ),
          child: Text(
            'Exit',
            style: AppTextStyle.subtitleMedium(color: AppColor.darkText),
          ),
        ),

        SizedBox(width: 1.w),

        /// Retry/Play Again button
        Expanded(
          child: OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsetsGeometry.all(0),
              backgroundColor: isWin ? Colors.white : Colors.orange,
              side: BorderSide(color: isWin ? Colors.green : Colors.orange),
            ),
            child: Text(
              isWin ? 'Play Again' : 'Retry',
              style: AppTextStyle.subtitleMedium(
                color: isWin ? Colors.green : Colors.white,
              ),
            ),
          ),
        ),

        /// Next Level button (only show if won and next level exists)
        if (onNextLevel != null) ...[
          SizedBox(width: 1.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onNextLevel,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsetsGeometry.all(0),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Next Level',
                style: AppTextStyle.subtitleMedium(color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
