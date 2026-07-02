import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';
import 'package:garuda_user_app/features/search/presentation/widgets/search_filter_panel.dart';
import 'package:garuda_user_app/features/search/presentation/widgets/search_listing_card.dart';
import 'package:go_router/go_router.dart';

part 'search_page_skeleton.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isFilterOpen = true;
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
    return BlocConsumer<SearchBloc, SearchState>(
        listenWhen: (previous, current) =>
            previous.wishlistStatus != current.wishlistStatus &&
            current.activeWishlistLandId == null,
        listener: (context, state) {
          if (state.wishlistStatus == WishlistStatus.success) {
            _selectedWishlistLandIds.clear();
            _showScaffoldMessage(
              context: context,
              message:
                  state.wishlistMessage ?? 'Wishlist updated successfully.',
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
              !_isFilterOpen &&
              state.status == SearchStatus.success &&
              state.lands.isNotEmpty;

          return Scaffold(
            floatingActionButton: canShowWishlistFab
                ? FloatingActionButton.extended(
                    backgroundColor: AppColors.deepOrange,
                    foregroundColor: AppColors.white,
                    onPressed:
                        isBulkWishlistLoading ||
                            _selectedWishlistLandIds.isEmpty
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
                          : 'Wishlist (${_selectedWishlistLandIds.length})',
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
                      child: _constrained(
                        padding: EdgeInsets.fromLTRB(
                          18,
                          18,
                          18,
                          _isFilterOpen ? 28 : 20,
                        ),
                        child: _buildHeader(context),
                      ),
                    ),
                    ..._buildContentSlivers(context, state, isBulkWishlistLoading),
                  ],
                ),
              ],
            ),
          );
        },
      );
  }

  Widget _constrained({required Widget child, EdgeInsets? padding}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 18),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                color: AppColors.primaryOrange.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.1),
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
    );
  }

  List<Widget> _buildContentSlivers(
    BuildContext context,
    SearchState state,
    bool isBulkWishlistLoading,
  ) {
    if (_isFilterOpen) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: SearchFilterPanel(
              onClose: () {
                setState(() {
                  _isFilterOpen = false;
                });
              },
              onSearchResults: (filters) {
                setState(() {
                  _isFilterOpen = false;
                });
                context.read<SearchBloc>().add(
                  GetLandsEvent(filters: filters),
                );
              },
            ),
          ),
        ),
      ];
    }

    if (state.status == SearchStatus.loading) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: const _SearchSkeletonList(),
          ),
        ),
      ];
    }

    if (state.status == SearchStatus.failure) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.deepOrange,
                  ),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load lands'),
                  TextButton(
                    onPressed: () => context.read<SearchBloc>().add(
                      const GetLandsEvent(),
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    if (state.lands.isEmpty) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No lands found.'),
              ),
            ),
          ),
        ),
      ];
    }

    // Lazily build listing cards so off-screen images are not requested or
    // decoded until the card scrolls into view.
    return <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
        sliver: SliverList.builder(
          itemCount: state.lands.length,
          itemBuilder: (context, index) {
            final land = state.lands[index];
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildListingCard(
                    context,
                    land,
                    state,
                    isBulkWishlistLoading,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _buildListingCard(
    BuildContext context,
    LandEntity land,
    SearchState state,
    bool isBulkWishlistLoading,
  ) {
    final uiModel = LandMapper.toUiModel(land);
    final isWishlisted = state.wishlistedLandIds.contains(land.id);
    final isSelected = _selectedWishlistLandIds.contains(land.id);

    return SearchListingCard(
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
        context.push(AppRoutes.searchLandDetails(land.id));
      },
    );
  }
}

class _SearchSkeletonList extends StatefulWidget {
  const _SearchSkeletonList();

  @override
  State<_SearchSkeletonList> createState() => _SearchSkeletonListState();
}
