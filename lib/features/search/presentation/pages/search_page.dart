import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/widgets/app_content_width.dart';
import 'package:garuda_user_app/core/widgets/app_mesh_background.dart';
import 'package:garuda_user_app/core/widgets/app_page_shell.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';
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
            body: AppPageShell(
              meshVariant: AppMeshBackgroundVariant.tab,
              slivers: <Widget>[
                AppContentWidthBox.sliver(
                  padding: EdgeInsets.fromLTRB(
                    context.spacing.screenPadding,
                    context.spacing.md,
                    context.spacing.screenPadding,
                    _isFilterOpen
                        ? context.spacing.contentBottom
                        : context.spacing.lg,
                  ),
                  child: _buildHeader(context),
                ),
                ..._buildContentSlivers(context, state, isBulkWishlistLoading),
              ],
            ),
          );
        },
      );
  }

  Widget _constrained({required Widget child, EdgeInsets? padding}) {
    return AppContentWidthBox(padding: padding, child: child);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                'Search Land'.toUpperCase(),
                variant: AppTextVariant.sectionTitle,
              ),
              SizedBox(height: context.spacing.xs - 2),
              AppText(
                'VERIFIED LISTINGS FROM DIRECT FARMER DATA.',
                variant: AppTextVariant.microLabel,
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
    final horizontal = context.spacing.screenPadding;
    final sectionBottom = context.spacing.contentBottom;
    final listItemGap = context.spacing.lg;

    if (_isFilterOpen) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, sectionBottom),
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
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, sectionBottom),
            child: const _SearchSkeletonList(),
          ),
        ),
      ];
    }

    if (state.status == SearchStatus.failure) {
      return <Widget>[
        SliverToBoxAdapter(
          child: _constrained(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, sectionBottom),
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
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, sectionBottom),
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
        padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, sectionBottom),
        sliver: SliverList.builder(
          itemCount: state.lands.length,
          itemBuilder: (context, index) {
            final land = state.lands[index];
            return AppContentWidthBox(
              padding: EdgeInsets.only(bottom: listItemGap),
              child: _buildListingCard(
                context,
                land,
                state,
                isBulkWishlistLoading,
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
