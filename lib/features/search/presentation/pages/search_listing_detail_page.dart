import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';
import 'package:go_router/go_router.dart';

class SearchListingDetailPage extends StatelessWidget {
  const SearchListingDetailPage({required this.land, super.key});

  final LandEntity land;

  @override
  Widget build(BuildContext context) {
    final listing = LandMapper.toUiModel(land);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.softBackground,
                gradient: RadialGradient(
                  center: Alignment(0.8, -0.6),
                  radius: 1.2,
                  colors: <Color>[Color(0xFFFFF9F2), AppColors.softBackground],
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
                  colors: <Color>[
                    AppColors.primaryOrange.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                toolbarHeight: 56,
                backgroundColor: AppColors.softBackground.withValues(
                  alpha: 0.72,
                ),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                shape: Border(
                  bottom: BorderSide(
                    color: AppColors.lightLine.withValues(alpha: 0.4),
                  ),
                ),
                titleSpacing: 12,
                title: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.home_work_outlined,
                      size: 18,
                      color: AppColors.deepOrange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () => context.go(AppRoutes.search),
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.ink,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.profile),
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.deepOrange.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xFFFFD1B5),
                          child: Text(
                            'U',
                            style: TextStyle(
                              color: AppColors.deepOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (Navigator.of(context).canPop()) {
                                  context.pop();
                                } else {
                                  context.go(AppRoutes.search);
                                }
                              },
                              borderRadius: BorderRadius.circular(999),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 16,
                                      color: AppColors.ink,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Full Details'.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.ink,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _DetailHeroCard(listing: listing),
                          const SizedBox(height: 10),
                          _DetailReportCard(listing: listing),
                          const SizedBox(height: 12),
                          const _DetailFooterActions(),
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
  }
}

class _DetailHeroCard extends StatelessWidget {
  const _DetailHeroCard({required this.listing});

  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.4)),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _LifestyleArtwork(listing: listing)),
                  // Inner Shadow Overlay for depth
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: _BadgePill(
                      icon: Icons.photo_library_outlined,
                      label: 'See Gallery'.toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: <Widget>[
                const _BadgePill(
                  icon: Icons.description_outlined,
                  label: 'PROPERTY REPORT',
                  tinted: true,
                ),
                const Spacer(),
                _BadgePill(
                  icon: Icons.vrpano_outlined,
                  label: listing.title.toUpperCase(),
                  tinted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailReportCard extends StatelessWidget {
  const _DetailReportCard({required this.listing});

  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...listing.detailSections.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == listing.detailSections.length - 1 ? 12 : 20,
              ),
              child: _DetailSection(section: entry.value),
            ),
          ),
          const Text(
            'DOCUMENT STATUS',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: listing.documentStatuses
                .map((status) => _DocumentStatusChip(label: status))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.section});

  final SearchListingDetailSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightLine.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            section.title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = math
                  .max(120.0, (constraints.maxWidth - 12) / 2)
                  .toDouble();

              return Wrap(
                spacing: 12,
                runSpacing: 16,
                children: section.fields
                    .map(
                      (field) => SizedBox(
                        width: itemWidth,
                        child: _DetailField(field: field),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.field});

  final SearchListingDetailField field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          field.label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 7,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          field.value,
          style: TextStyle(
            color: field.isAccent ? AppColors.deepOrange : AppColors.ink,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1.25,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

class _DocumentStatusChip extends StatelessWidget {
  const _DocumentStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DetailFooterActions extends StatelessWidget {
  const _DetailFooterActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: _FooterButton(
            icon: Icons.favorite_border_rounded,
            label: 'Add to Wishlist',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FooterButton(
            icon: Icons.share_rounded,
            label: 'Share Land',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FooterButton(
            icon: Icons.call_rounded,
            label: 'Contact Agent',
            isFilled: true,
            iconAtEnd: true,
          ),
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isFilled = false,
    this.iconAtEnd = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isFilled;
  final bool iconAtEnd;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isFilled ? AppColors.white : AppColors.ink;
    final effectiveColor = onTap == null && isFilled
        ? foregroundColor.withValues(alpha: 0.6)
        : foregroundColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.deepOrange : AppColors.white,
            gradient: isFilled
                ? const LinearGradient(
                    colors: [AppColors.deepOrange, AppColors.primaryOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isFilled ? AppColors.deepOrange : AppColors.lightLine.withValues(alpha: 0.6),
            ),
            boxShadow: [
              if (isFilled)
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: iconAtEnd
                      ? <Widget>[
                          Text(
                            label,
                            style: TextStyle(
                              color: effectiveColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(icon, size: 16, color: effectiveColor),
                        ]
                      : <Widget>[
                          Icon(icon, size: 16, color: effectiveColor),
                          const SizedBox(width: 6),
                          Text(
                            label,
                            style: TextStyle(
                              color: effectiveColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.icon,
    required this.label,
    this.tinted = false,
  });

  final IconData icon;
  final String label;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tinted
            ? AppColors.softBackground.withValues(alpha: 0.8)
            : AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
        boxShadow: tinted ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: AppColors.deepOrange),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _LifestyleArtwork extends StatelessWidget {
  const _LifestyleArtwork({required this.listing});

  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    final palette = switch (listing.artworkType) {
      SearchListingArtworkType.cityWalk => (
        const Color(0xFFF7EEE7),
        const Color(0xFFE1D7D0),
        const Color(0xFFB9D37B),
        const Color(0xFFC27A73),
      ),
      SearchListingArtworkType.forestRoad => (
        const Color(0xFFF8F0D5),
        const Color(0xFFD8E4D4),
        const Color(0xFFA6C56A),
        const Color(0xFF56705D),
      ),
      SearchListingArtworkType.cityBridge => (
        const Color(0xFFF7ECE7),
        const Color(0xFFD9D8E7),
        const Color(0xFFC9B077),
        const Color(0xFF68659D),
      ),
    };

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[palette.$1, palette.$2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          left: -18,
          top: 18,
          child: Container(
            width: 84,
            height: 56,
            decoration: BoxDecoration(
              color: palette.$3.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        Positioned(
          left: 14,
          top: 22,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List<Widget>.generate(
              8,
              (index) => Container(
                width: 8 + (index.isEven ? 4 : 0),
                height: 8 + (index % 3 == 0 ? 3 : 0),
                decoration: BoxDecoration(
                  color: <Color>[
                    Colors.white,
                    palette.$4.withValues(alpha: 0.85),
                    palette.$3.withValues(alpha: 0.8),
                  ][index % 3],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 26,
          child: Container(
            height: 26,
            color: Colors.white.withValues(alpha: 0.22),
          ),
        ),
        Positioned(
          left: 90,
          right: 18,
          bottom: 20,
          child: Transform.rotate(
            angle: -0.06,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF57525A),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Positioned(
          left: 116,
          bottom: 36,
          child: _PersonFigure(
            height: 48,
            skin: const Color(0xFFE2B7A1),
            clothing: const Color(0xFFF0F0F0),
            hair: const Color(0xFF8A6B54),
          ),
        ),
        Positioned(
          left: 144,
          bottom: 42,
          child: _PersonFigure(
            height: 40,
            skin: const Color(0xFFE4B89E),
            clothing: palette.$4,
            hair: const Color(0xFF5B463D),
          ),
        ),
        Positioned(
          right: 12,
          top: 18,
          child: Column(
            children: List<Widget>.generate(
              4,
              (index) => Container(
                width: 18 + (index * 8),
                height: 24,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.34),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonFigure extends StatelessWidget {
  const _PersonFigure({
    required this.height,
    required this.skin,
    required this.clothing,
    required this.hair,
  });

  final double height;
  final Color skin;
  final Color clothing;
  final Color hair;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height * 0.55,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: height * 0.13,
            top: 0,
            child: Container(
              width: height * 0.28,
              height: height * 0.28,
              decoration: BoxDecoration(color: skin, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: height * 0.08,
            top: height * 0.02,
            child: Container(
              width: height * 0.34,
              height: height * 0.12,
              decoration: BoxDecoration(
                color: hair,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: height * 0.22,
            child: Container(
              width: height * 0.46,
              height: height * 0.58,
              decoration: BoxDecoration(
                color: clothing,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
