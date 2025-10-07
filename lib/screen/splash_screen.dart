import 'package:card_match_memory/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({super.key, required this.onAnimationComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to next screen after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          widget.onAnimationComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveHelper.screenWidth(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.primaryColor,
              AppColor.primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.memory,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // App Title with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Memory Master',
                  style: AppTextStyle.title(
                    color: AppColor.secondaryColor,
                    fontFamily: "secondary",
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Match & Win',
                  style: AppTextStyle.subtitle(
                    color: AppColor.darkText,
                    weight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: width * 0.6,

                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.secondaryColor,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(21),
                    minHeight: 0.8.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
