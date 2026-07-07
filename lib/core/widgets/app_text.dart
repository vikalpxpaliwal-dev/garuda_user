import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_text_styles.dart';

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
  sectionTitle,
  price,
  priceUnit,
  caption,
  microLabel,
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.letterSpacing,
    this.maxLines,
    this.textAlign,
    this.overflow,
    super.key,
  });

  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appText = Theme.of(context).extension<AppTextStyles>();

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
      AppTextVariant.sectionTitle => appText?.sectionTitle,
      AppTextVariant.price => appText?.price,
      AppTextVariant.priceUnit => appText?.priceUnit,
      AppTextVariant.caption => appText?.caption,
      AppTextVariant.microLabel => appText?.microLabel,
    };

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines == null ? null : TextOverflow.ellipsis),
      textAlign: textAlign,
      style: baseStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
