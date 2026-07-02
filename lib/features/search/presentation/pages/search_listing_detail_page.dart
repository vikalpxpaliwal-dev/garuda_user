import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:garuda_user_app/core/widgets/app_video_player.dart';

import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';

class SearchListingDetailPage extends StatefulWidget {
  const SearchListingDetailPage({required this.landId, super.key});

  final int landId;

  @override
  State<SearchListingDetailPage> createState() =>
      _SearchListingDetailPageState();
}

class _SearchListingDetailPageState extends State<SearchListingDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SearchBloc>().add(LoadLandDetailEvent(landId: widget.landId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          previous.landDetailStatus != current.landDetailStatus ||
          previous.landDetailId != current.landDetailId ||
          previous.landDetail != current.landDetail ||
          previous.lands != current.lands,
      builder: (context, state) {
        final land = state.landForId(widget.landId);

        if (land == null &&
            state.landDetailId == widget.landId &&
            state.landDetailStatus == LandDetailStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (land == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                state.landDetailErrorMessage ?? 'Land not found.',
              ),
            ),
          );
        }

        return _SearchListingDetailView(land: land);
      },
    );
  }
}

class _SearchListingDetailView extends StatelessWidget {
  const _SearchListingDetailView({required this.land});

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
    final totalValue = LandMapper.formatTotalValueParts(
      land.landDetails.totalValue,
    );

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 380,
              width: double.infinity,
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
                                text: '₹${(land.landDetails.pricePerAcres / 100000).toStringAsFixed(1)}',
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
              listing.verificationLabel.toUpperCase(),
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
              listing.mortgage,
            ),
            _buildPropItem(
              Icons.update,
              'UPDATED',
              listing.updatedLabel.toUpperCase(),
            ),
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
              'MANDAL',
              land.mandal.toUpperCase(),
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.route_outlined,
              'DISTANCE FROM MANDAL',
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
            _buildPropItem(
              Icons.home_work_outlined,
              'POULTRY SHED',
              land.landDetails.poultryShedNumber > 0
                  ? land.landDetails.poultryShedNumber.toString()
                  : 'NO',
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(
              Icons.pets_outlined,
              'COW SHED',
              land.landDetails.cowShedNumber > 0
                  ? land.landDetails.cowShedNumber.toString()
                  : 'NO',
            ),
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
          if (land.landDetails.trees.isEmpty)
            const Text(
              'No trees available',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            )
          else ...[
            for (int i = 0; i < land.landDetails.trees.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildRow(
                  _buildPropItem(
                    Icons.energy_savings_leaf_outlined,
                    land.landDetails.trees[i].type.toUpperCase(),
                    '${land.landDetails.trees[i].count} TREES',
                  ),
                  i + 1 < land.landDetails.trees.length
                      ? _buildPropItem(
                          Icons.energy_savings_leaf_outlined,
                          land.landDetails.trees[i + 1].type.toUpperCase(),
                          '${land.landDetails.trees[i + 1].count} TREES',
                        )
                      : const SizedBox(),
                ),
              ),
          ],
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
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
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

  void _launchVideo(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppVideoPlayer(videoUrl: url),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = land.media.where((m) => m.type == 'image').toList();
    final videos = land.media.where((m) => m.type == 'video').toList();

    final displayImages = images.map((e) => e.url).toList();
    final displayVideos = videos.map((e) => e.url).toList();

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
          if (displayImages.isEmpty && displayVideos.isEmpty)
            const Text(
              'No visual documentation available',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
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
              itemCount: displayImages.length,
              itemBuilder: (context, index) {
                final mediaUrl = displayImages[index];
                return GestureDetector(
                  onTap: () => _showImageDialog(context, mediaUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: AppColors.lightLine,
                      child: CachedNetworkImage(
                        imageUrl: mediaUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 600,
                        placeholder: (context, url) =>
                            const ColoredBox(color: AppColors.lightLine),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.lightLine,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
                  onTap: () => _launchVideo(context, videoUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black,
                      child: Stack(
                        children: [

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
