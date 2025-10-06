// utils/app_text_style.dart
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTextStyle {
  // Private constructor
  AppTextStyle._();

  // Text scale factor based on screen size
  static double get _textScaleFactor {
    if (Device.screenType == ScreenType.tablet) {
      return 1.1;
    } else if (Device.orientation == Orientation.landscape) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  // Font size calculation with responsiveness
  static double _responsiveSize(double size) {
    return size.sp * _textScaleFactor;
  }

  /// ============ TITLE STYLES ============

  /// Large title for main headings
  static TextStyle title({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'BubblegumSans',
      fontSize: _responsiveSize(size ?? 32),
      color: color ?? Colors.white,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  /// Medium title for section headings
  static TextStyle titleMedium({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'BubblegumSans',
      fontSize: _responsiveSize(size ?? 24),
      color: color ?? Colors.white,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  /// Small title for sub-headings
  static TextStyle titleSmall({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
    String fontFamily = "primary"
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _responsiveSize(size ?? 20),
      color: color ?? Colors.white,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  /// ============ SUBTITLE STYLES ============

  /// Large subtitle for descriptive text
  static TextStyle subtitle({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'primary',
      fontSize: _responsiveSize(size ?? 18),
      color: color ?? Colors.white70,
      fontWeight: weight ?? FontWeight.w500,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  /// Medium subtitle
  static TextStyle subtitleMedium({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
    String fontFamily = "primary"
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _responsiveSize(size ?? 16),
      color: color ?? Colors.white70,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  /// Small subtitle for captions
  static TextStyle subtitleSmall({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'primary',
      fontSize: _responsiveSize(size ?? 14),
      color: color ?? Colors.white60,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }

  // ============ BUTTON TEXT STYLES ============

  /// Large button text
  static TextStyle btnText({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'primary',
      fontSize: _responsiveSize(size ?? 18),
      color: color ?? Colors.white,
      fontWeight: weight ?? FontWeight.w600,
      height: height ?? 0.0,
      letterSpacing: letterSpacing ?? 0.0,
    );
  }

  /// Medium button text
  static TextStyle btnTextMedium({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'primary',
      fontSize: _responsiveSize(size ?? 16),
      color: color ?? Colors.white,
      fontWeight: weight ?? FontWeight.w600,
      height: height ?? 0.0,
      letterSpacing: letterSpacing ?? 0.0,
    );
  }
}

