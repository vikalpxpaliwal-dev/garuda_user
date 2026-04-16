import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfileCollectionTab _selectedTab = _ProfileCollectionTab.wishlist;
  _TrackingStage _selectedStage = _TrackingStage.availability;
  _VisitsHubList _selectedVisitsHubList = _VisitsHubList.primaryVisit;
  final Set<int> _selectedLandIds = <int>{};
  // cart: lands the user has tapped "VISIT CART" on
  final Set<int> _cartLandIds = <int>{};
  int _selectedTrackingIndex = 0;
  bool _isTrackingJourney = false;
  String? _selectedVisitDate;
  String? _selectedVisitTime;

  void _closeTrackingJourney() {
    setState(() {
      _isTrackingJourney = false;
      _selectedStage = _TrackingStage.availability;
      _selectedVisitsHubList = _VisitsHubList.primaryVisit;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load wishlist and existing availability data when the screen first mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileBloc>()
        ..add(const WishlistRequested())
        ..add(const GetAvailabilitiesRequested())
        ..add(const GetFinalsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final wishlistJourneys = _ProfileWishlistMapper.toUiModels(
          state.wishlistItems,
        );
        final activeJourneys = _ProfileAvailabilityMapper.toUiModels(
          state.availabilityItems,
        );
        final finalLandsJourneys = _ProfileOwnedLandMapper.toUiModels(
          state.finalItems,
        );

        // Keep wishlist (selectable) and active (tracked) lists separate.
        // Selection panel shows wishlistJourneys only.
        // Detail panel shows the current activeJourney.
        final safeTrackingIndex = _safeSelectedTrackingIndex(activeJourneys);
        final currentJourney = activeJourneys.isNotEmpty
            ? activeJourneys[safeTrackingIndex]
            : null;

        return MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.availabilityStatus != current.availabilityStatus,
              listener: (context, state) {
                if (state.availabilityStatus ==
                    CreateAvailabilityStatus.success) {
                  context.read<ProfileBloc>().add(
                    const GetAvailabilitiesRequested(),
                  );
                  setState(() {
                    _selectedLandIds.clear();
                    _selectedTrackingIndex = 0;
                    _isTrackingJourney = true;
                    _selectedStage = _TrackingStage.availability;
                    _selectedVisitsHubList = _VisitsHubList.primaryVisit;
                  });
                } else if (state.availabilityStatus ==
                    CreateAvailabilityStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    state.availabilityErrorMessage ??
                        'Failed to create availability',
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.cartStatus != current.cartStatus,
              listener: (context, state) {
                if (state.cartStatus == CreateCartStatus.success) {
                  context.read<ProfileBloc>().add(const GetCartRequested());
                  setState(() {
                    _selectedStage = _TrackingStage.payment;
                  });
                } else if (state.cartStatus == CreateCartStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    state.cartErrorMessage ?? 'Failed to add to cart',
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.paymentStatus != current.paymentStatus,
              listener: (context, state) {
                if (state.paymentStatus == CreatePaymentStatus.success) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    'Payment successful! Now select date and time for visit.',
                  );
                } else if (state.paymentStatus == CreatePaymentStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    state.paymentErrorMessage ?? 'Payment failed',
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.visitStatus != current.visitStatus,
              listener: (context, state) {
                if (state.visitStatus == CreateVisitStatus.success) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    'Visit scheduled successfully!',
                  );
                  setState(() {
                    _selectedStage = _TrackingStage.visitsHub;
                    _selectedVisitsHubList = _VisitsHubList.primaryVisit;
                  });
                  context.read<ProfileBloc>().add(const GetVisitsRequested());
                } else if (state.visitStatus == CreateVisitStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    state.visitErrorMessage ?? 'Failed to schedule visit',
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.shortlistStatus != current.shortlistStatus,
              listener: (context, state) {
                if (state.shortlistStatus == CreateShortlistStatus.success &&
                    state.shortlistMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    state.shortlistMessage!,
                  );
                } else if (state.shortlistStatus ==
                        CreateShortlistStatus.failure &&
                    state.shortlistMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    state.shortlistMessage!,
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.deleteShortlistStatus !=
                  current.deleteShortlistStatus,
              listener: (context, state) {
                if (state.deleteShortlistStatus ==
                        DeleteShortlistStatus.success &&
                    state.deleteShortlistMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    state.deleteShortlistMessage!,
                  );
                } else if (state.deleteShortlistStatus ==
                        DeleteShortlistStatus.failure &&
                    state.deleteShortlistMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    state.deleteShortlistMessage!,
                  );
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.createFinalStatus != current.createFinalStatus,
              listener: (context, state) {
                if (state.createFinalStatus == CreateFinalStatus.success &&
                    state.finalMessage != null) {
                  AppScaffoldMessage.showSuccess(context, state.finalMessage!);
                } else if (state.createFinalStatus ==
                        CreateFinalStatus.failure &&
                    state.finalMessage != null) {
                  AppScaffoldMessage.showError(context, state.finalMessage!);
                }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.deleteFinalStatus != current.deleteFinalStatus,
              listener: (context, state) {
                if (state.deleteFinalStatus == DeleteFinalStatus.success &&
                    state.deleteFinalMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    state.deleteFinalMessage!,
                  );
                } else if (state.deleteFinalStatus ==
                        DeleteFinalStatus.failure &&
                    state.deleteFinalMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    state.deleteFinalMessage!,
                  );
                }
              },
            ),
          ],
          child: Material(
            color: AppColors.softBackground,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.softBackground,
                      gradient: RadialGradient(
                        center: Alignment(0.8, -0.6),
                        radius: 1.2,
                        colors: <Color>[
                          Color(0xFFFFF9F2),
                          AppColors.softBackground,
                        ],
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
                    const CommonSliverAppBar(showSearchAction: false),
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 24, 18, 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const _ProfileHeader(),
                                const SizedBox(height: 18),
                                _CollectionTabs(
                                  selectedTab: _selectedTab,
                                  onChanged: (tab) {
                                    if (tab == _ProfileCollectionTab.wishlist) {
                                      context.read<ProfileBloc>().add(
                                        const WishlistRequested(),
                                      );
                                      context.read<ProfileBloc>().add(
                                        const GetAvailabilitiesRequested(),
                                      );
                                    } else if (tab ==
                                        _ProfileCollectionTab.myLands) {
                                      context.read<ProfileBloc>().add(
                                        const GetFinalsRequested(),
                                      );
                                    }

                                    setState(() {
                                      _selectedTab = tab;
                                      _selectedLandIds.clear();
                                      _selectedStage =
                                          _TrackingStage.availability;
                                      _selectedVisitsHubList =
                                          _VisitsHubList.primaryVisit;
                                      _isTrackingJourney = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 18),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 220),
                                  child: _buildActivePanel(
                                    context: context,
                                    state: state,
                                    wishlistJourneys: wishlistJourneys,
                                    activeJourneys: activeJourneys,
                                    currentJourney: currentJourney,
                                    finalLandsJourneys: finalLandsJourneys,
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
                Positioned(
                  right: 16,
                  bottom: 18,
                  child: SafeArea(
                    top: false,
                    child: _isTrackingJourney
                        // On Visits Hub tab → show visit hub actions
                        ? _selectedStage == _TrackingStage.visitsHub
                              ? const _VisitsHubFloatingActions()
                              // On Payment tab with payment success -> Schedule Visit FAB
                              : _selectedStage == _TrackingStage.payment &&
                                    state.paymentStatus ==
                                        CreatePaymentStatus.success
                              ? _AvailabilityArrowButton(
                                  onTap: () {
                                    if (_selectedVisitDate == null ||
                                        _selectedVisitTime == null) {
                                      AppScaffoldMessage.showError(
                                        context,
                                        'Please select a visit date and time from the card.',
                                      );
                                      return;
                                    }

                                    final parsedVisitDate = DateTime.tryParse(
                                      _selectedVisitDate!,
                                    );
                                    final today = DateTime.now();
                                    final todayDateOnly = DateTime(
                                      today.year,
                                      today.month,
                                      today.day,
                                    );
                                    if (parsedVisitDate == null ||
                                        DateTime(
                                          parsedVisitDate.year,
                                          parsedVisitDate.month,
                                          parsedVisitDate.day,
                                        ).isBefore(todayDateOnly)) {
                                      AppScaffoldMessage.showError(
                                        context,
                                        'Please select today or a future visit date.',
                                      );
                                      return;
                                    }

                                    context.read<ProfileBloc>().add(
                                      CreateVisitRequested(
                                        landIds: state.cartItems
                                            .map((e) => e.landId)
                                            .toList(),
                                        visitDate: _selectedVisitDate!,
                                        time: _selectedVisitTime!,
                                      ),
                                    );
                                  },
                                  isLoading:
                                      state.visitStatus ==
                                      CreateVisitStatus.loading,
                                )
                              // On Availability tab with items in cart → PROCEED FAB
                              : _selectedStage == _TrackingStage.availability &&
                                    _cartLandIds.isNotEmpty
                              ? _AvailabilityArrowButton(
                                  onTap: () {
                                    context.read<ProfileBloc>().add(
                                      CreateCartRequested(
                                        landIds: _cartLandIds.toList(),
                                      ),
                                    );
                                  },
                                  isLoading:
                                      state.cartStatus ==
                                      CreateCartStatus.loading,
                                )
                              // Otherwise → Back / close button
                              : _TrackingFloatingButton(
                                  onTap: _closeTrackingJourney,
                                )
                        // Selection view → Arrow FAB when lands selected
                        : _selectedTab == _ProfileCollectionTab.wishlist &&
                              _selectedLandIds.isNotEmpty
                        ? _AvailabilityArrowButton(
                            onTap: () {
                              context.read<ProfileBloc>().add(
                                CreateAvailabilityRequested(
                                  landIds: _selectedLandIds.toList(),
                                ),
                              );
                            },
                            isLoading:
                                state.availabilityStatus ==
                                CreateAvailabilityStatus.loading,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivePanel({
    required BuildContext context,
    required ProfileState state,
    required List<_TrackedLandUiModel> wishlistJourneys,
    required List<_TrackedLandUiModel> activeJourneys,
    required _TrackedLandUiModel? currentJourney,
    required List<_OwnedLandUiModel> finalLandsJourneys,
  }) {
    // ── Detail view (Availability / Payment / Visits Hub tabs) ──────────────
    if (_isTrackingJourney) {
      // Show spinner while GET API populates the list
      if (state.getAvailabilityStatus == GetAvailabilityStatus.loading ||
          activeJourneys.isEmpty) {
        return const Center(
          key: ValueKey<String>('tracking-loading'),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(color: AppColors.primaryOrange),
          ),
        );
      }

      return _TrackingJourneyPanel(
        key: const ValueKey<String>('tracking'),
        journeys: activeJourneys,
        cartLandIds: _cartLandIds,
        selectedStage: _selectedStage,
        onBack: _closeTrackingJourney,
        onVisitCart: (landId) {
          // Toggle the land in/out of cart — do NOT auto-navigate
          setState(() {
            if (_cartLandIds.contains(landId)) {
              _cartLandIds.remove(landId);
            } else {
              _cartLandIds.add(landId);
            }
          });
        },
        onCartProceed: _cartLandIds.isEmpty
            ? null
            : () {
                context.read<ProfileBloc>().add(
                  CreateCartRequested(landIds: _cartLandIds.toList()),
                );
              },
        onPaymentProceed: state.cartItems.isEmpty
            ? null
            : () {
                context.read<ProfileBloc>().add(
                  CreatePaymentRequested(
                    landIds: state.cartItems.map((e) => e.landId).toList(),
                    amount: 50000,
                  ),
                );
              },
        isCartLoading: state.cartStatus == CreateCartStatus.loading,
        cartItems: state.cartItems,
        getCartStatus: state.getCartStatus,
        paymentStatus: state.paymentStatus,
        selectedVisitDate: _selectedVisitDate,
        selectedVisitTime: _selectedVisitTime,
        onVisitDateSelected: (date) {
          setState(() {
            _selectedVisitDate = date;
          });
        },
        onVisitTimeSelected: (time) {
          setState(() {
            _selectedVisitTime = time;
          });
        },
        onStageChanged: (stage) {
          setState(() {
            _selectedStage = stage;
            if (stage == _TrackingStage.visitsHub) {
              _selectedVisitsHubList = _VisitsHubList.primaryVisit;
            }
          });
          // Fetch cart data when user navigates to Payment tab
          if (stage == _TrackingStage.payment) {
            context.read<ProfileBloc>().add(const GetCartRequested());
          } else if (stage == _TrackingStage.visitsHub) {
            context.read<ProfileBloc>().add(const GetVisitsRequested());
          }
        },
        selectedVisitsHubList: _selectedVisitsHubList,
        onVisitsHubListChanged: (list) {
          setState(() {
            _selectedVisitsHubList = list;
          });
          if (list == _VisitsHubList.primaryVisit) {
            context.read<ProfileBloc>().add(const GetVisitsRequested());
          } else if (list == _VisitsHubList.shortlist) {
            context.read<ProfileBloc>().add(const GetShortlistsRequested());
          } else if (list == _VisitsHubList.finalList) {
            context.read<ProfileBloc>().add(const GetFinalsRequested());
          }
        },
        visitItems: state.visitItems,
        getVisitsStatus: state.getVisitsStatus,
        visitItemsErrorMessage: state.visitItemsErrorMessage,
        shortlistItems: state.shortlistItems,
        getShortlistsStatus: state.getShortlistsStatus,
        shortlistItemsErrorMessage: state.shortlistItemsErrorMessage,
        finalItems: state.finalItems,
        getFinalsStatus: state.getFinalsStatus,
        finalItemsErrorMessage: state.finalItemsErrorMessage,
      );
    }

    // ── My Lands tab ────────────────────────────────────────────────────────
    if (_selectedTab == _ProfileCollectionTab.myLands) {
      if (state.getFinalsStatus == GetFinalsStatus.loading &&
          finalLandsJourneys.isEmpty) {
        return const Center(
          key: ValueKey<String>('my-lands-loading'),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(color: AppColors.primaryOrange),
          ),
        );
      }

      if (finalLandsJourneys.isEmpty) {
        return const _WishlistEmptyPanel(key: ValueKey<String>('myland-empty'));
      }

      return _MyLandsPanel(
        key: const ValueKey<String>('my-lands'),
        lands: finalLandsJourneys,
      );
    }

    // ── Wishlist tab – selection panel ───────────────────────────────────────
    if (state.wishlistStatus == ProfileWishlistStatus.loading &&
        wishlistJourneys.isEmpty) {
      return const _WishlistLoadingPanel(
        key: ValueKey<String>('wishlist-loading'),
      );
    }

    if (state.wishlistStatus == ProfileWishlistStatus.failure &&
        wishlistJourneys.isEmpty) {
      return _WishlistErrorPanel(
        key: const ValueKey<String>('wishlist-failure'),
        message: state.wishlistErrorMessage ?? 'Failed to load wishlist.',
        onRetry: () =>
            context.read<ProfileBloc>().add(const WishlistRequested()),
      );
    }

    if (wishlistJourneys.isEmpty) {
      return const _WishlistEmptyPanel(key: ValueKey<String>('wishlist-empty'));
    }

    // All wishlist lands are selectable. Tapping toggles selection only.
    return _JourneySelectionPanel(
      key: const ValueKey<String>('selection'),
      journeys: wishlistJourneys,
      selectedLandIds: _selectedLandIds,
      onJourneyTapped: (index) {
        final id = wishlistJourneys[index].id;
        setState(() {
          if (_selectedLandIds.contains(id)) {
            _selectedLandIds.remove(id);
          } else {
            _selectedLandIds.add(id);
          }
        });
      },
    );
  }

  int _safeSelectedTrackingIndex(List<_TrackedLandUiModel> journeys) {
    if (journeys.isEmpty) {
      return 0;
    }

    if (_selectedTrackingIndex < 0) {
      return 0;
    }

    if (_selectedTrackingIndex >= journeys.length) {
      return journeys.length - 1;
    }

    return _selectedTrackingIndex;
  }
}

enum _ProfileCollectionTab { wishlist, myLands }

enum _TrackingStage { availability, payment, visitsHub }

enum _VisitsHubList { primaryVisit, shortlist, finalList }

class _TrackedLandUiModel {
  const _TrackedLandUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.trailingLabel,
    required this.primaryMetricLabel,
    required this.primaryMetricValue,
    required this.secondaryMetricLabel,
    required this.secondaryMetricValue,
    required this.availabilityBadge,
    required this.palette,
  });

  final int id;
  final String title;
  final String subtitle;
  final String trailingLabel;
  final String primaryMetricLabel;
  final String primaryMetricValue;
  final String secondaryMetricLabel;
  final String secondaryMetricValue;
  final String availabilityBadge;
  final List<Color> palette;
}

class _OwnedLandUiModel {
  const _OwnedLandUiModel({
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final String priceLabel;
  final List<Color> palette;
}

class _ProfileAvailabilityMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  static List<_TrackedLandUiModel> toUiModels(List<AvailabilityEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];

      return _TrackedLandUiModel(
        id: land.id,
        title:
            '${_ProfileWishlistMapper._capitalize(land.village)} - ${_ProfileWishlistMapper._capitalize(land.mandal)}',
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        trailingLabel: _ProfileWishlistMapper._normalizeLabel(
          item.status,
          fallback: 'ACTIVE',
        ),
        primaryMetricLabel: 'FORM STATUS',
        primaryMetricValue: _ProfileWishlistMapper._normalizeLabel(
          land.formStatus,
          fallback: 'UNKNOWN',
        ),
        secondaryMetricLabel: 'VERIFICATION',
        secondaryMetricValue: land.verificationPackage
            ? 'VERIFIED'
            : 'STANDARD',
        availabilityBadge: 'TRACKING',
        palette: palette,
      );
    }).toList();
  }
}

class _ProfileOwnedLandMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF11253D), Color(0xFF526B7E), Color(0xFFDEE8F0)],
    <Color>[Color(0xFF23495C), Color(0xFF7CA5B8), Color(0xFFF6E6B3)],
  ];

  static List<_OwnedLandUiModel> toUiModels(List<ShortlistItemEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];

      return _OwnedLandUiModel(
        title:
            '${_ProfileWishlistMapper._capitalize(land.village)} - ${_ProfileWishlistMapper._capitalize(land.mandal)}',
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        priceLabel: 'TBD',
        palette: palette,
      );
    }).toList();
  }
}

