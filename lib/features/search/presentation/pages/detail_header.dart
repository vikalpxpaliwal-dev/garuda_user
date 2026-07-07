part of 'search_listing_detail_page.dart';

class _DetailHeaderBlock extends StatelessWidget {
  const _DetailHeaderBlock({required this.land, required this.listing});

  final LandEntity land;
  final SearchListingUiModel listing;

  double _heroHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final aspectHeight = size.width * (10 / 16);
    final maxHeight = size.height * 0.42;
    return aspectHeight < maxHeight ? aspectHeight : maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = LandMapper.formatTotalValueParts(
      land.landDetails.totalValue,
    );
    final heroHeight = _heroHeight(context);

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black),
                child: listing.imageUrl != null && listing.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: listing.imageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 1080,
                        placeholder: (context, url) =>
                            const ColoredBox(color: AppColors.lightLine),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.lightLine,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: 48,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.lightLine,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 48,
                          ),
                        ),
                      ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${land.landDetails.totalAcres.toInt()} ac ${land.landDetails.guntas} gts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.deepOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${land.district}, ${land.state}'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.deepOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '₹${(land.landDetails.pricePerAcres / 100000).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const TextSpan(
                                text: ' L',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const TextSpan(
                                text: ' / acr',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: AppContentWidthBox(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pie_chart_outline,
                      color: AppColors.deepOrange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'PRICING REPORT',
                      style: TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'TOTAL NET VALUE',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹${totalValue.amount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (totalValue.suffix.isNotEmpty)
                        TextSpan(
                          text: totalValue.suffix,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
