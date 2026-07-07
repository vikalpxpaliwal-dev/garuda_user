import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';

/// Visual mesh gradient used behind shell tab pages and splash.
enum AppMeshBackgroundVariant {
  /// Home tab — warm glow top-left, accent bottom-right.
  home,

  /// Search / Profile tabs — warm glow top-right, accent bottom-left.
  tab,

  /// Splash — slightly warmer top tone and stronger accent.
  splash,
}

class AppMeshBackground extends StatelessWidget {
  const AppMeshBackground({
    this.variant = AppMeshBackgroundVariant.home,
    super.key,
  });

  final AppMeshBackgroundVariant variant;

  @override
  Widget build(BuildContext context) {
    final (primaryCenter, secondaryCenter, warmColor, accentAlpha, secondaryRadius) =
        switch (variant) {
      AppMeshBackgroundVariant.home => (
          const Alignment(-0.8, -0.6),
          const Alignment(0.9, 0.8),
          const Color(0xFFFFF9F2),
          0.05,
          1.4,
        ),
      AppMeshBackgroundVariant.tab => (
          const Alignment(0.8, -0.6),
          const Alignment(-0.9, 0.8),
          const Color(0xFFFFF9F2),
          0.05,
          1.4,
        ),
      AppMeshBackgroundVariant.splash => (
          const Alignment(-0.5, -0.4),
          const Alignment(0.6, 0.7),
          const Color(0xFFFFF4EB),
          0.1,
          1.5,
        ),
    };

    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                gradient: RadialGradient(
                  center: primaryCenter,
                  radius: 1.2,
                  colors: <Color>[warmColor, AppColors.softBackground],
                  stops: const <double>[0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: secondaryCenter,
                  radius: secondaryRadius,
                  colors: <Color>[
                    AppColors.primaryOrange.withValues(alpha: accentAlpha),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
