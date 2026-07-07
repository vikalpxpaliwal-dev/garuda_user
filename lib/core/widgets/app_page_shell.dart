import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_mesh_background.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';

/// Shared scroll shell for Home, Search, and Profile tab pages.
///
/// Provides optional mesh background, [CommonSliverAppBar], pull-to-refresh,
/// and a [CustomScrollView] over [slivers].
class AppPageShell extends StatelessWidget {
  const AppPageShell({
    required this.slivers,
    this.onRefresh,
    this.showAppBar = true,
    this.showSearchAction = true,
    this.showMeshBackground = true,
    this.meshVariant = AppMeshBackgroundVariant.home,
    this.stackOverlay = const <Widget>[],
    super.key,
  });

  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;
  final bool showAppBar;
  final bool showSearchAction;
  final bool showMeshBackground;
  final AppMeshBackgroundVariant meshVariant;
  final List<Widget> stackOverlay;

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: <Widget>[
        if (showAppBar)
          CommonSliverAppBar(showSearchAction: showSearchAction),
        ...slivers,
      ],
    );

    final scrollable = onRefresh == null
        ? scrollView
        : RefreshIndicator(
            color: AppColors.deepOrange,
            onRefresh: onRefresh!,
            child: scrollView,
          );

    if (!showMeshBackground && stackOverlay.isEmpty) {
      return scrollable;
    }

    return Stack(
      children: <Widget>[
        if (showMeshBackground)
          Positioned.fill(child: AppMeshBackground(variant: meshVariant)),
        scrollable,
        ...stackOverlay,
      ],
    );
  }
}
