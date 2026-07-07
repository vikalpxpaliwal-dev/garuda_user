import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppSpacingTheme extends ThemeExtension<AppSpacingTheme> {
  const AppSpacingTheme({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.screenPadding,
    required this.contentTop,
    required this.contentBottom,
  });

  static const fallback = AppSpacingTheme(
    xs: 8,
    sm: 12,
    md: 16,
    lg: 20,
    xl: 24,
    xxl: 32,
    screenPadding: 18,
    contentTop: 22,
    contentBottom: 28,
  );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double screenPadding;
  final double contentTop;
  final double contentBottom;

  /// Standard horizontal + vertical insets for tab page content.
  EdgeInsets pageInsets({double? bottom}) {
    return EdgeInsets.fromLTRB(
      screenPadding,
      contentTop,
      screenPadding,
      bottom ?? contentBottom,
    );
  }

  @override
  AppSpacingTheme copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? screenPadding,
    double? contentTop,
    double? contentBottom,
  }) {
    return AppSpacingTheme(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      screenPadding: screenPadding ?? this.screenPadding,
      contentTop: contentTop ?? this.contentTop,
      contentBottom: contentBottom ?? this.contentBottom,
    );
  }

  @override
  AppSpacingTheme lerp(ThemeExtension<AppSpacingTheme>? other, double t) {
    if (other is! AppSpacingTheme) {
      return this;
    }

    return AppSpacingTheme(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
      screenPadding:
          lerpDouble(screenPadding, other.screenPadding, t) ?? screenPadding,
      contentTop: lerpDouble(contentTop, other.contentTop, t) ?? contentTop,
      contentBottom:
          lerpDouble(contentBottom, other.contentBottom, t) ?? contentBottom,
    );
  }
}
