import 'package:flutter/material.dart';

/// Design-token color palette from Watchflo
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryActive,
    required this.canvas,
    required this.canvasSoft,
    required this.canvasDeep,
    required this.surfaceCard,
    required this.surfaceStrong,
    required this.surfaceDark,
    required this.surfaceDarkElevated,
    required this.hairline,
    required this.hairlineSoft,
    required this.hairlineStrong,
    required this.ink,
    required this.body,
    required this.bodyStrong,
    required this.onPrimary,
    required this.onDark,
    required this.onDarkSoft,
    required this.gradientMint,
    required this.gradientPeach,
    required this.gradientLavender,
    required this.gradientSky,
    required this.gradientRose,
    required this.semanticSuccess,
    required this.semanticError,
    required this.chartBar,
    required this.chartBarHighlight,
    required this.categoryShorts,
    required this.categoryLong,
    required this.categoryLearning,
    required this.categoryMusic,
    required this.gradientFocusStart,
    required this.gradientFocusEnd,
  });

  final Color primary;
  final Color primaryActive;
  final Color canvas;
  final Color canvasSoft;
  final Color canvasDeep;
  final Color surfaceCard;
  final Color surfaceStrong;
  final Color surfaceDark;
  final Color surfaceDarkElevated;
  final Color hairline;
  final Color hairlineSoft;
  final Color hairlineStrong;
  final Color ink;
  final Color body;
  final Color bodyStrong;
  final Color onPrimary;
  final Color onDark;
  final Color onDarkSoft;
  final Color gradientMint;
  final Color gradientPeach;
  final Color gradientLavender;
  final Color gradientSky;
  final Color gradientRose;
  final Color semanticSuccess;
  final Color semanticError;
  
  final Color chartBar;
  final Color chartBarHighlight;
  final Color categoryShorts;
  final Color categoryLong;
  final Color categoryLearning;
  final Color categoryMusic;
  final Color gradientFocusStart;
  final Color gradientFocusEnd;

  static const AppColors light = AppColors(
    primary: Color(0xFF0C0A09),
    primaryActive: Color(0xFF0C0A09),
    canvas: Color(0xFFF5F5F5),
    canvasSoft: Color(0xFFFAFAFA),
    canvasDeep: Color(0xFF0C0A09),
    surfaceCard: Color.fromRGBO(235, 235, 235, 1),
    surfaceStrong: Color.fromRGBO(235, 235, 235, 1),
    surfaceDark: Color(0xFF0C0A09),
    surfaceDarkElevated: Color(0xFF1C1917),
    hairline: Color(0xFFE7E5E4),
    hairlineSoft: Color(0xFFF0EFED),
    hairlineStrong: Color(0xFFD6D3D1),
    ink: Color(0xFF0C0A09),
    body: Color(0xFF4E4E4E),
    bodyStrong: Color(0xFF292524),
    onPrimary: Color(0xFFFFFFFF),
    onDark: Color(0xFFFFFFFF),
    onDarkSoft: Color(0xFFA8A29E),
    gradientMint: Color(0xFFA7E5D3),
    gradientPeach: Color(0xFFF4C5A8),
    gradientLavender: Color(0xFFC8B8E0),
    gradientSky: Color(0xFFA8C8E8),
    gradientRose: Color(0xFFE8B8C4),
    semanticSuccess: Color(0xFF16A34A),
    semanticError: Color(0xFFDC2626),
    chartBar: Color(0xFFFCA5A5),
    chartBarHighlight: Color(0xFFF87171),
    categoryShorts: Color(0xFFF43F5E),
    categoryLong: Color(0xFFF59E0B),
    categoryLearning: Color(0xFF10B981),
    categoryMusic: Color(0xFF8B5CF6),
    gradientFocusStart: Color(0xFFF43F5E),
    gradientFocusEnd: Color(0xFFF97316),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFFFFFFFF),
    primaryActive: Color(0xFFF5F5F5),
    canvas: Color(0xFF101010),
    canvasSoft: Color(0xFF141211),
    canvasDeep: Color(0xFF000000),
    surfaceCard: Color(0xFF1B1B1B),
    surfaceStrong: Color(0xFF242424),
    surfaceDark: Color(0xFF101010),
    surfaceDarkElevated: Color(0xFF1C1917),
    hairline: Color(0xFF292524),
    hairlineSoft: Color(0xFF1C1917),
    hairlineStrong: Color(0xFF4E4E4E),
    ink: Color(0xFFF5F5F5),
    body: Color(0xFFA3A3A3),
    bodyStrong: Color(0xFFD6D3D1),
    onPrimary: Color(0xFF0C0A09),
    onDark: Color(0xFFFFFFFF),
    onDarkSoft: Color(0xFFA8A29E),
    gradientMint: Color(0xFFA7E5D3),
    gradientPeach: Color(0xFFF4C5A8),
    gradientLavender: Color(0xFFC8B8E0),
    gradientSky: Color(0xFFA8C8E8),
    gradientRose: Color(0xFFE8B8C4),
    semanticSuccess: Color(0xFF16A34A),
    semanticError: Color(0xFFDC2626),
    chartBar: Color(0xFFD49A97),
    chartBarHighlight: Color(0xFFF6A391),
    categoryShorts: Color(0xFFF65B6D),
    categoryLong: Color(0xFFF8B145),
    categoryLearning: Color(0xFF5ED37E),
    categoryMusic: Color(0xFFA566D2),
    gradientFocusStart: Color(0xFFF46D7D),
    gradientFocusEnd: Color(0xFFF8B084),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryActive,
    Color? canvas,
    Color? canvasSoft,
    Color? canvasDeep,
    Color? surfaceCard,
    Color? surfaceStrong,
    Color? surfaceDark,
    Color? surfaceDarkElevated,
    Color? hairline,
    Color? hairlineSoft,
    Color? hairlineStrong,
    Color? ink,
    Color? body,
    Color? bodyStrong,
    Color? onPrimary,
    Color? onDark,
    Color? onDarkSoft,
    Color? gradientMint,
    Color? gradientPeach,
    Color? gradientLavender,
    Color? gradientSky,
    Color? gradientRose,
    Color? semanticSuccess,
    Color? semanticError,
    Color? chartBar,
    Color? chartBarHighlight,
    Color? categoryShorts,
    Color? categoryLong,
    Color? categoryLearning,
    Color? categoryMusic,
    Color? gradientFocusStart,
    Color? gradientFocusEnd,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryActive: primaryActive ?? this.primaryActive,
      canvas: canvas ?? this.canvas,
      canvasSoft: canvasSoft ?? this.canvasSoft,
      canvasDeep: canvasDeep ?? this.canvasDeep,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceDarkElevated: surfaceDarkElevated ?? this.surfaceDarkElevated,
      hairline: hairline ?? this.hairline,
      hairlineSoft: hairlineSoft ?? this.hairlineSoft,
      hairlineStrong: hairlineStrong ?? this.hairlineStrong,
      ink: ink ?? this.ink,
      body: body ?? this.body,
      bodyStrong: bodyStrong ?? this.bodyStrong,
      onPrimary: onPrimary ?? this.onPrimary,
      onDark: onDark ?? this.onDark,
      onDarkSoft: onDarkSoft ?? this.onDarkSoft,
      gradientMint: gradientMint ?? this.gradientMint,
      gradientPeach: gradientPeach ?? this.gradientPeach,
      gradientLavender: gradientLavender ?? this.gradientLavender,
      gradientSky: gradientSky ?? this.gradientSky,
      gradientRose: gradientRose ?? this.gradientRose,
      semanticSuccess: semanticSuccess ?? this.semanticSuccess,
      semanticError: semanticError ?? this.semanticError,
      chartBar: chartBar ?? this.chartBar,
      chartBarHighlight: chartBarHighlight ?? this.chartBarHighlight,
      categoryShorts: categoryShorts ?? this.categoryShorts,
      categoryLong: categoryLong ?? this.categoryLong,
      categoryLearning: categoryLearning ?? this.categoryLearning,
      categoryMusic: categoryMusic ?? this.categoryMusic,
      gradientFocusStart: gradientFocusStart ?? this.gradientFocusStart,
      gradientFocusEnd: gradientFocusEnd ?? this.gradientFocusEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryActive: Color.lerp(primaryActive, other.primaryActive, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasSoft: Color.lerp(canvasSoft, other.canvasSoft, t)!,
      canvasDeep: Color.lerp(canvasDeep, other.canvasDeep, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceDarkElevated:
          Color.lerp(surfaceDarkElevated, other.surfaceDarkElevated, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineSoft: Color.lerp(hairlineSoft, other.hairlineSoft, t)!,
      hairlineStrong: Color.lerp(hairlineStrong, other.hairlineStrong, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      body: Color.lerp(body, other.body, t)!,
      bodyStrong: Color.lerp(bodyStrong, other.bodyStrong, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onDark: Color.lerp(onDark, other.onDark, t)!,
      onDarkSoft: Color.lerp(onDarkSoft, other.onDarkSoft, t)!,
      gradientMint: Color.lerp(gradientMint, other.gradientMint, t)!,
      gradientPeach: Color.lerp(gradientPeach, other.gradientPeach, t)!,
      gradientLavender: Color.lerp(gradientLavender, other.gradientLavender, t)!,
      gradientSky: Color.lerp(gradientSky, other.gradientSky, t)!,
      gradientRose: Color.lerp(gradientRose, other.gradientRose, t)!,
      semanticSuccess: Color.lerp(semanticSuccess, other.semanticSuccess, t)!,
      semanticError: Color.lerp(semanticError, other.semanticError, t)!,
      chartBar: Color.lerp(chartBar, other.chartBar, t)!,
      chartBarHighlight: Color.lerp(chartBarHighlight, other.chartBarHighlight, t)!,
      categoryShorts: Color.lerp(categoryShorts, other.categoryShorts, t)!,
      categoryLong: Color.lerp(categoryLong, other.categoryLong, t)!,
      categoryLearning: Color.lerp(categoryLearning, other.categoryLearning, t)!,
      categoryMusic: Color.lerp(categoryMusic, other.categoryMusic, t)!,
      gradientFocusStart: Color.lerp(gradientFocusStart, other.gradientFocusStart, t)!,
      gradientFocusEnd: Color.lerp(gradientFocusEnd, other.gradientFocusEnd, t)!,
    );
  }
}
