import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/utils/responsive_grid.dart';
import 'package:garuda_user_app/core/widgets/app_content_width.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/app_video_player.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';
import 'package:go_router/go_router.dart';

part 'detail_gallery.dart';
part 'detail_header.dart';
part 'detail_properties.dart';
part 'detail_properties_trees.dart';

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
        backgroundColor: context.colors.surface,
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: _DetailHeaderBlock(land: land, listing: listing),
            ),
            SliverToBoxAdapter(
              child: ColoredBox(
                color: context.colors.surfaceContainerHighest,
                child: AppContentWidthBox(
                  child: Column(
                    children: [
                      _DetailPropertiesList(land: land, listing: listing),
                      _VisualDocumentationSection(land: land),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
