import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens from Watchflo
abstract final class AppTypography {
  static const String _displayFamily = 'Waldenburg Light';
  static const List<String> _displayFallback = <String>[
    'Times New Roman',
    'serif',
  ];

  static TextStyle _display({
    required double size,
    required double height,
    required double letterSpacing,
    FontWeight weight = FontWeight.w300,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontFamilyFallback: _displayFallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    required double height,
    required double letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).copyWith(fontFamilyFallback: const <String>['sans-serif']);
  }

  static TextStyle get displayMega =>
      _display(size: 56, weight: FontWeight.w300, height: 1.05, letterSpacing: -1.92);
  static TextStyle get displayXl =>
      _display(size: 48, weight: FontWeight.w300, height: 1.08, letterSpacing: -0.96);
  static TextStyle get displayLg =>
      _display(size: 36, weight: FontWeight.w300, height: 1.17, letterSpacing: -0.36);
  static TextStyle get displayMd =>
      _display(size: 32, weight: FontWeight.w300, height: 1.13, letterSpacing: -0.32);
  static TextStyle get displaySm =>
      _display(size: 22, weight: FontWeight.w400, height: 1.2, letterSpacing: 0);

  static TextStyle get titleMd =>
      _inter(size: 20, weight: FontWeight.w500, height: 1.35, letterSpacing: 0);
  static TextStyle get titleSm => _inter(
    size: 18,
    weight: FontWeight.w500,
    height: 1.44,
    letterSpacing: 0.18,
  );

  static TextStyle get bodyMd =>
      _inter(size: 16, weight: FontWeight.w400, height: 1.5, letterSpacing: 0.16);
  static TextStyle get bodyStrong =>
      _inter(size: 16, weight: FontWeight.w500, height: 1.5, letterSpacing: 0.16);
  static TextStyle get bodySm =>
      _inter(size: 15, weight: FontWeight.w400, height: 1.47, letterSpacing: 0.15);

  static TextStyle get caption =>
      _inter(size: 14, weight: FontWeight.w400, height: 1.5, letterSpacing: 0);
  static TextStyle get captionUppercase => _inter(
    size: 12,
    weight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.96,
  );

  static TextStyle get button =>
      _inter(size: 15, weight: FontWeight.w500, height: 1.0, letterSpacing: 0);
  static TextStyle get navLink =>
      _inter(size: 15, weight: FontWeight.w500, height: 1.4, letterSpacing: 0);

  static TextStyle displayCustom({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.w300,
    double height = 1.08,
    double? letterSpacing,
  }) {
    return _display(
      size: fontSize,
      weight: fontWeight,
      height: height,
      letterSpacing: letterSpacing ?? 0,
      color: color,
    );
  }
}