class _ProfileWishlistMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  static List<_TrackedLandUiModel> toUiModels(List<WishlistItemEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];
      final availabilityBadge = _normalizeLabel(
        land.landStatus.isNotEmpty ? land.landStatus.first : land.availability,
        fallback: 'WISHLISTED',
      );

      return _TrackedLandUiModel(
        id: land.id,
        title: '${_capitalize(land.village)} - ${_capitalize(land.mandal)}',
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        trailingLabel: _normalizeLabel(land.availability, fallback: 'ACTIVE'),
        primaryMetricLabel: 'FORM STATUS',
        primaryMetricValue: _normalizeLabel(
          land.formStatus,
          fallback: 'UNKNOWN',
        ),
        secondaryMetricLabel: 'VERIFICATION',
        secondaryMetricValue: land.verificationPackage
            ? 'VERIFIED'
            : 'STANDARD',
        availabilityBadge: availabilityBadge,
        palette: palette,
      );
    }).toList();
  }

  static String _normalizeLabel(String value, {required String fallback}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return fallback;
    }

    return trimmed.toUpperCase();
  }

  static String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Land';
    }

    final lower = trimmed.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final initial = state.user?.name.isNotEmpty == true
            ? state.user!.name[0].toUpperCase()
            : 'U';
        final name = state.user?.name ?? 'Profile';

        return GestureDetector(
          onTap: () => context.go(AppRoutes.editProfile),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8D7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.lightLine.withValues(alpha: 0.5),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.deepOrange.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: AppColors.deepOrange,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'ACTIVE MEMBER',
                    style: TextStyle(
                      color: AppColors.deepOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionTabs extends StatelessWidget {
  const _CollectionTabs({required this.selectedTab, required this.onChanged});

  final _ProfileCollectionTab selectedTab;
  final ValueChanged<_ProfileCollectionTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _CollectionTabButton(
              icon: Icons.favorite_border_rounded,
              label: 'Wishlist',
              isSelected: selectedTab == _ProfileCollectionTab.wishlist,
              onTap: () => onChanged(_ProfileCollectionTab.wishlist),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CollectionTabButton(
              icon: Icons.cottage_outlined,
              label: 'My Lands',
              isSelected: selectedTab == _ProfileCollectionTab.myLands,
              onTap: () => onChanged(_ProfileCollectionTab.myLands),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionTabButton extends StatelessWidget {
  const _CollectionTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.white,
                      AppColors.softBackground.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: isSelected
                ? Border.all(color: AppColors.lightLine.withValues(alpha: 0.6))
                : null,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.deepOrange : AppColors.mutedText,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? AppColors.ink : AppColors.mutedText,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneySelectionPanel extends StatelessWidget {
  const _JourneySelectionPanel({
    required this.journeys,
    required this.selectedLandIds,
    required this.onJourneyTapped,
    super.key,
  });

  final List<_TrackedLandUiModel> journeys;
  final Set<int> selectedLandIds;
  final ValueChanged<int> onJourneyTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _JourneySectionHeader(),
        const SizedBox(height: 14),
        ...journeys.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _JourneyCard(
              journey: entry.value,
              isSelected: selectedLandIds.contains(entry.value.id),
              onTap: () => onJourneyTapped(entry.key),
            ),
          ),
        ),
      ],
    );
  }
}

class _WishlistLoadingPanel extends StatelessWidget {
  const _WishlistLoadingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }
}

