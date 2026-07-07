import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';

part 'listing_artwork.dart';


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
    final onSurface = context.colors.onSurface;
    final outline = context.colors.outline;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child:
                            listing.imageUrl != null &&
                                listing.imageUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: listing.imageUrl!,
                                fit: BoxFit.cover,
                                // Downsample to display size so multi-MB source
                                // images do not blow up decode time or memory.
                                memCacheWidth: 800,
                                fadeInDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                placeholder: (context, url) =>
                                    const _ListingImagePlaceholder(),
                                errorWidget: (context, url, error) {
                                  return switch (listing.artworkType) {
                                    SearchListingArtworkType.cityWalk =>
                                      const _CityWalkArtwork(),
                                    SearchListingArtworkType.forestRoad =>
                                      const _ForestRoadArtwork(),
                                    SearchListingArtworkType.cityBridge =>
                                      const _CityBridgeArtwork(),
                                  };
                                },
                              )
                            : switch (listing.artworkType) {
                                SearchListingArtworkType.cityWalk =>
                                  const _CityWalkArtwork(),
                                SearchListingArtworkType.forestRoad =>
                                  const _ForestRoadArtwork(),
                                SearchListingArtworkType.cityBridge =>
                                  const _CityBridgeArtwork(),
                              },
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.2),
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
                top: 12,
                right: 12,
                child: _ShortlistPill(
                  isWishlisted: isWishlisted,
                  isSelected: isWishlistSelected,
                  isLoading: isWishlistLoading,
                  onTap: onWishlistTap,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        listing.title,
                        variant: AppTextVariant.price,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        final priceStr = listing.price.trim();
                        final match = RegExp(
                          r'^([₹$€£]?\s*(?:Rs\.?)?\s*[0-9.,]+)(.*)$',
                          caseSensitive: false,
                        ).firstMatch(priceStr);
                        final priceNumber =
                            match?.group(1)?.trim() ?? priceStr;
                        final priceUnit = match?.group(2)?.trim() ?? '';

                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: priceNumber,
                                style: context.text.price,
                              ),
                              if (priceUnit.isNotEmpty)
                                TextSpan(
                                  text: ' $priceUnit',
                                  style: context.text.priceUnit,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDottedDivider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _ListingStatVertical(
                        icon: Icons.open_in_full_rounded,
                        label: 'AREA',
                        value: listing.area,
                        valueColor: AppColors.deepOrange,
                      ),
                    ),
                    Expanded(
                      child: _ListingStatVertical(
                        icon: Icons.landscape_outlined,
                        label: 'SOIL',
                        value: listing.soilType,
                        valueColor: AppColors.deepOrange,
                      ),
                    ),
                    Expanded(
                      child: _ListingStatVertical(
                        icon: Icons.location_on_outlined,
                        label: 'DIST.',
                        value: listing.distance,
                        valueColor: AppColors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDottedDivider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ListingStatAvailability(
                        icon: Icons.access_time,
                        label: 'AVAILABILITY',
                        value: listing.availability.toUpperCase(),
                        valueColor: AppColors.deepOrange,
                      ),
                    ),
                    Expanded(
                      child: _ListingStatAvailability(
                        icon: Icons.access_time,
                        label: 'UPDATED',
                        value: listing.updatedLabel.toUpperCase(),
                        valueColor: onSurface,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: InkWell(
                    onTap: onViewDetails,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: AppText(
                      'View Full Details',
                      variant: AppTextVariant.bodyLarge,
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w800,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (width / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ListingImagePlaceholder extends StatelessWidget {
  const _ListingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightLine.withValues(alpha: 0.7),
            AppColors.mist.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _ListingStatVertical extends StatelessWidget {
  const _ListingStatVertical({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.deepOrange),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                variant: AppTextVariant.microLabel,
                color: context.colors.onSurface,
              ),
              const SizedBox(height: 2),
              AppText(
                value,
                variant: AppTextVariant.microLabel,
                color: valueColor,
                fontWeight: FontWeight.w700,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListingStatAvailability extends StatelessWidget {
  const _ListingStatAvailability({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.mutedText),
            const SizedBox(width: 4),
            AppText(
              label,
              variant: AppTextVariant.caption,
              color: AppColors.mutedText,
            ),
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          value,
          variant: AppTextVariant.caption,
          color: valueColor,
          fontWeight: FontWeight.w900,
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
    final scheme = context.colors;
    final canTap = onTap != null && !isWishlisted && !isLoading;
    final backgroundColor = isWishlisted
        ? AppColors.deepOrange.withValues(alpha: 0.95)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.95);
    final foregroundColor =
        isWishlisted ? scheme.onPrimary : scheme.onSurface;

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
                  : scheme.outline.withValues(alpha: 0.4),
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
                    AppText(
                      isWishlisted
                          ? 'WISHLISTED'
                          : isSelected
                          ? 'SELECTED'
                          : 'WISHLIST',
                      variant: AppTextVariant.microLabel,
                      color: isSelected && !isWishlisted
                          ? AppColors.deepOrange
                          : foregroundColor,
                      letterSpacing: 0.35,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

