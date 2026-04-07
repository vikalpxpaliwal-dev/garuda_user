import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/features/search/presentation/data/search_listing_catalog.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Mesh Gradient Background
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
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
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
                                      color: AppColors.primaryOrange.withValues(
                                        alpha: 0.4,
                                      ),
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
                                : Column(
                                    key: const ValueKey<String>('results'),
                                    children: searchListingCatalog
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            child: SearchListingCard(
                                              listing: entry.value,
                                              onViewDetails: () {
                                                context.push(
                                                  AppRoutes.searchListingDetails(
                                                    entry.key,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
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
  }
}
