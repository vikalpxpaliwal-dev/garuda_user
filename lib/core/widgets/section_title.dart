import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(title, variant: AppTextVariant.headlineSmall),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 8),
          AppText(subtitle!, variant: AppTextVariant.bodyMedium),
        ],
      ],
    );
  }
}
