import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';
import 'package:garuda_user_app/features/home/domain/entities/hero_banner.dart';

class HeroBannerCard extends StatelessWidget {
  const HeroBannerCard({required this.banner, super.key});

  final HeroBanner banner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 1.48,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: switch (banner.tone) {
                      HeroBannerTone.investors => Image.asset(
                          'assets/images/garuda_user_image1.jpeg',
                          fit: BoxFit.cover,
                        ),
                      HeroBannerTone.farmers => Image.asset(
                          'assets/images/garuda_user_image2.jpeg',
                          fit: BoxFit.cover,
                        ),
                      HeroBannerTone.agents => Image.asset(
                          'assets/images/garuda_user_image3.jpeg',
                          fit: BoxFit.cover,
                        ),
                    },
                  ),
                  // Subtle inner shadow overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.04),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        AppText(
          banner.title,
          variant: AppTextVariant.titleLarge,
          textAlign: TextAlign.center,
          color: AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(height: 5),
        Text(
          banner.subtitle.toUpperCase(),
          style: const TextStyle(
            color: AppColors.deepOrange,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}
