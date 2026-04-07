import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/theme/app_radius_theme.dart';
import 'package:garuda_user_app/core/theme/app_spacing_theme.dart';

final class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = _buildTheme(_lightColorScheme);
  static final ThemeData darkTheme = _buildTheme(_darkColorScheme);

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primaryOrange,
        onPrimary: AppColors.white,
        secondary: AppColors.forestGreen,
        onSecondary: AppColors.white,
        surface: AppColors.canvas,
        onSurface: AppColors.ink,
        outline: AppColors.outline,
        surfaceTint: Colors.transparent,
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.warmAmber,
        onPrimary: AppColors.ink,
        secondary: AppColors.forestGreen,
        onSecondary: AppColors.white,
        surface: AppColors.midnight,
        onSurface: AppColors.mist,
        outline: const Color(0xFF51463D),
        surfaceTint: Colors.transparent,
      );

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = _buildTextTheme(
      baseColor: colorScheme.onSurface,
      secondaryColor: colorScheme.onSurface.withValues(alpha: 0.72),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: colorScheme.outline.withValues(alpha: 0.3),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.slate : AppColors.white,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.35)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppSpacingTheme.fallback,
        AppRadiusTheme.fallback,
      ],
    );
  }

  static TextTheme _buildTextTheme({
    required Color baseColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }
}
