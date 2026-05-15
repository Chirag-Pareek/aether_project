import 'package:flutter/material.dart';

extension MediaScreen on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isTablet => screenWidth >= 600;
  bool get isPhone => screenWidth < 600;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Returns a responsive value based on screen size
  T adaptive<T>({required T phone, T? tablet}) {
    return isTablet ? (tablet ?? phone) : phone;
  }

  /// Returns a responsive padding/spacing value
  double resp(double base) => isTablet ? base * 1.5 : base;
}
