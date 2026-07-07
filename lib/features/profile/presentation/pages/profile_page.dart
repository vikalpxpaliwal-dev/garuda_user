import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/widgets/app_content_width.dart';
import 'package:garuda_user_app/core/widgets/app_mesh_background.dart';
import 'package:garuda_user_app/core/widgets/app_page_shell.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_state.dart';
import 'package:garuda_user_app/features/profile/presentation/profile_feature_bloc_builder.dart';
import 'package:garuda_user_app/features/profile/presentation/profile_feature_state.dart';
import 'package:go_router/go_router.dart';

part '../mappers/profile_ui_mappers.dart';
part '../widgets/profile_wishlist_panel.dart';
part '../widgets/profile_journey_card.dart';
part '../widgets/profile_tracking_panel.dart';
part '../widgets/profile_tracking_cart.dart';
part '../widgets/profile_visits_hub.dart';
part '../widgets/profile_visits_primary.dart';
part '../widgets/profile_shared_widgets.dart';


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
      context.read<AvailabilityBloc>().add(const GetAvailabilitiesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileFeatureBlocBuilder(
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
            BlocListener<AvailabilityBloc, AvailabilityState>(
              listenWhen: (previous, current) =>
                  previous.createStatus != current.createStatus,
              listener: (context, availabilityState) {
                if (availabilityState.createStatus ==
                    CreateAvailabilityStatus.success) {
                  context.read<AvailabilityBloc>().add(
                    const GetAvailabilitiesRequested(),
                  );
                  context.read<WishlistBloc>().add(const WishlistRequested());
                  setState(() {
                    _selectedLandIds.clear();
                    _selectedTrackingIndex = 0;
                    _isTrackingJourney = true;
                    _selectedStage = _TrackingStage.availability;
                    _selectedVisitsHubList = _VisitsHubList.primaryVisit;
                  });
                } else if (availabilityState.createStatus ==
                    CreateAvailabilityStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    availabilityState.errorMessage ??
                        'Failed to create availability',
                  );
                }
              },
            ),
            BlocListener<CartBloc, CartState>(
              listenWhen: (previous, current) =>
                  previous.createStatus != current.createStatus,
              listener: (context, cartState) {
                if (cartState.createStatus == CreateCartStatus.success) {
                  context.read<CartBloc>().add(const GetCartRequested());
                  setState(() {
                    _selectedStage = _TrackingStage.payment;
                  });
                } else if (cartState.createStatus == CreateCartStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    cartState.createErrorMessage ?? 'Failed to add to cart',
                  );
                }
              },
            ),
            BlocListener<CartBloc, CartState>(
              listenWhen: (previous, current) =>
                  previous.paymentStatus != current.paymentStatus,
              listener: (context, cartState) {
                if (cartState.paymentStatus == CreatePaymentStatus.success) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    'Payment successful! Now select date and time for visit.',
                  );
                } else if (cartState.paymentStatus ==
                    CreatePaymentStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    cartState.paymentErrorMessage ?? 'Payment failed',
                  );
                }
              },
            ),
            BlocListener<VisitsBloc, VisitsState>(
              listenWhen: (previous, current) =>
                  previous.createStatus != current.createStatus,
              listener: (context, visitsState) {
                if (visitsState.createStatus == CreateVisitStatus.success) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    'Visit scheduled successfully!',
                  );
                  setState(() {
                    _selectedStage = _TrackingStage.visitsHub;
                    _selectedVisitsHubList = _VisitsHubList.primaryVisit;
                  });
                  context.read<VisitsBloc>().add(const GetVisitsRequested());
                } else if (visitsState.createStatus ==
                    CreateVisitStatus.failure) {
                  AppScaffoldMessage.showError(
                    context,
                    visitsState.createErrorMessage ??
                        'Failed to schedule visit',
                  );
                }
              },
            ),
            BlocListener<ShortlistBloc, ShortlistState>(
              listenWhen: (previous, current) =>
                  previous.shortlistStatus != current.shortlistStatus,
              listener: (context, shortlistState) {
                if (shortlistState.shortlistStatus ==
                        CreateShortlistStatus.success &&
                    shortlistState.shortlistMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    shortlistState.shortlistMessage!,
                  );
                } else if (shortlistState.shortlistStatus ==
                        CreateShortlistStatus.failure &&
                    shortlistState.shortlistMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    shortlistState.shortlistMessage!,
                  );
                }
              },
            ),
            BlocListener<ShortlistBloc, ShortlistState>(
              listenWhen: (previous, current) =>
                  previous.deleteShortlistStatus !=
                  current.deleteShortlistStatus,
              listener: (context, shortlistState) {
                if (shortlistState.deleteShortlistStatus ==
                        DeleteShortlistStatus.success &&
                    shortlistState.deleteShortlistMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    shortlistState.deleteShortlistMessage!,
                  );
                } else if (shortlistState.deleteShortlistStatus ==
                        DeleteShortlistStatus.failure &&
                    shortlistState.deleteShortlistMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    shortlistState.deleteShortlistMessage!,
                  );
                }
              },
            ),
            BlocListener<ShortlistBloc, ShortlistState>(
              listenWhen: (previous, current) =>
                  previous.createFinalStatus != current.createFinalStatus,
              listener: (context, shortlistState) {
                if (shortlistState.createFinalStatus ==
                        CreateFinalStatus.success &&
                    shortlistState.finalMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    shortlistState.finalMessage!,
                  );
                } else if (shortlistState.createFinalStatus ==
                        CreateFinalStatus.failure &&
                    shortlistState.finalMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    shortlistState.finalMessage!,
                  );
                }
              },
            ),
            BlocListener<ShortlistBloc, ShortlistState>(
              listenWhen: (previous, current) =>
                  previous.deleteFinalStatus != current.deleteFinalStatus,
              listener: (context, shortlistState) {
                if (shortlistState.deleteFinalStatus ==
                        DeleteFinalStatus.success &&
                    shortlistState.deleteFinalMessage != null) {
                  AppScaffoldMessage.showSuccess(
                    context,
                    shortlistState.deleteFinalMessage!,
                  );
                } else if (shortlistState.deleteFinalStatus ==
                        DeleteFinalStatus.failure &&
                    shortlistState.deleteFinalMessage != null) {
                  AppScaffoldMessage.showError(
                    context,
                    shortlistState.deleteFinalMessage!,
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: context.colors.surface,
            floatingActionButton: _buildProfileFab(context, state),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
            body: AppPageShell(
              meshVariant: AppMeshBackgroundVariant.tab,
              showSearchAction: false,
              slivers: <Widget>[
                AppContentWidthBox.sliver(
                  padding: EdgeInsets.fromLTRB(
                    context.spacing.screenPadding,
                    context.spacing.xl,
                    context.spacing.screenPadding,
                    _profileScrollBottomPadding(context, state),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const _ProfileHeader(),
                      const SizedBox(height: 18),
                      _CollectionTabs(
                        selectedTab: _selectedTab,
                        onChanged: (tab) {
                          if (tab == _ProfileCollectionTab.wishlist) {
                            context.read<WishlistBloc>().add(
                              const WishlistRequested(),
                            );
                            context.read<AvailabilityBloc>().add(
                              const GetAvailabilitiesRequested(),
                            );
                          } else if (tab ==
                              _ProfileCollectionTab.myLands) {
                            context.read<ShortlistBloc>().add(
                              const GetFinalsRequested(),
                            );
                          }

                          setState(() {
                            _selectedTab = tab;
                            _selectedLandIds.clear();
                            _selectedStage = _TrackingStage.availability;
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivePanel({
    required BuildContext context,
    required ProfileFeatureState state,
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
                context.read<CartBloc>().add(
                  CreateCartRequested(landIds: _cartLandIds.toList()),
                );
              },
        onPaymentProceed: state.cartItems.isEmpty
            ? null
            : () {
                context.read<CartBloc>().add(
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
            context.read<CartBloc>().add(const GetCartRequested());
          } else if (stage == _TrackingStage.visitsHub) {
            context.read<VisitsBloc>().add(const GetVisitsRequested());
          }
        },
        selectedVisitsHubList: _selectedVisitsHubList,
        onVisitsHubListChanged: (list) {
          setState(() {
            _selectedVisitsHubList = list;
          });
          if (list == _VisitsHubList.primaryVisit) {
            context.read<VisitsBloc>().add(const GetVisitsRequested());
          } else if (list == _VisitsHubList.shortlist) {
            context.read<ShortlistBloc>().add(const GetShortlistsRequested());
          } else if (list == _VisitsHubList.finalList) {
            context.read<ShortlistBloc>().add(const GetFinalsRequested());
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
    if (state.wishlistStatus == WishlistStatus.loading &&
        wishlistJourneys.isEmpty) {
      return const _WishlistLoadingPanel(
        key: ValueKey<String>('wishlist-loading'),
      );
    }

    if (state.wishlistStatus == WishlistStatus.failure &&
        wishlistJourneys.isEmpty) {
      return _WishlistErrorPanel(
        key: const ValueKey<String>('wishlist-failure'),
        message: state.wishlistErrorMessage ?? 'Failed to load wishlist.',
        onRetry: () =>
            context.read<WishlistBloc>().add(const WishlistRequested()),
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

  static const double _profilePrimaryFabSize = 62;
  static const double _profileSecondaryFabSize = 44;
  static const double _profileStackedFabGap = 10;
  static const double _shellBottomNavContentHeight = 52;

  double _shellBottomNavHeight(BuildContext context) {
    return _shellBottomNavContentHeight +
        MediaQuery.paddingOf(context).bottom;
  }

  double _activeFabHeight(ProfileFeatureState state) {
    if (!_isTrackingJourney) {
      if (_selectedTab == _ProfileCollectionTab.wishlist &&
          _selectedLandIds.isNotEmpty) {
        return _profilePrimaryFabSize;
      }
      return 0;
    }

    if (_selectedStage == _TrackingStage.visitsHub) {
      return _profileSecondaryFabSize * 2 + _profileStackedFabGap;
    }

    if (_selectedStage == _TrackingStage.payment &&
        state.paymentStatus == CreatePaymentStatus.success) {
      return _profilePrimaryFabSize;
    }

    if (_selectedStage == _TrackingStage.availability &&
        _cartLandIds.isNotEmpty) {
      return _profilePrimaryFabSize;
    }

    return _profileSecondaryFabSize;
  }

  double _profileScrollBottomPadding(
    BuildContext context,
    ProfileFeatureState state,
  ) {
    final bottomNavHeight = _shellBottomNavHeight(context);
    final fabHeight = _activeFabHeight(state);
    if (fabHeight <= 0) {
      return bottomNavHeight + context.spacing.lg;
    }
    return bottomNavHeight + fabHeight + context.spacing.lg;
  }

  Widget? _buildProfileFab(BuildContext context, ProfileFeatureState state) {
    if (_isTrackingJourney) {
      if (_selectedStage == _TrackingStage.visitsHub) {
        return const _VisitsHubFloatingActions();
      }

      if (_selectedStage == _TrackingStage.payment &&
          state.paymentStatus == CreatePaymentStatus.success) {
        return _AvailabilityArrowButton(
          onTap: () {
            if (_selectedVisitDate == null || _selectedVisitTime == null) {
              AppScaffoldMessage.showError(
                context,
                'Please select a visit date and time from the card.',
              );
              return;
            }

            final parsedVisitDate = DateTime.tryParse(_selectedVisitDate!);
            final today = DateTime.now();
            final todayDateOnly = DateTime(today.year, today.month, today.day);
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

            context.read<VisitsBloc>().add(
              CreateVisitRequested(
                landIds: state.cartItems.map((e) => e.landId).toList(),
                visitDate: _selectedVisitDate!,
                time: _selectedVisitTime!,
              ),
            );
          },
          isLoading: state.visitStatus == CreateVisitStatus.loading,
        );
      }

      if (_selectedStage == _TrackingStage.availability &&
          _cartLandIds.isNotEmpty) {
        return _AvailabilityArrowButton(
          onTap: () {
            context.read<CartBloc>().add(
              CreateCartRequested(landIds: _cartLandIds.toList()),
            );
          },
          isLoading: state.cartStatus == CreateCartStatus.loading,
        );
      }

      return _TrackingFloatingButton(onTap: _closeTrackingJourney);
    }

    if (_selectedTab == _ProfileCollectionTab.wishlist &&
        _selectedLandIds.isNotEmpty) {
      return _AvailabilityArrowButton(
        onTap: () {
          context.read<AvailabilityBloc>().add(
            CreateAvailabilityRequested(landIds: _selectedLandIds.toList()),
          );
        },
        isLoading: state.availabilityStatus == CreateAvailabilityStatus.loading,
      );
    }

    return null;
  }
}
