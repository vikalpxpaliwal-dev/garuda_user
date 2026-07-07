import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/constants/app_constants.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';

/// Breakpoint-aware max content width for shell pages.
abstract final class AppContentWidth {
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 900;

  static double maxWidthFor(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < compactBreakpoint) {
      return 420;
    }
    if (screenWidth < mediumBreakpoint) {
      return 560;
    }
    return math.min(screenWidth * 0.85, AppConstants.maxContentWidth);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final horizontal = context.spacing.screenPadding;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }
}

/// Centers child within the breakpoint-aware content column.
class AppContentWidthBox extends StatelessWidget {
  const AppContentWidthBox({
    required this.child,
    this.padding,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;

  /// Wraps [child] in a [SliverToBoxAdapter] with width constraints.
  static Widget sliver({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return SliverToBoxAdapter(
      child: AppContentWidthBox(padding: padding, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppContentWidth.maxWidthFor(context)),
        child: Padding(
          padding: padding ?? AppContentWidth.pagePadding(context),
          child: child,
        ),
      ),
    );
  }
}
