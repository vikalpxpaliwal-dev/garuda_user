import 'package:flutter/material.dart';

enum AppButtonVariant { filled, tonal, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.filled,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        ),
        child: child,
      ),
      AppButtonVariant.tonal => FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
        ),
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: borderColor == null ? null : BorderSide(color: borderColor!),
        ),
        child: child,
      ),
    };

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