class _WishlistErrorPanel extends StatelessWidget {
  const _WishlistErrorPanel({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.deepOrange,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _WishlistEmptyPanel extends StatelessWidget {
  const _WishlistEmptyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: key,
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      child: const Column(
        children: <Widget>[
          Icon(
            Icons.favorite_border_rounded,
            size: 34,
            color: AppColors.deepOrange,
          ),
          SizedBox(height: 12),
          Text(
            'YOUR WISHLIST IS EMPTY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add lands from the search details screen to see them here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyLandsPanel extends StatelessWidget {
  const _MyLandsPanel({required this.lands, super.key});

  final List<_OwnedLandUiModel> lands;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'LIST OF LANDS',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.add_rounded, size: 14, color: AppColors.white),
                      SizedBox(width: 6),
                      Text(
                        'LIST NEW LAND',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...lands.map(
          (land) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OwnedLandCard(land: land),
          ),
        ),
      ],
    );
  }
}

class _JourneySectionHeader extends StatelessWidget {
  const _JourneySectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'SELECT LAND JOURNEY',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'CHOOSE PROPERTIES TO TRACK PROGRESS.',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.track_changes_rounded,
          size: 18,
          color: AppColors.primaryOrange.withValues(alpha: 0.75),
        ),
      ],
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.journey,
    required this.isSelected,
    required this.onTap,
  });

  final _TrackedLandUiModel journey;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            gradient: LinearGradient(
              colors: [
                AppColors.white,
                isSelected
                    ? AppColors.softBackground.withValues(alpha: 0.5)
                    : AppColors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.deepOrange
                  : AppColors.lightLine.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.ink.withValues(
                  alpha: isSelected ? 0.08 : 0.04,
                ),
                blurRadius: isSelected ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.deepOrange : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepOrange
                        : AppColors.lightLine,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: AppColors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              _JourneyThumbnail(colors: journey.palette),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      journey.title,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      journey.subtitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                journey.trailingLabel,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnedLandCard extends StatelessWidget {
  const _OwnedLandCard({required this.land});

  final _OwnedLandUiModel land;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      child: Row(
        children: <Widget>[
          _OwnedLandThumbnail(colors: land.palette),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  land.title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.deepOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      land.subtitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            land.priceLabel,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingJourneyPanel extends StatelessWidget {
  const _TrackingJourneyPanel({
    required this.journeys,
    required this.cartLandIds,
    required this.selectedStage,
    required this.onBack,
    required this.onVisitCart,
    required this.onCartProceed,
    required this.onPaymentProceed,
    required this.isCartLoading,
    required this.cartItems,
    required this.getCartStatus,
    required this.paymentStatus,
    required this.selectedVisitDate,
    required this.selectedVisitTime,
    required this.onVisitDateSelected,
    required this.onVisitTimeSelected,
    required this.onStageChanged,
    required this.selectedVisitsHubList,
    required this.onVisitsHubListChanged,
    required this.visitItems,
    required this.getVisitsStatus,
    required this.visitItemsErrorMessage,
    required this.shortlistItems,
    required this.getShortlistsStatus,
    required this.shortlistItemsErrorMessage,
    required this.finalItems,
    required this.getFinalsStatus,
    required this.finalItemsErrorMessage,
    super.key,
  });

  final List<_TrackedLandUiModel> journeys;
  final Set<int> cartLandIds;
  final _TrackingStage selectedStage;
  final VoidCallback onBack;
  final ValueChanged<int> onVisitCart;
  final VoidCallback? onCartProceed;
  final VoidCallback? onPaymentProceed;
  final bool isCartLoading;
  final List<CartItemEntity> cartItems;
  final GetCartStatus getCartStatus;
  final CreatePaymentStatus paymentStatus;
  final String? selectedVisitDate;
  final String? selectedVisitTime;
  final ValueChanged<String> onVisitDateSelected;
  final ValueChanged<String> onVisitTimeSelected;
  final ValueChanged<_TrackingStage> onStageChanged;
  final _VisitsHubList selectedVisitsHubList;
  final ValueChanged<_VisitsHubList> onVisitsHubListChanged;
  final List<VisitItemEntity> visitItems;
  final GetVisitsStatus getVisitsStatus;
  final String? visitItemsErrorMessage;
  final List<ShortlistItemEntity> shortlistItems;
  final GetShortlistsStatus getShortlistsStatus;
  final String? shortlistItemsErrorMessage;
  final List<ShortlistItemEntity> finalItems;
  final GetFinalsStatus getFinalsStatus;
  final String? finalItemsErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 16,
                    color: AppColors.mutedText,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'BACK TO SELECTION',
                    style: TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _TrackingStageTabs(
          selectedStage: selectedStage,
          onChanged: onStageChanged,
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (selectedStage) {
            _TrackingStage.availability => Column(
              key: const ValueKey<String>('availability-stage'),
              children: journeys
                  .map(
                    (j) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _TrackedJourneyDetailCard(
                        journey: j,
                        isInCart: cartLandIds.contains(j.id),
                        onVisitCart: () => onVisitCart(j.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
            _TrackingStage.payment => _TrackedJourneyPaymentCard(
              key: const ValueKey<String>('payment-stage'),
              cartCount: cartItems.length,
              onProceed: onPaymentProceed,
              isLoading: paymentStatus == CreatePaymentStatus.loading,
              cartItems: cartItems,
              getCartStatus: getCartStatus,
              paymentStatus: paymentStatus,
              selectedVisitDate: selectedVisitDate,
              selectedVisitTime: selectedVisitTime,
              onVisitDateSelected: onVisitDateSelected,
              onVisitTimeSelected: onVisitTimeSelected,
            ),
            _TrackingStage.visitsHub => _VisitsHubCard(
              key: const ValueKey<String>('visits-stage'),
              selectedList: selectedVisitsHubList,
              onChanged: onVisitsHubListChanged,
              visitItems: visitItems,
              getVisitsStatus: getVisitsStatus,
              visitItemsErrorMessage: visitItemsErrorMessage,
              shortlistItems: shortlistItems,
              getShortlistsStatus: getShortlistsStatus,
              shortlistItemsErrorMessage: shortlistItemsErrorMessage,
              finalItems: finalItems,
              getFinalsStatus: getFinalsStatus,
              finalItemsErrorMessage: finalItemsErrorMessage,
            ),
          },
        ),
      ],
    );
  }
}

class _TrackingStageTabs extends StatelessWidget {
  const _TrackingStageTabs({
    required this.selectedStage,
    required this.onChanged,
  });

  final _TrackingStage selectedStage;
  final ValueChanged<_TrackingStage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _TrackingStageButton(
              icon: Icons.radio_button_checked_rounded,
              label: 'AVAILABILITY',
              isSelected: selectedStage == _TrackingStage.availability,
              onTap: () => onChanged(_TrackingStage.availability),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TrackingStageButton(
              icon: Icons.receipt_long_outlined,
              label: 'PAYMENT',
              isSelected: selectedStage == _TrackingStage.payment,
              onTap: () => onChanged(_TrackingStage.payment),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TrackingStageButton(
              icon: Icons.near_me_outlined,
              label: 'VISITS HUB',
              isSelected: selectedStage == _TrackingStage.visitsHub,
              onTap: () => onChanged(_TrackingStage.visitsHub),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingStageButton extends StatelessWidget {
  const _TrackingStageButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.white,
                      AppColors.softBackground.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 13,
                color: isSelected ? AppColors.deepOrange : AppColors.mutedText,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? AppColors.ink : AppColors.mutedText,
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackedJourneyDetailCard extends StatelessWidget {
  const _TrackedJourneyDetailCard({
    required this.journey,
    required this.isInCart,
    required this.onVisitCart,
  });

  final _TrackedLandUiModel journey;
  final bool isInCart;
  final VoidCallback onVisitCart;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          _TrackedJourneyHeroArtwork(journey: journey),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _JourneyMetric(
                        label: journey.primaryMetricLabel,
                        value: journey.primaryMetricValue,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: _JourneyMetric(
                        label: journey.secondaryMetricLabel,
                        value: journey.secondaryMetricValue,
                        alignment: CrossAxisAlignment.end,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'FULL DETAILS'.toUpperCase(),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TrackingActionButton(
                        label: isInCart ? '✓ IN CART' : 'VISIT CART',
                        isFilled: !isInCart,
                        foregroundColor: isInCart ? AppColors.deepOrange : null,
                        onTap: onVisitCart,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'REMOVE'.toUpperCase(),
                        foregroundColor: AppColors.deepOrange,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackedJourneyPaymentCard extends StatelessWidget {
  const _TrackedJourneyPaymentCard({
    required this.cartCount,
    required this.onProceed,
    required this.isLoading,
    required this.cartItems,
    required this.getCartStatus,
    required this.paymentStatus,
    required this.selectedVisitDate,
    required this.selectedVisitTime,
    required this.onVisitDateSelected,
    required this.onVisitTimeSelected,
    super.key,
  });

  final int cartCount;
  final VoidCallback? onProceed;
  final bool isLoading;
  final List<CartItemEntity> cartItems;
  final GetCartStatus getCartStatus;
  final CreatePaymentStatus paymentStatus;
  final String? selectedVisitDate;
  final String? selectedVisitTime;
  final ValueChanged<String> onVisitDateSelected;
  final ValueChanged<String> onVisitTimeSelected;

  static const int _visitWindowDays = 7;
  static const List<String> _weekdayLabels = <String>[
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  static const List<String> _visitTimes = <String>[
    '10:30',
    '11:30',
    '14:00',
    '16:30',
  ];

  List<({String apiDate, String date, String day, bool isPast})>
  _dynamicVisitDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List<
      ({String apiDate, String date, String day, bool isPast})
    >.generate(_visitWindowDays, (index) {
      final visitDate = today.add(Duration(days: index));
      final apiDate =
          '${visitDate.year}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}';

      return (
        apiDate: apiDate,
        date: visitDate.day.toString(),
        day: _weekdayLabels[visitDate.weekday - 1],
        isPast: visitDate.isBefore(today),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitDates = _dynamicVisitDates();
    final isPaymentCompleted = paymentStatus == CreatePaymentStatus.success;
    final isActionDisabled =
        isLoading || isPaymentCompleted || onProceed == null;
    final buttonLabel = isPaymentCompleted
        ? 'PAYMENT COMPLETED'
        : cartCount == 0
        ? 'ADD LANDS TO CART'
        : 'PROCEED TO PAYMENT ($cartCount LAND${cartCount == 1 ? '' : 'S'})';

    return CustomCard(
      key: key,
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.access_time_rounded,
                size: 15,
                color: AppColors.deepOrange,
              ),
              SizedBox(width: 8),
              Text(
                'CONSOLIDATED VISIT DATE',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.lightLine.withValues(alpha: 0.4),
                ),
                bottom: BorderSide(
                  color: AppColors.lightLine.withValues(alpha: 0.4),
                ),
              ),
            ),
            child: Row(
              children: visitDates
                  .map(
                    (visitDate) => Expanded(
                      child: GestureDetector(
                        onTap: visitDate.isPast
                            ? null
                            : () {
                                onVisitDateSelected(visitDate.apiDate);
                              },
                        behavior: HitTestBehavior.opaque,
                        child: _VisitDateChip(
                          date: visitDate.date,
                          day: visitDate.day,
                          isSelected: selectedVisitDate == visitDate.apiDate,
                          isDisabled: visitDate.isPast,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: <Widget>[
              Icon(
                Icons.schedule_rounded,
                size: 15,
                color: AppColors.deepOrange,
              ),
              SizedBox(width: 8),
              Text(
                'VISIT TIME',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: _visitTimes
                .map(
                  (time) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          onVisitTimeSelected(
                            '$time:00',
                          ); // append seconds for API
                        },
                        child: _VisitTimeChip(
                          time: time,
                          isSelected:
                              selectedVisitTime?.startsWith(time) ?? false,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.lightLine.withValues(alpha: 0.4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 15,
                        color: AppColors.deepOrange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'BATCH SUMMARY',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PaymentSummaryRow(
                    label: 'SELECTED PROPERTIES',
                    value: '$cartCount LAND${cartCount == 1 ? '' : 'S'}',
                  ),
                  const SizedBox(height: 8),
                  const _PaymentSummaryRow(
                    label: 'TOTAL LAND VALUE',
                    value: 'Rs.0.00 Cr',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: _DashedLine(),
                  ),
                  const _PaymentSummaryRow(
                    label: 'SERVICE FEE',
                    value: 'Rs 0',
                    isAccent: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isActionDisabled ? null : onProceed,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                padding: EdgeInsets.zero,
                foregroundColor: AppColors.white,
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor: AppColors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: isActionDisabled
                      ? LinearGradient(
                          colors: [
                            AppColors.mutedText.withValues(alpha: 0.55),
                            AppColors.mutedText.withValues(alpha: 0.45),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [
                            AppColors.deepOrange,
                            AppColors.primaryOrange,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isActionDisabled
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.deepOrange.withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.2,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPaymentCompleted
                                    ? Icons.verified_rounded
                                    : Icons.account_balance_wallet_rounded,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                buttonLabel,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'SECURE PAYMENT POWERED BY GARUDA. COORDINATION STARTS AFTER PAYMENT.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 5.8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ),
          // ── Cart land list from GET /buyer/cart ────────────────────────────
          const SizedBox(height: 20),
          if (getCartStatus == GetCartStatus.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              ),
            )
          else if (cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'NO ITEMS IN CART',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            )
          else
            Column(
              children: cartItems
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _CartLandRow(item: item),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

// ── Cart land row card (matches design: hero image, badges, action buttons) ─
class _CartLandRow extends StatelessWidget {
  const _CartLandRow({required this.item});

  final CartItemEntity item;

  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  @override
  Widget build(BuildContext context) {
    final land = item.land;
    final palette = _palettes[item.id % _palettes.length];
    final title =
        '${land.village.isEmpty ? 'Land' : land.village} - ${land.mandal.isEmpty ? '' : land.mandal}';
    final subtitle =
        '${land.district.toUpperCase()} • ${land.state.toUpperCase()}';
    final badge = land.landStatus.isNotEmpty
        ? land.landStatus.first.toUpperCase()
        : land.availability.toUpperCase();
    final formStatus = land.formStatus.toUpperCase();

    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          // Hero artwork
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(27)),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: palette,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  // Dot indicator
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  // Title + subtitle
                  Positioned(
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body: metrics + action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _JourneyMetric(
                        label: 'FORM STATUS',
                        value: formStatus,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: _JourneyMetric(
                        label: 'VERIFICATION',
                        value: land.verificationPackage
                            ? 'VERIFIED'
                            : 'STANDARD',
                        alignment: CrossAxisAlignment.end,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'VIEW FULL DETAILS',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'REMOVE FROM LIST',
                        foregroundColor: AppColors.deepOrange,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryVisitLandRow extends StatelessWidget {
  const _PrimaryVisitLandRow({required this.item});

  final VisitItemEntity item;

  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  @override
  Widget build(BuildContext context) {
    final land = item.land;
    final profileState = context.watch<ProfileBloc>().state;
    final palette = _palettes[item.id % _palettes.length];
    final title =
        '${land.village.isEmpty ? 'LAND' : land.village.toUpperCase()}${land.mandal.isEmpty ? '' : ' • ${land.mandal.toUpperCase()}'}';
    final subtitle = land.district.toUpperCase();
    final wasShortlistedFromApi =
        item.meetingStatus.toLowerCase() == 'shortlisted';
    final isShortlisted =
        wasShortlistedFromApi ||
        profileState.shortlistedLandIds.contains(item.landId);
    final isShortlistLoading =
        profileState.shortlistStatus == CreateShortlistStatus.loading &&
        profileState.activeShortlistLandId == item.landId;
    final isDeleteShortlistLoading =
        profileState.deleteShortlistStatus == DeleteShortlistStatus.loading &&
        profileState.activeDeleteShortlistLandId == item.landId;
    final badge = isShortlisted
        ? 'SHORTLISTED'
        : item.meetingStatus.toUpperCase();
    final availabilityBadge = land.landStatus.isNotEmpty
        ? land.landStatus.first.toUpperCase()
        : land.availability.toUpperCase();

    //not getting response for price
    final visitDate = item.visitDate.year == 1970
        ? 'TBD'
        : '${item.visitDate.day.toString().padLeft(2, '0')}/${item.visitDate.month.toString().padLeft(2, '0')}/${item.visitDate.year}';
    final visitTime = item.time.isEmpty ? 'TBD' : item.time.substring(0, 5);

    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(27)),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: palette,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            availabilityBadge,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        if (isShortlisted) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepOrange,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'SHORTLISTED',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        if (!isShortlisted) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 7.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _JourneyMetric(
                        label: 'VISIT DATE',
                        value: visitDate,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: _JourneyMetric(
                        label: 'VISIT TIME',
                        value: visitTime,
                        alignment: CrossAxisAlignment.end,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'VIEW FULL DETAILS',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isShortlisted) ...[
                      Expanded(
                        child: _TrackingActionButton(
                          label: 'SHORTLIST',
                          isFilled: true,
                          isLoading: isShortlistLoading,
                          onTap: isShortlistLoading
                              ? null
                              : () {
                                  context.read<ProfileBloc>().add(
                                    CreateShortlistRequested(
                                      landId: item.landId,
                                    ),
                                  );
                                },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: _TrackingActionButton(
                        label: 'REMOVE FROM THIS LIST',
                        foregroundColor: AppColors.deepOrange,
                        isLoading: isDeleteShortlistLoading,
                        onTap: isDeleteShortlistLoading
                            ? null
                            : () {
                                context.read<ProfileBloc>().add(
                                  DeleteShortlistRequested(landId: item.landId),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitTimeChip extends StatelessWidget {
  const _VisitTimeChip({required this.time, required this.isSelected});

  final String time;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.white
            : AppColors.softBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.deepOrange
              : AppColors.lightLine.withValues(alpha: 0.6),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? AppColors.deepOrange : AppColors.mutedText,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _VisitDateChip extends StatelessWidget {
  const _VisitDateChip({
    required this.date,
    required this.day,
    required this.isSelected,
    this.isDisabled = false,
  });

  final String date;
  final String day;
  final bool isSelected;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDisabled
                ? AppColors.lightLine.withValues(alpha: 0.35)
                : isSelected
                ? AppColors.white
                : AppColors.softBackground.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDisabled
                  ? AppColors.lightLine.withValues(alpha: 0.7)
                  : isSelected
                  ? AppColors.deepOrange
                  : AppColors.lightLine.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected && !isDisabled
                ? [
                    BoxShadow(
                      color: AppColors.deepOrange.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              date,
              style: TextStyle(
                color: isDisabled
                    ? AppColors.mutedText.withValues(alpha: 0.5)
                    : isSelected
                    ? AppColors.deepOrange
                    : AppColors.mutedText,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            color: isDisabled
                ? AppColors.mutedText.withValues(alpha: 0.5)
                : AppColors.mutedText,
            fontSize: 6,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
    required this.label,
    required this.value,
    this.isAccent = false,
  });

  final String label;
  final String value;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final color = isAccent ? Colors.deepOrangeAccent : AppColors.ink;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isAccent ? AppColors.deepOrange : AppColors.mutedText,
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / 7).floor();

          return Row(
            children: List<Widget>.generate(
              dashCount,
              (_) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  color: AppColors.lightLine,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VisitsHubCard extends StatelessWidget {
  const _VisitsHubCard({
    required this.selectedList,
    required this.onChanged,
    required this.visitItems,
    required this.getVisitsStatus,
    required this.visitItemsErrorMessage,
    required this.shortlistItems,
    required this.getShortlistsStatus,
    required this.shortlistItemsErrorMessage,
    required this.finalItems,
    required this.getFinalsStatus,
    required this.finalItemsErrorMessage,
    super.key,
  });

  final _VisitsHubList selectedList;
  final ValueChanged<_VisitsHubList> onChanged;
  final List<VisitItemEntity> visitItems;
  final GetVisitsStatus getVisitsStatus;
  final String? visitItemsErrorMessage;
  final List<ShortlistItemEntity> shortlistItems;
  final GetShortlistsStatus getShortlistsStatus;
  final String? shortlistItemsErrorMessage;
  final List<ShortlistItemEntity> finalItems;
  final GetFinalsStatus getFinalsStatus;
  final String? finalItemsErrorMessage;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: key,
      color: AppColors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine),
      padding: const EdgeInsets.all(6),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _VisitsHubTabButton(
                  label: 'PRIMARY VISIT',
                  isSelected: selectedList == _VisitsHubList.primaryVisit,
                  onTap: () => onChanged(_VisitsHubList.primaryVisit),
                ),
              ),
              Expanded(
                child: _VisitsHubTabButton(
                  label: 'SHORTLIST',
                  isSelected: selectedList == _VisitsHubList.shortlist,
                  onTap: () => onChanged(_VisitsHubList.shortlist),
                ),
              ),
              Expanded(
                child: _VisitsHubTabButton(
                  label: 'FINAL LIST',
                  isSelected: selectedList == _VisitsHubList.finalList,
                  onTap: () => onChanged(_VisitsHubList.finalList),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedList == _VisitsHubList.primaryVisit)
            _PrimaryVisitList(
              visitItems: visitItems,
              getVisitsStatus: getVisitsStatus,
              visitItemsErrorMessage: visitItemsErrorMessage,
            )
          else if (selectedList == _VisitsHubList.shortlist)
            _ShortlistHubList(
              shortlistItems: shortlistItems,
              isLoading: getShortlistsStatus == GetShortlistsStatus.loading,
              hasFailure: getShortlistsStatus == GetShortlistsStatus.failure,
              errorMessage: shortlistItemsErrorMessage,
              showOnlyFinalized: false,
            )
          else if (selectedList == _VisitsHubList.finalList)
            _ShortlistHubList(
              shortlistItems: finalItems,
              isLoading: getFinalsStatus == GetFinalsStatus.loading,
              hasFailure: getFinalsStatus == GetFinalsStatus.failure,
              errorMessage: finalItemsErrorMessage,
              showOnlyFinalized: true,
            )
          else
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 20, 12, 16),
              child: Text(
                'This list is ready for the next workflow.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PrimaryVisitList extends StatelessWidget {
  const _PrimaryVisitList({
    required this.visitItems,
    required this.getVisitsStatus,
    required this.visitItemsErrorMessage,
  });

  final List<VisitItemEntity> visitItems;
  final GetVisitsStatus getVisitsStatus;
  final String? visitItemsErrorMessage;

  @override
  Widget build(BuildContext context) {
    if (getVisitsStatus == GetVisitsStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    if (getVisitsStatus == GetVisitsStatus.failure) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.deepOrange,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              visitItemsErrorMessage ?? 'Failed to load primary visits.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    if (visitItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 16),
        child: Text(
          'No primary visits available yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      children: visitItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _PrimaryVisitLandRow(item: item),
            ),
          )
          .toList(),
    );
  }
}

class _ShortlistHubList extends StatelessWidget {
  const _ShortlistHubList({
    required this.shortlistItems,
    required this.isLoading,
    required this.hasFailure,
    required this.errorMessage,
    required this.showOnlyFinalized,
  });

  final List<ShortlistItemEntity> shortlistItems;
  final bool isLoading;
  final bool hasFailure;
  final String? errorMessage;
  final bool showOnlyFinalized;

  @override
  Widget build(BuildContext context) {
    if (isLoading && shortlistItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
      );
    }

    if (hasFailure && shortlistItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.deepOrange,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ??
                  (showOnlyFinalized
                      ? 'Failed to load final list items.'
                      : 'Failed to load shortlist items.'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    if (shortlistItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
        child: Text(
          showOnlyFinalized
              ? 'No final-choice lands available yet.'
              : 'No shortlisted lands available yet.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      children: shortlistItems
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ShortlistLandRow(
                item: item,
                showFinalChoice: showOnlyFinalized,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ShortlistLandRow extends StatelessWidget {
  const _ShortlistLandRow({required this.item, required this.showFinalChoice});

  final ShortlistItemEntity item;
  final bool showFinalChoice;

  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileBloc>().state;
    final land = item.land;
    final palette = _palettes[item.id % _palettes.length];
    final title =
        'LAND #${land.id} • ${land.village.isEmpty ? 'LOCATION' : land.village.toUpperCase()}';
    final subtitle = land.district.isEmpty
        ? land.state.toUpperCase()
        : land.district.toUpperCase();
    final availabilityBadge = land.landStatus.isNotEmpty
        ? land.landStatus.first.toUpperCase()
        : land.availability.toUpperCase();
    final updatedOn =
        '${item.updatedAt.day.toString().padLeft(2, '0')}/${item.updatedAt.month.toString().padLeft(2, '0')}/${item.updatedAt.year}';
    final isFinalizeLoading =
        profileState.createFinalStatus == CreateFinalStatus.loading &&
        profileState.activeFinalLandId == item.landId;
    final isDeleteFinalLoading =
        profileState.deleteFinalStatus == DeleteFinalStatus.loading &&
        profileState.activeDeleteFinalLandId == item.landId;
    final isDeleteShortlistLoading =
        profileState.deleteShortlistStatus == DeleteShortlistStatus.loading &&
        profileState.activeDeleteShortlistLandId == item.landId;

    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(27)),
            child: Container(
              height: 156,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: palette,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.02),
                            Colors.black.withValues(alpha: 0.36),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        _HeroBadge(
                          label: availabilityBadge,
                          backgroundColor: AppColors.forestGreen,
                        ),
                        const SizedBox(height: 8),
                        const _HeroBadge(
                          label: 'SHORTLISTED',
                          backgroundColor: AppColors.deepOrange,
                        ),
                        if (showFinalChoice) ...[
                          const SizedBox(height: 8),
                          const _HeroBadge(
                            label: 'FINAL CHOICE',
                            backgroundColor: AppColors.forestGreen,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on_outlined,
                              size: 11,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _JourneyMetric(
                        label: 'FORM STATUS',
                        value: land.formStatus.toUpperCase(),
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: _JourneyMetric(
                        label: 'UPDATED ON',
                        value: updatedOn,
                        alignment: CrossAxisAlignment.end,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const _DashedLine(),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: _TrackingActionButton(
                        label: 'VIEW FULL DETAILS',
                        onTap: () {},
                      ),
                    ),
                    if (!showFinalChoice) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TrackingActionButton(
                          label: 'FINALIZE',
                          isFilled: true,
                          foregroundColor: AppColors.white,
                          isLoading: isFinalizeLoading,
                          onTap: isFinalizeLoading
                              ? null
                              : () {
                                  context.read<ProfileBloc>().add(
                                    CreateFinalRequested(landId: item.landId),
                                  );
                                },
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: _TrackingActionButton(
                        label: 'REMOVE FROM THIS LIST',
                        foregroundColor: const Color(0xFFFF4D4F),
                        isLoading: showFinalChoice
                            ? isDeleteFinalLoading
                            : isDeleteShortlistLoading,
                        onTap: showFinalChoice
                            ? (isDeleteFinalLoading
                                  ? null
                                  : () {
                                      context.read<ProfileBloc>().add(
                                        DeleteFinalRequested(
                                          landId: item.landId,
                                        ),
                                      );
                                    })
                            : (isDeleteShortlistLoading
                                  ? null
                                  : () {
                                      context.read<ProfileBloc>().add(
                                        DeleteShortlistRequested(
                                          landId: item.landId,
                                        ),
                                      );
                                    }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _VisitsHubTabButton extends StatelessWidget {
  const _VisitsHubTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.white,
                      AppColors.softBackground.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.deepOrange : AppColors.ink,
                fontSize: 8.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisitsHubFloatingActions extends StatelessWidget {
  const _VisitsHubFloatingActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _VisitsHubFab(icon: Icons.phone_in_talk_rounded),
        SizedBox(height: 10),
        _VisitsHubFab(icon: Icons.call_rounded),
      ],
    );
  }
}

class _VisitsHubFab extends StatelessWidget {
  const _VisitsHubFab({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.deepOrange,
            gradient: const LinearGradient(
              colors: [AppColors.deepOrange, AppColors.primaryOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: AppColors.white),
        ),
      ),
    );
  }
}

class _OwnedLandThumbnail extends StatelessWidget {
  const _OwnedLandThumbnail({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 44,
        height: 44,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: -2,
                right: -2,
                bottom: -4,
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 10,
                child: Transform.rotate(
                  angle: -0.18,
                  child: Container(
                    width: 28,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                bottom: 7,
                child: Transform.rotate(
                  angle: -0.42,
                  child: Container(
                    width: 20,
                    height: 5,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyThumbnail extends StatelessWidget {
  const _JourneyThumbnail({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 42,
        height: 42,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: -6,
                bottom: -8,
                child: Container(
                  width: 36,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Positioned(
                right: -3,
                bottom: -2,
                child: Container(
                  width: 24,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC55A).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 17,
                top: 6,
                child: Container(
                  width: 1.5,
                  height: 28,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackedJourneyHeroArtwork extends StatelessWidget {
  const _TrackedJourneyHeroArtwork({required this.journey});

  final _TrackedLandUiModel journey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SizedBox(
        height: 182,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      journey.palette[0],
                      journey.palette[1],
                      const Color(0xFFF7F0C8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.68, -0.02),
                    radius: 0.7,
                    colors: <Color>[
                      Colors.white.withValues(alpha: 0.92),
                      Colors.white.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                    stops: const <double>[0, 0.22, 1],
                  ),
                ),
              ),
            ),
            // Inner Shadow Overlay for depth
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            ...List<Widget>.generate(
              7,
              (index) => Positioned(
                left: index < 4 ? 8.0 + (index * 16.0) : null,
                right: index >= 4 ? 8.0 + ((index - 4) * 18.0) : null,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: index.isEven ? 22 : 16,
                    height: 110 + ((index % 3) * 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF081426).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: -8,
              child: Transform.rotate(
                angle: -0.12,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        const Color(0xFF08111D),
                        const Color(0xFF263746).withValues(alpha: 0.92),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3AC45B),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  journey.availabilityBadge,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    journey.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    journey.subtitle.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFFFA462),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyMetric extends StatelessWidget {
  const _JourneyMetric({
    required this.label,
    required this.value,
    required this.alignment,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(
          label,
          textAlign: textAlign,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: textAlign,
          style: const TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TrackingActionButton extends StatelessWidget {
  const _TrackingActionButton({
    required this.label,
    required this.onTap,
    this.isFilled = false,
    this.foregroundColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isFilled;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null || isLoading;
    final textColor =
        foregroundColor ?? (isFilled ? AppColors.white : AppColors.ink);
    final effectiveTextColor = isDisabled
        ? textColor.withValues(alpha: 0.55)
        : textColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isFilled
                ? AppColors.deepOrange.withValues(alpha: isDisabled ? 0.75 : 1)
                : AppColors.white.withValues(alpha: isDisabled ? 0.82 : 1),
            gradient: isFilled
                ? const LinearGradient(
                    colors: [AppColors.deepOrange, AppColors.primaryOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFilled
                  ? AppColors.deepOrange
                  : AppColors.lightLine.withValues(alpha: 0.6),
            ),
            boxShadow: [
              if (isFilled)
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.04),
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
                child: isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isFilled ? AppColors.white : AppColors.deepOrange,
                          ),
                        ),
                      )
                    : Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          color: effectiveTextColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackingFloatingButton extends StatelessWidget {
  const _TrackingFloatingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.deepOrange,
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF6A67C),
                const Color(0xFFF6A67C).withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFFF6A67C).withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.remove_rounded,
            size: 20,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _AvailabilityArrowButton extends StatelessWidget {
  const _AvailabilityArrowButton({
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: AppColors.deepOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          gradient: const LinearGradient(
            colors: [AppColors.deepOrange, Color(0xFFFFA63C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
        ),
      ),
    );
  }
}
