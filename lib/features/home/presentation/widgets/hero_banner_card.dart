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
                      HeroBannerTone.investors => const _InvestorArtwork(),
                      HeroBannerTone.farmers => const _FarmerArtwork(),
                      HeroBannerTone.agents => const _AgentArtwork(),
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

class _InvestorArtwork extends StatelessWidget {
  const _InvestorArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF7F5F1), Color(0xFFFFFFFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.95),
                    const Color(0xFFEDEAE5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 34,
            child: Transform.rotate(
              angle: -0.02,
              child: Container(
                width: 155,
                height: 178,
                decoration: const BoxDecoration(
                  color: Color(0xFF12181C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(56),
                    topRight: Radius.circular(44),
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 46,
            right: 70,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 38,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2C8AE),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 116,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 32,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEC3A3),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 38,
            right: 92,
            child: Transform.rotate(
              angle: -0.06,
              child: Container(
                width: 60,
                height: 54,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'LAKE\nVIEW',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 52,
            top: 22,
            child: Container(
              width: 54,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF13181B),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmerArtwork extends StatelessWidget {
  const _FarmerArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFECE6CD), Color(0xFF9FC56B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 54,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFC7D6A3), Color(0xFFE8E6C6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 44,
            child: CustomPaint(painter: _FieldLinesPainter()),
          ),
          Positioned(
            top: 26,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                6,
                (index) => Container(
                  width: 22 + (index.isEven ? 6 : 0),
                  height: 10 + (index % 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A9854).withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 42,
            top: 36,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 34,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF7C593D),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 62,
            top: 58,
            child: Transform.rotate(
              angle: 0.38,
              child: Container(
                width: 26,
                height: 78,
                decoration: const BoxDecoration(
                  color: Color(0xFF9E6B4A),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 38,
            top: 72,
            child: Container(
              width: 46,
              height: 86,
              decoration: const BoxDecoration(
                color: Color(0xFFD8CF94),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            right: 44,
            bottom: -2,
            child: Transform.rotate(
              angle: 0.04,
              child: Container(
                width: 18,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFD5C98B),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 22,
            bottom: -4,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 16,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0D69A),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 84,
            top: 74,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 18,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF9E6B4A),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Positioned(
            right: 70,
            top: 68,
            child: Transform.rotate(
              angle: -0.32,
              child: Container(
                width: 38,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFC39E52),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentArtwork extends StatelessWidget {
  const _AgentArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F4F5),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              children: <Widget>[
                _windowPane(),
                _windowPane(),
                _windowPane(),
                _windowPane(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 54,
            child: Container(width: 2, color: const Color(0xFFD6DBE0)),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 116,
            child: Container(width: 2, color: const Color(0xFFD6DBE0)),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 92,
            child: Container(width: 2, color: const Color(0xFFD6DBE0)),
          ),
          Positioned(
            left: 28,
            bottom: 18,
            child: Container(
              width: 96,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF6B4338),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            left: 42,
            bottom: 52,
            child: Container(
              width: 26,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF90635B),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          Positioned(
            left: 74,
            bottom: 52,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFFCA3546),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          Positioned(
            left: 106,
            bottom: 60,
            child: Container(
              width: 54,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFFE4E6E8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            left: 114,
            bottom: 64,
            child: Container(
              width: 38,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF73787D),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          Positioned(
            left: 88,
            bottom: 70,
            child: Container(
              width: 18,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFF232323),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            left: 84,
            bottom: 90,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF2D7C2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 132,
            bottom: 70,
            child: Container(
              width: 18,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFF9BA9B7),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Positioned(
            left: 128,
            bottom: 90,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF3DCC7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 20,
            child: Container(
              width: 18,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFF434343),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 58,
            child: Container(
              width: 38,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF3D3D3D),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _windowPane() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFEEF3F6), Color(0xFFD8E0E7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

class _FieldLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6FA341).withValues(alpha: 0.45)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 26; i++) {
      final x = size.width * (i / 25);
      canvas.drawLine(
        Offset(x, size.height * 0.12),
        Offset(x - 8, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
