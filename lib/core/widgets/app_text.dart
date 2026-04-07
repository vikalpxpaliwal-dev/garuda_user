import 'package:flutter/material.dart';

enum AppTextVariant {
  displaySmall,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  labelLarge,
  labelMedium,
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.textAlign,
    super.key,
  });

  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = switch (variant) {
      AppTextVariant.displaySmall => textTheme.displaySmall,
      AppTextVariant.headlineMedium => textTheme.headlineMedium,
      AppTextVariant.headlineSmall => textTheme.headlineSmall,
      AppTextVariant.titleLarge => textTheme.titleLarge,
      AppTextVariant.titleMedium => textTheme.titleMedium,
      AppTextVariant.bodyLarge => textTheme.bodyLarge,
      AppTextVariant.bodyMedium => textTheme.bodyMedium,
      AppTextVariant.labelLarge => textTheme.labelLarge,
      AppTextVariant.labelMedium => textTheme.labelMedium,
    };

    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: textAlign,
      style: baseStyle?.copyWith(color: color, fontWeight: fontWeight),
    );
  }
}
