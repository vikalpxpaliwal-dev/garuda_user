import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';

/// Brand-specific text roles beyond Material [TextTheme].
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.sectionTitle,
    required this.price,
    required this.priceUnit,
    required this.caption,
    required this.microLabel,
  });

  static const light = AppTextStyles(
    sectionTitle: TextStyle(
      fontSize: 24,
      height: 1.05,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
      color: AppColors.deepOrange,
    ),
    price: TextStyle(
      fontSize: 22,
      height: 1.1,
      fontWeight: FontWeight.w900,
      color: AppColors.deepOrange,
    ),
    priceUnit: TextStyle(
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w800,
      color: Color(0xB3E85D04), // deepOrange @ 70%
    ),
    caption: TextStyle(
      fontSize: 12,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: AppColors.mutedText,
    ),
    microLabel: TextStyle(
      fontSize: 11,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: AppColors.mutedText,
    ),
  );

  static const dark = AppTextStyles(
    sectionTitle: TextStyle(
      fontSize: 24,
      height: 1.05,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
      color: AppColors.warmAmber,
    ),
    price: TextStyle(
      fontSize: 22,
      height: 1.1,
      fontWeight: FontWeight.w900,
      color: AppColors.warmAmber,
    ),
    priceUnit: TextStyle(
      fontSize: 13,
      height: 1.2,
      fontWeight: FontWeight.w800,
      color: Color(0xB3FFBE73),
    ),
    caption: TextStyle(
      fontSize: 12,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: Color(0xFFB8AFA6),
    ),
    microLabel: TextStyle(
      fontSize: 11,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: Color(0xFFB8AFA6),
    ),
  );

  final TextStyle sectionTitle;
  final TextStyle price;
  final TextStyle priceUnit;
  final TextStyle caption;
  final TextStyle microLabel;

  @override
  AppTextStyles copyWith({
    TextStyle? sectionTitle,
    TextStyle? price,
    TextStyle? priceUnit,
    TextStyle? caption,
    TextStyle? microLabel,
  }) {
    return AppTextStyles(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      caption: caption ?? this.caption,
      microLabel: microLabel ?? this.microLabel,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }

    return AppTextStyles(
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      price: TextStyle.lerp(price, other.price, t)!,
      priceUnit: TextStyle.lerp(priceUnit, other.priceUnit, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      microLabel: TextStyle.lerp(microLabel, other.microLabel, t)!,
    );
  }
}
