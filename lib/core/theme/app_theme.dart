import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_spacing.dart';
import 'package:aether_project/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get rpgTheme => _buildTheme();

  static ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.panelBackground,
    ).copyWith(
      primary: AppColors.textPrimary,
      onPrimary: AppColors.panelBackground,
      secondary: AppColors.buttonBg,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.panelBackground,
      onSurface: AppColors.textPrimary,
      error: AppColors.textAccent,
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.panelBackground,
      colorScheme: colorScheme,
      canvasColor: AppColors.panelBackground,
      dividerColor: AppColors.panelInnerBorder,
    );

    final textTheme = GoogleFonts.vt323TextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.navLink.copyWith(color: AppColors.textPrimary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.buttonBg,
        contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
          side: const BorderSide(color: AppColors.buttonBorder, width: 2),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.chatInputBg,
        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.5)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
          borderSide: const BorderSide(color: AppColors.panelInnerBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
          borderSide: const BorderSide(color: AppColors.panelBorder, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
          borderSide: const BorderSide(color: AppColors.panelInnerBorder, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.panelBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
          side: const BorderSide(color: AppColors.panelBorder, width: 4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
            side: const BorderSide(color: AppColors.buttonBorder, width: 2),
          ),
          backgroundColor: AppColors.buttonBg,
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTypography.button,
          elevation: 2,
          shadowColor: AppColors.buttonShadow,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: AppTypography.displayMega,
      displayMedium: AppTypography.displayXl,
      displaySmall: AppTypography.displayLg,
      headlineLarge: AppTypography.displayMd,
      headlineMedium: AppTypography.displaySm,
      headlineSmall: AppTypography.titleMd,
      titleLarge: AppTypography.titleMd,
      titleMedium: AppTypography.titleSm,
      titleSmall: AppTypography.caption,
      bodyLarge: AppTypography.bodyMd,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.navLink,
      labelSmall: AppTypography.captionUppercase,
    );
  }
}
