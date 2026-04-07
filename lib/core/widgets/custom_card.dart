import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.child,
    this.padding,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? context.radii.large;

    final content = Ink(
      decoration: BoxDecoration(
        color: color ?? context.colors.surface,
        gradient: gradient,
        borderRadius: radius,
        border:
            border ??
            Border.all(color: context.colors.outline.withValues(alpha: 0.18)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.spacing.lg),
        child: child,
      ),
    );

    if (onTap == null) {
      return Material(color: Colors.transparent, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: radius, onTap: onTap, child: content),
    );
  }
}
