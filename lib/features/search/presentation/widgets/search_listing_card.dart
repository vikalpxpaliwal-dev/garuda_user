import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';

class SearchListingCard extends StatelessWidget {
  const SearchListingCard({
    required this.listing,
    required this.onViewDetails,
    this.isWishlisted = false,
    this.isWishlistSelected = false,
    this.isWishlistLoading = false,
    this.onWishlistTap,
    super.key,
  });

  final SearchListingUiModel listing;
  final VoidCallback onViewDetails;
  final bool isWishlisted;
  final bool isWishlistSelected;
  final bool isWishlistLoading;
  final VoidCallback? onWishlistTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1.62,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: listing.imageUrl != null && listing.imageUrl!.isNotEmpty
                            ? Image.network(
                            Uri.encodeFull(listing.imageUrl!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return switch (listing.artworkType) {
                                    SearchListingArtworkType.cityWalk => const _CityWalkArtwork(),
                                    SearchListingArtworkType.forestRoad => const _ForestRoadArtwork(),
                                    SearchListingArtworkType.cityBridge => const _CityBridgeArtwork(),
                                  };
                                },
                              )
                            : switch (listing.artworkType) {
                                SearchListingArtworkType.cityWalk => const _CityWalkArtwork(),
                                SearchListingArtworkType.forestRoad => const _ForestRoadArtwork(),
                                SearchListingArtworkType.cityBridge => const _CityBridgeArtwork(),
                              },
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _ShortlistPill(
                  isWishlisted: isWishlisted,
                  isSelected: isWishlistSelected,
                  isLoading: isWishlistLoading,
                  onTap: onWishlistTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  listing.title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    listing.price,
                    style: const TextStyle(
                      color: AppColors.deepOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.availability.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: AppColors.lightLine.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _ListingStat(
                  icon: Icons.grid_on_rounded,
                  label: 'AREA',
                  value: listing.area,
                ),
              ),
              Expanded(
                child: _ListingStat(
                  icon: Icons.landscape_outlined,
                  label: 'SOIL TYPE',
                  value: listing.soilType,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _ListingStat(
                  icon: Icons.water_drop_outlined,
                  label: 'WATER',
                  value: listing.water,
                ),
              ),
              Expanded(
                child: _ListingStat(
                  icon: Icons.location_on_outlined,
                  label: 'DIST',
                  value: listing.distance,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onViewDetails,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepOrange,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(44),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Full Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingStat extends StatelessWidget {
  const _ListingStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.deepOrange.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12, color: AppColors.deepOrange),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShortlistPill extends StatelessWidget {
  const _ShortlistPill({
    required this.isWishlisted,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  final bool isWishlisted;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final canTap = onTap != null && !isWishlisted && !isLoading;
    final backgroundColor = isWishlisted
        ? AppColors.deepOrange.withValues(alpha: 0.95)
        : AppColors.white.withValues(alpha: 0.95);
    final foregroundColor = isWishlisted ? AppColors.white : AppColors.ink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isWishlisted
                  ? AppColors.deepOrange
                  : AppColors.lightLine.withValues(alpha: 0.4),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isLoading
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : isSelected
                          ? Icons.check_circle_rounded
                          : Icons.favorite_border_rounded,
                      size: 12,
                      color: isSelected && !isWishlisted
                          ? AppColors.deepOrange
                          : foregroundColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isWishlisted
                          ? 'WISHLISTED'
                          : isSelected
                          ? 'SELECTED'
                          : 'WISHLIST',
                      style: TextStyle(
                        color: isSelected && !isWishlisted
                            ? AppColors.deepOrange
                            : foregroundColor,
                        fontSize: 8.2,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.35,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CityWalkArtwork extends StatelessWidget {
  const _CityWalkArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFF0F1F2), Color(0xFFE5E6E8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 66,
            right: 0,
            bottom: 0,
            child: Container(color: const Color(0xFFF5F5F6)),
          ),
          Positioned(
            left: -10,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.18,
              child: Container(
                width: 180,
                height: 84,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9DBE0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 22,
            child: Container(
              width: 58,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFFD1E2B5),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 28,
            child: Column(
              children: List<Widget>.generate(
                6,
                (index) => Container(
                  width: 30 + (index.isEven ? 12 : 0),
                  height: 8,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: <Color>[
                      const Color(0xFF8B4EC7),
                      const Color(0xFFFFA63C),
                      const Color(0xFFC6434B),
                    ][index % 3],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 116,
            bottom: 32,
            child: Container(
              width: 48,
              height: 78,
              decoration: const BoxDecoration(
                color: Color(0xFFDADFE6),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          Positioned(
            left: 122,
            bottom: 98,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFD2AA89),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 110,
            bottom: 108,
            child: Container(
              width: 54,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF7D5B3E),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
          Positioned(
            left: 146,
            bottom: 18,
            child: Container(
              width: 68,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF1B2B4A),
                borderRadius: BorderRadius.all(Radius.circular(34)),
              ),
            ),
          ),
          Positioned(
            left: 166,
            bottom: 92,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFC89576),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 162,
            bottom: 108,
            child: Container(
              width: 40,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF6B5335),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),
          ),
          Positioned(
            left: 148,
            bottom: 46,
            child: Container(
              width: 34,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFE1AF3E),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          Positioned(
            right: 26,
            top: 18,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Color(0xFFFFC445),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _CrosswalkPainter())),
        ],
      ),
    );
  }
}

class _ForestRoadArtwork extends StatelessWidget {
  const _ForestRoadArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF132335),
            Color(0xFF314C2A),
            Color(0xFFE0CB87),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              children: List<Widget>.generate(
                7,
                (index) => Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 18 + (index.isEven ? 12 : 0),
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            const Color(0xFF0D1C1F).withValues(alpha: 0.95),
                            const Color(0xFF314A20).withValues(alpha: 0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 78,
            top: -22,
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFF3C4).withValues(alpha: 0.92),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -10,
            child: SizedBox(
              height: 82,
              child: CustomPaint(painter: _RoadPainter()),
            ),
          ),
          Positioned(
            left: 110,
            top: 24,
            child: Container(
              width: 20,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    const Color(0xFFFFF2C1).withValues(alpha: 0.78),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityBridgeArtwork extends StatelessWidget {
  const _CityBridgeArtwork();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF17111A), Color(0xFF5B433C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 44,
            child: Container(color: const Color(0xFF251824)),
          ),
          Positioned(
            left: -16,
            top: 40,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 174,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFFC7CCCF),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              width: 140,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE49A),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          Positioned(
            left: 172,
            top: 26,
            child: Container(
              width: 64,
              height: 74,
              decoration: const BoxDecoration(
                color: Color(0xFFEDE7D8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
            ),
          ),
          Positioned(
            left: 188,
            top: 4,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE6D4A7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 180,
            top: 44,
            child: Container(
              width: 12,
              height: 44,
              color: const Color(0xFFB69F7C),
            ),
          ),
          Positioned(
            left: 198,
            top: 44,
            child: Container(
              width: 12,
              height: 44,
              color: const Color(0xFFB69F7C),
            ),
          ),
          Positioned(
            left: 216,
            top: 44,
            child: Container(
              width: 12,
              height: 44,
              color: const Color(0xFFB69F7C),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _BridgeLightsPainter())),
        ],
      ),
    );
  }
}

class _CrosswalkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF6F6F8);

    for (var i = 0; i < 5; i++) {
      final path = Path()
        ..moveTo(size.width * 0.46 + (i * 28), size.height)
        ..lineTo(size.width * 0.34 + (i * 23), size.height * 0.54)
        ..lineTo(size.width * 0.38 + (i * 23), size.height * 0.54)
        ..lineTo(size.width * 0.5 + (i * 28), size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = const Color(0xFF212B35);
    final linePaint = Paint()
      ..color = const Color(0xFFFFE7A3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.22, size.height)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width * 0.84,
        size.height * 0.92,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, roadPaint);
    canvas.drawLine(
      Offset(size.width * 0.54, size.height * 0.42),
      Offset(size.width * 0.72, size.height * 0.8),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BridgeLightsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bridgePaint = Paint()
      ..color = const Color(0xFFFFE39A)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final archPaint = Paint()
      ..color = const Color(0xFFD2D8DC)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(8, size.height * 0.42),
      Offset(size.width * 0.64, size.height * 0.18),
      bridgePaint,
    );

    for (var i = 0; i < 10; i++) {
      final dx = 24.0 + (i * 12.0);
      canvas.drawLine(
        Offset(dx, size.height * 0.22),
        Offset(dx + 8, size.height * 0.44),
        archPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
