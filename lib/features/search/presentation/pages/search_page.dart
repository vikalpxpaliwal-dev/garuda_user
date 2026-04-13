import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>()..add(const GetLandsEvent()),
      child: Scaffold(
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
                                  : BlocBuilder<SearchBloc, SearchState>(
                                      builder: (context, state) {
                                        if (state.status ==
                                            SearchStatus.loading) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(40),
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryOrange,
                                              ),
                                            ),
                                          );
                                        }

                                        if (state.status ==
                                            SearchStatus.failure) {
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
                                                  state.errorMessage ??
                                                      'Failed to load lands',
                                                ),
                                                TextButton(
                                                  onPressed: () => context
                                                      .read<SearchBloc>()
                                                      .add(
                                                        const GetLandsEvent(),
                                                      ),
                                                  child:
                                                      const Text('Try Again'),
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
                                          key:
                                              const ValueKey<String>('results'),
                                          children: state.lands.map((land) {
                                            final uiModel =
                                                LandMapper.toUiModel(land);

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              child: SearchListingCard(
                                                listing: uiModel,
                                                onViewDetails: () {
                                                  context.push(
                                                    AppRoutes.searchDetails,
                                                    extra:
                                                        SearchListingDetailArgs(
                                                      land: land,
                                                      searchBloc: context
                                                          .read<SearchBloc>(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
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
      ),
    );
  }
}
