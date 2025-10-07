import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/screen/setting_screen.dart';
import 'package:card_match_memory/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helper/responsive_helper.dart';
import 'level_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withValues(alpha: 0.7),
              AppColor.secondaryColor,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    /// Image
                    Image.asset(
                      "assets/image/idea.png",
                      height: ResponsiveHelper.screenHeight(context) * 0.2,
                    ),

                    SizedBox(height: 2.h),
                    Text(
                      'Memory Challenge',
                      style: AppTextStyle.titleMedium(
                        color: Colors.white,
                        fontFamily: 'secondary',
                      ),
                    ),
                    Text(
                      'Train Your Memory ',
                      style: AppTextStyle.subtitle(color: AppColor.darkText),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Buttons
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LevelSelectionScreen(),
                          ),
                        );
                      },
                      text: 'Start Game',
                      icon: Icons.play_arrow,
                    ),

                    GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      text: 'Settings',
                      icon: Icons.settings,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
