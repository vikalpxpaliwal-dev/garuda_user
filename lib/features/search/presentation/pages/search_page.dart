import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';
import 'package:garuda_user_app/features/search/presentation/pages/search_listing_detail_page.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';
import 'package:garuda_user_app/features/search/presentation/widgets/search_filter_panel.dart';
import 'package:garuda_user_app/features/search/presentation/widgets/search_listing_card.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isFilterOpen = false;
  final Set<int> _selectedWishlistLandIds = <int>{};

  void _showScaffoldMessage({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    if (isSuccess) {
      AppScaffoldMessage.showSuccess(context, message);
    } else {
      AppScaffoldMessage.showError(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>()..add(const GetLandsEvent()),
      child: BlocConsumer<SearchBloc, SearchState>(
        listenWhen: (previous, current) =>
            previous.wishlistStatus != current.wishlistStatus &&
            current.activeWishlistLandId == null,
        listener: (context, state) {
          if (state.wishlistStatus == WishlistStatus.success) {
            _selectedWishlistLandIds.clear();
            _showScaffoldMessage(
              context: context,
              message: state.wishlistMessage ?? 'Wishlist updated successfully.',
              isSuccess: true,
            );
            context.go(AppRoutes.profile);
          } else if (state.wishlistStatus == WishlistStatus.failure &&
              state.wishlistMessage != null) {
            _showScaffoldMessage(
              context: context,
              message: state.wishlistMessage!,
              isSuccess: false,
            );
          }
        },
        builder: (context, state) {
          final isBulkWishlistLoading =
              state.wishlistStatus == WishlistStatus.loading &&
              state.activeWishlistLandId == null;
          final canShowWishlistFab =
              !_isFilterOpen && state.status == SearchStatus.success && state.lands.isNotEmpty;

          return Scaffold(
            floatingActionButton: canShowWishlistFab
                ? FloatingActionButton.extended(
                    backgroundColor: AppColors.deepOrange,
                    foregroundColor: AppColors.white,
                    onPressed: isBulkWishlistLoading || _selectedWishlistLandIds.isEmpty
                        ? null
                        : () => context.read<SearchBloc>().add(
                              AddSelectedToWishlistEvent(
                                landIds: _selectedWishlistLandIds.toList(),
                              ),
                            ),
                    icon: isBulkWishlistLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(Icons.favorite_rounded),
                    label: Text(
                      _selectedWishlistLandIds.isEmpty
                          ? 'Select lands'
                          : 'Add Wishlist (${_selectedWishlistLandIds.length})',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  )
                : null,
            body: Stack(
              children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.softBackground,
                  gradient: RadialGradient(
                    center: Alignment(0.8, -0.6),
                    radius: 1.2,
                    colors: [Color(0xFFFFF9F2), AppColors.softBackground],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.9, 0.8),
                    radius: 1.4,
                    colors: [
                      AppColors.primaryOrange.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: <Widget>[
                const CommonSliverAppBar(),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Search Land'.toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.deepOrange,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          height: 1.05,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'VERIFIED LISTINGS FROM DIRECT FARMER DATA.',
                                        style: TextStyle(
                                          color: AppColors.mutedText,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isFilterOpen = !_isFilterOpen;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryOrange
                                            .withValues(alpha: 0.4),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryOrange
                                              .withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.tune_rounded,
                                      size: 20,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isFilterOpen
                                  ? SearchFilterPanel(
                                      key: const ValueKey<String>('filters'),
                                      onClose: () {
                                        setState(() {
                                          _isFilterOpen = false;
                                        });
                                      },
                                      onSearchResults: () {
                                        setState(() {
                                          _isFilterOpen = false;
                                        });
                                      },
                                    )
                                  : () {
                                      if (state.status == SearchStatus.loading) {
                                        return const _SearchSkeletonList();
                                      }

                                      if (state.status == SearchStatus.failure) {
                                        return Center(
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                size: 48,
                                                color: AppColors.deepOrange,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                state.errorMessage ?? 'Failed to load lands',
                                              ),
                                              TextButton(
                                                onPressed: () => context.read<SearchBloc>().add(
                                                      const GetLandsEvent(),
                                                    ),
                                                child: const Text('Try Again'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      if (state.lands.isEmpty) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(40),
                                            child: Text('No lands found.'),
                                          ),
                                        );
                                      }

                                      return Column(
                                        key: const ValueKey<String>('results'),
                                        children: state.lands.map((land) {
                                          final uiModel = LandMapper.toUiModel(land);
                                          final isWishlisted =
                                              state.wishlistedLandIds.contains(land.id);
                                          final isSelected =
                                              _selectedWishlistLandIds.contains(land.id);

                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            child: SearchListingCard(
                                              listing: uiModel,
                                              isWishlisted: isWishlisted,
                                              isWishlistSelected: isSelected,
                                              isWishlistLoading: isBulkWishlistLoading,
                                              onWishlistTap: isWishlisted || isBulkWishlistLoading
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        if (isSelected) {
                                                          _selectedWishlistLandIds.remove(land.id);
                                                        } else {
                                                          _selectedWishlistLandIds.add(land.id);
                                                        }
                                                      });
                                                    },
                                              onViewDetails: () {
                                                context.push(
                                                  AppRoutes.searchDetails,
                                                  extra: SearchListingDetailArgs(
                                                    land: land,
                                                    searchBloc: context.read<SearchBloc>(),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    }(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchSkeletonList extends StatefulWidget {
  const _SearchSkeletonList();

  @override
  State<_SearchSkeletonList> createState() => _SearchSkeletonListState();
}

class _SearchSkeletonListState extends State<_SearchSkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: 0.5,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(opacity: _pulseController.value, child: child);
      },
      child: Column(
        key: const ValueKey<String>('loading-skeletons'),
        children: List<Widget>.generate(
          3,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _SearchSkeletonCard(),
          ),
        ),
      ),
    );
  }
}

class _SearchSkeletonCard extends StatelessWidget {
  const _SearchSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppColors.white.withValues(alpha: 0.9),
            AppColors.softBackground.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.65)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1.62,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightLine.withValues(alpha: 0.8),
                      AppColors.mist.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: 84,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SkeletonBlock(height: 24, widthFactor: 0.62),
                    SizedBox(height: 8),
                    _SkeletonBlock(height: 10, widthFactor: 0.35),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SkeletonFixedBlock(height: 24, width: 92),
                  SizedBox(height: 8),
                  _SkeletonFixedBlock(height: 10, width: 66),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: AppColors.lightLine.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _SkeletonStat()),
              SizedBox(width: 10),
              Expanded(child: _SkeletonStat()),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(child: _SkeletonStat()),
              SizedBox(width: 10),
              Expanded(child: _SkeletonStat()),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.deepOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonStat extends StatelessWidget {
  const _SkeletonStat();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _SkeletonFixedBlock(
          height: 24,
          width: 24,
          isCircle: true,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBlock(height: 8, widthFactor: 0.5),
              SizedBox(height: 5),
              _SkeletonBlock(height: 11, widthFactor: 0.75),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.height,
    required this.widthFactor,
  });

  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: _SkeletonFixedBlock(height: height, width: double.infinity),
    );
  }
}

class _SkeletonFixedBlock extends StatelessWidget {
  const _SkeletonFixedBlock({
    required this.height,
    required this.width,
    this.isCircle = false,
  });

  final double height;
  final double width;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(isCircle ? 999 : 8),
      ),
    );
  }
}
