import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_radius_theme.dart';
import 'package:garuda_user_app/core/theme/app_spacing_theme.dart';
import 'package:garuda_user_app/core/theme/app_text_styles.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyles => theme.textTheme;

  AppTextStyles get text =>
      theme.extension<AppTextStyles>() ??
      (theme.brightness == Brightness.dark
          ? AppTextStyles.dark
          : AppTextStyles.light);

  /// Elevated card / panel surface (maps to [ColorScheme.surfaceContainerHighest]).
  Color get surfaceCard => colors.surfaceContainerHighest;

  AppSpacingTheme get spacing =>
      theme.extension<AppSpacingTheme>() ?? AppSpacingTheme.fallback;

  AppRadiusTheme get radii =>
      theme.extension<AppRadiusTheme>() ?? AppRadiusTheme.fallback;
}
