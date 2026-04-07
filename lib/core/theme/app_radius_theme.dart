import 'package:flutter/material.dart';

@immutable
class AppRadiusTheme extends ThemeExtension<AppRadiusTheme> {
  const AppRadiusTheme({
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
    required this.pill,
  });

  static const fallback = AppRadiusTheme(
    small: BorderRadius.all(Radius.circular(12)),
    medium: BorderRadius.all(Radius.circular(18)),
    large: BorderRadius.all(Radius.circular(24)),
    extraLarge: BorderRadius.all(Radius.circular(32)),
    pill: BorderRadius.all(Radius.circular(999)),
  );

  final BorderRadius small;
  final BorderRadius medium;
  final BorderRadius large;
  final BorderRadius extraLarge;
  final BorderRadius pill;

  @override
  AppRadiusTheme copyWith({
    BorderRadius? small,
    BorderRadius? medium,
    BorderRadius? large,
    BorderRadius? extraLarge,
    BorderRadius? pill,
  }) {
    return AppRadiusTheme(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      extraLarge: extraLarge ?? this.extraLarge,
      pill: pill ?? this.pill,
    );
  }

  @override
  AppRadiusTheme lerp(ThemeExtension<AppRadiusTheme>? other, double t) {
    if (other is! AppRadiusTheme) {
      return this;
    }

    return AppRadiusTheme(
      small: BorderRadius.lerp(small, other.small, t) ?? small,
      medium: BorderRadius.lerp(medium, other.medium, t) ?? medium,
      large: BorderRadius.lerp(large, other.large, t) ?? large,
      extraLarge:
          BorderRadius.lerp(extraLarge, other.extraLarge, t) ?? extraLarge,
      pill: BorderRadius.lerp(pill, other.pill, t) ?? pill,
    );
  }
}
