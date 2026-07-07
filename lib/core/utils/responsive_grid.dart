import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/widgets/app_content_width.dart';

/// Breakpoint-aware column count for filter chips, galleries, and similar grids.
abstract final class ResponsiveGrid {
  static int gridCrossAxisCount(
    BuildContext context, {
    int compact = 2,
    int medium = 3,
    int expanded = 4,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < AppContentWidth.compactBreakpoint) {
      return compact;
    }
    if (screenWidth < AppContentWidth.mediumBreakpoint) {
      return medium;
    }
    return expanded;
  }

  static bool isExpandedWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppContentWidth.mediumBreakpoint;
  }
}
