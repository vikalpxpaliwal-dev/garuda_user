import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
class SearchListingDetailArgs {
  const SearchListingDetailArgs({required this.land, required this.searchBloc});

  final LandEntity land;
  final SearchBloc searchBloc;
}

class SearchListingDetailPage extends StatelessWidget {
  const SearchListingDetailPage({required this.land, super.key});

  final LandEntity land;

  @override
  Widget build(BuildContext context) {
    final listing = LandMapper.toUiModel(land);

    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) =>
          previous.wishlistStatus != current.wishlistStatus ||
          previous.wishlistMessage != current.wishlistMessage ||
          previous.activeWishlistLandId != current.activeWishlistLandId,
      listener: (context, state) {
        if (state.activeWishlistLandId != land.id ||
            state.wishlistMessage == null) {
          return;
        }

        if (state.wishlistStatus == WishlistStatus.failure) {
          AppScaffoldMessage.showError(context, state.wishlistMessage!);
        } else {
          AppScaffoldMessage.showSuccess(context, state.wishlistMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: _DetailHeaderBlock(land: land, listing: listing),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _DetailPropertiesList(land: land, listing: listing),
                    _VisualDocumentationSection(land: land),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeaderBlock extends StatelessWidget {
  const _DetailHeaderBlock({required this.land, required this.listing});
  final LandEntity land;
  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 380,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.black),
              child: listing.imageUrl != null && listing.imageUrl!.isNotEmpty
                  ? Image.network(
                      Uri.encodeFull(listing.imageUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.lightLine),
                    )
                  : Container(color: AppColors.lightLine),
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
                        child: Text(
                          'PER ACRE PRICE\n₹${(land.landDetails.pricePerAcres / 100000).toStringAsFixed(1)} LAKHS',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
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
              Text(
                '₹ ${(land.landDetails.totalValue / 10000000).toStringAsFixed(2)} Cr',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailPropertiesList extends StatelessWidget {
  const _DetailPropertiesList({required this.land, required this.listing});
  final LandEntity land;
  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRow(
            _buildPropItem(
              Icons.verified_outlined,
              'VERIFICATION',
              'YET TO BE VERIFIED',
            ),
            _buildPropItem(
              Icons.access_time,
              'AVAILABILITY',
              listing.availability.toUpperCase(),
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.account_balance_outlined,
              'MORTGAGE',
              land.landStatus.isNotEmpty
                  ? land.landStatus.first.toUpperCase()
                  : 'CURRENTLY MORTGAGED',
            ),
            _buildPropItem(Icons.update, 'UPDATED', '2 DAYS AGO'),
          ),
          _buildDivider(),
          _buildRow(
            _buildPropItem(
              Icons.location_on_outlined,
              'DISTRICT',
              land.district.toUpperCase(),
            ),
            _buildPropItem(
              Icons.location_city_outlined,
              'NEAREST TOWN',
              land.mandal.toUpperCase(),
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.route_outlined,
              'DIST. FROM TOWN',
              listing.distance.toUpperCase(),
            ),
            const SizedBox(),
          ),
          _buildDivider(),
          _buildRow(
            _buildPropItem(
              Icons.add_road,
              'NEAREST ROAD',
              land.landDetails.nearestRoadType.toUpperCase(),
            ),
            _buildPropItem(
              Icons.share_location_outlined,
              'ATTACHED TO ROAD',
              land.landDetails.landAttachedToRoad.toUpperCase(),
            ),
          ),
          _buildDivider(),
          _buildRow(
            _buildPropItem(
              Icons.landscape_outlined,
              'SOIL TYPE',
              land.landDetails.soilType.toUpperCase(),
            ),
            _buildPropItem(
              Icons.water_drop_outlined,
              'WATER SOURCE',
              land.landDetails.waterSource.isNotEmpty
                  ? land.landDetails.waterSource.join(', ').toUpperCase()
                  : 'NONE',
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.waves,
              'NO. OF BORES',
              land.landDetails.numberOfBores.toString(),
            ),
            _buildPropItem(
              Icons.pool_outlined,
              'FARM POND',
              land.landDetails.farmPond ? 'YES' : 'NO',
            ),
          ),
          _buildDivider(),
          _buildRow(
            _buildPropItem(
              Icons.house_outlined,
              'RESIDENCE',
              land.landDetails.residence.isNotEmpty
                  ? land.landDetails.residence.join(', ').toUpperCase()
                  : 'NO',
            ),
            _buildPropItem(Icons.home_work_outlined, 'POULTRY SHED', 'NO'),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(Icons.pets_outlined, 'COW SHED', 'NO'),
            const SizedBox(),
          ),
          _buildDivider(),
          _buildRow(
            _buildPropItem(
              Icons.electric_bolt_outlined,
              'ELECTRICITY',
              land.landDetails.electricity.isNotEmpty
                  ? land.landDetails.electricity.join(', ').toUpperCase()
                  : 'NONE',
            ),
            _buildPropItem(
              Icons.fence_outlined,
              'FENCING STATUS',
              land.landDetails.fencingStatus.toUpperCase(),
            ),
          ),
          _buildDivider(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.park_outlined,
                  size: 14,
                  color: AppColors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'TREES',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRow(
            _buildPropItem(
              Icons.energy_savings_leaf_outlined,
              'MANGO',
              '${land.landDetails.mangoTreesNumber.isEmpty ? '0' : land.landDetails.mangoTreesNumber} TREES',
            ),
            _buildPropItem(
              Icons.energy_savings_leaf_outlined,
              'COCONUT',
              '${land.landDetails.coconutTreesNumber.isEmpty ? '0' : land.landDetails.coconutTreesNumber} TREES',
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.energy_savings_leaf_outlined,
              'TEAK',
              '${land.landDetails.teakTreesNumber.isEmpty ? '0' : land.landDetails.teakTreesNumber} TREES',
            ),
            _buildPropItem(
              Icons.energy_savings_leaf_outlined,
              'NEEM',
              '${land.landDetails.neemTreesNumber.isEmpty ? '0' : land.landDetails.neemTreesNumber} TREES',
            ),
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildRow(Widget col1, Widget col2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: col1),
        Expanded(child: col2),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / (4 + 4)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: 4,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.lightLine.withValues(alpha: 0.4),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildPropItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.deepOrange),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
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
        ),
      ],
    );
  }
}

class _VisualDocumentationSection extends StatelessWidget {
  const _VisualDocumentationSection({required this.land});
  final LandEntity land;

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error, color: Colors.white)),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = land.media.where((m) => m.type == 'image').toList();
    final videos = land.media.where((m) => m.type == 'video').toList();

    // Use placeholders if no media available to keep UI looking good
    final displayImages = images.isNotEmpty
        ? images.map((e) => e.url).toList()
        : [
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop'
          ];

    final displayVideos = videos.isNotEmpty
        ? videos.map((e) => e.url).toList()
        : [
            'https://www.youtube.com/watch?v=dQw4w9WgXcQ' // Fallback video URL
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  size: 14,
                  color: AppColors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'VISUAL DOCUMENTATION',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (displayImages.isNotEmpty)
            GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: displayImages.length > 4 ? 4 : displayImages.length,
              itemBuilder: (context, index) {
                final mediaUrl = displayImages[index];
                return GestureDetector(
                  onTap: () => _showImageDialog(context, mediaUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: AppColors.lightLine,
                      child: Image.network(
                        mediaUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: AppColors.lightLine),
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 12),
          if (displayVideos.isNotEmpty)
            ...displayVideos.map((videoUrl) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () => _launchVideo(videoUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1542315843-079218671c84?q=80&w=600&auto=format&fit=crop',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: AppColors.lightLine),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
