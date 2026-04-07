import 'dart:math' as math;

import 'package:garuda_user_app/core/constants/app_constants.dart';

final class ResponsiveUtils {
  ResponsiveUtils._();

  static double contentWidth(double width) {
    return math.min(width, AppConstants.maxContentWidth);
  }

  static int homeCardColumns(double width) {
    if (width >= 980) {
      return 3;
    }

    if (width >= 620) {
      return 2;
    }

    return 1;
  }

  static double gridItemWidth({
    required double width,
    required int columns,
    required double spacing,
  }) {
    if (columns <= 1) {
      return width;
    }

    return (width - ((columns - 1) * spacing)) / columns;
  }
}
