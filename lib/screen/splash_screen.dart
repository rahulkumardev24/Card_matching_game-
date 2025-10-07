import 'package:card_match_memory/helper/responsive_helper.dart';
import 'package:card_match_memory/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
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
    final height = ResponsiveHelper.screenHeight(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor,
              AppColor.primaryColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.2),

              // Animated Logo with Scale
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: isTablet ? width * 0.2 : width * 0.3,
                  height: isTablet ? width * 0.2 : width * 0.3,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
                    image: const DecorationImage(
                      image: AssetImage("assets/image/logo.png"),
                      fit: BoxFit.cover, // ADDED fit
                    ),
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 3.h : 4.h),

              // App Title with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Card Matching',
                  style: AppTextStyle.title(
                    color: AppColor.secondaryColor,
                    fontFamily: "secondary",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: isTablet ? 1.h : 2.h),

              // Subtitle with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Match Pairs & Boost Brain',
                  style: AppTextStyle.subtitleMedium(color: AppColor.darkText),
                ),
              ),

              const Spacer(), // FIXED: Added const
              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: isTablet ? width * 0.4 : width * 0.6,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: isTablet ? 1.h : 0.8.h,
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
