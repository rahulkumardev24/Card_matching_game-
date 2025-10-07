// utils/app_text_style.dart
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTextStyle {
  /// ============ TITLE STYLES ============

  /// Large title for main headings
  static TextStyle title({
    Color? color,
    double? size,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
    String fontFamily = "primary"
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 28.sp,
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
    String? fontFamily = "primary"
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 24.sp,
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
    String fontFamily = "primary",
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20.sp,
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
      fontSize: 18.sp,
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
    String fontFamily = "primary",
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16.sp,
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
      color: color ?? Colors.white60,
      fontSize: 14.sp,
      fontWeight: weight ?? FontWeight.normal,
      height: height ?? 0.0,
      letterSpacing: letterSpacing,
    );
  }
}
