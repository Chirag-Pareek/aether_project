import 'package:flutter/material.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_spacing.dart';
import 'package:aether_project/core/theme/app_typography.dart';

/// Main ThemeData mapped from Watchflo tokens.
abstract final class AppTheme {
  static ThemeData get light => _buildTheme(AppColors.light, Brightness.light);
  static ThemeData get dark => _buildTheme(AppColors.dark, Brightness.dark);

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: colors.primary,
        ).copyWith(
          primary: colors.primary,
          onPrimary: colors.onPrimary,
          secondary: colors.body,
          onSecondary: colors.onPrimary,
          surface: colors.surfaceCard,
          onSurface: colors.ink,
          error: colors.semanticError,
          onError: colors.onPrimary,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.canvas,
      colorScheme: colorScheme,
      canvasColor: colors.canvas,
      dividerColor: colors.hairline,
    );

    final textTheme = _buildTextTheme().apply(
      bodyColor: colors.body,
      displayColor: colors.ink,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTypography.navLink.copyWith(color: colors.ink),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surfaceStrong,
        contentTextStyle: AppTypography.bodyMd.copyWith(color: colors.ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedXl),
          side: BorderSide.none,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceStrong,
        hintStyle: AppTypography.bodyMd.copyWith(color: colors.body),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        constraints: const BoxConstraints(minHeight: AppSpacing.textInputHeight),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedPill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedPill),
          borderSide: BorderSide(color: colors.hairlineStrong, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedPill),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.roundedXl),
          side: BorderSide(color: colors.hairline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          fixedSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.roundedPill),
          ),
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          fixedSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.roundedPill),
          ),
          side: BorderSide(color: colors.hairlineStrong),
          foregroundColor: colors.ink,
          backgroundColor: colors.surfaceStrong,
          textStyle: AppTypography.button,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[colors],
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

  static TextStyle serif({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.w300,
    double? height,
    double? letterSpacing,
  }) {
    final resolvedHeight =
        height ??
        (fontSize >= 60
            ? 1.05
            : fontSize >= 46
            ? 1.08
            : fontSize >= 34
            ? 1.17
            : fontSize >= 30
            ? 1.13
            : 1.2);
    final resolvedLetterSpacing =
        letterSpacing ??
        (fontSize >= 60
            ? -1.92
            : fontSize >= 46
            ? -0.96
            : fontSize >= 34
            ? -0.36
            : fontSize >= 30
            ? -0.32
            : 0.0);

    return AppTypography.displayCustom(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: resolvedHeight,
      letterSpacing: resolvedLetterSpacing,
    );
  }
}
