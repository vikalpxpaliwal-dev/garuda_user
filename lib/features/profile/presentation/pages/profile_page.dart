import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Map<_ProfileCollectionTab, List<_TrackedLandUiModel>> _journeys =
      <_ProfileCollectionTab, List<_TrackedLandUiModel>>{
        _ProfileCollectionTab.wishlist: <_TrackedLandUiModel>[
          _TrackedLandUiModel(
            title: '8 AC - CHEVELLA',
            subtitle: 'S RANGAREDDY',
            priceLabel: 'Rs.66.0L/ac',
            pricePerAcreLabel: 'Rs.66.0 Lakhs',
            fullBudgetLabel: 'Rs 49.4L (5.49 Cr)',
            availabilityBadge: 'AVAILABLE FOR SALE',
            palette: <Color>[
              Color(0xFF041E42),
              Color(0xFF0D5C5D),
              Color(0xFFFFB34A),
            ],
          ),
        ],
        _ProfileCollectionTab.myLands: <_TrackedLandUiModel>[
          _TrackedLandUiModel(
            title: '12 AC - KHAJAGUDA',
            subtitle: 'W HYDERABAD',
            priceLabel: 'Rs.78.0L/ac',
            pricePerAcreLabel: 'Rs.78.0 Lakhs',
            fullBudgetLabel: 'Rs 93.6L (9.36 Cr)',
            availabilityBadge: 'HIGH DEMAND LAND',
            palette: <Color>[
              Color(0xFF243B55),
              Color(0xFF141E30),
              Color(0xFFE98B2A),
            ],
          ),
        ],
      };

  static const List<_OwnedLandUiModel> _ownedLands = <_OwnedLandUiModel>[
    _OwnedLandUiModel(
      title: 'MANGO GROVE ESTATE',
      subtitle: 'VIKARABAD + 3 AC',
      priceLabel: 'Rs42.0L',
      palette: <Color>[Color(0xFF11253D), Color(0xFF526B7E), Color(0xFFDEE8F0)],
    ),
    _OwnedLandUiModel(
      title: 'HILLVIEW AGRI PLOT',
      subtitle: 'CHEVELLA + 2 AC',
      priceLabel: 'Rs25.0L',
      palette: <Color>[Color(0xFF23495C), Color(0xFF7CA5B8), Color(0xFFF6E6B3)],
    ),
  ];

  _ProfileCollectionTab _selectedTab = _ProfileCollectionTab.wishlist;
  _TrackingStage _selectedStage = _TrackingStage.availability;
  _VisitsHubList _selectedVisitsHubList = _VisitsHubList.primaryVisit;
  int _selectedJourneyIndex = 0;
  bool _isTrackingJourney = false;

  void _openTrackingJourney() {
    setState(() {
      _isTrackingJourney = true;
      _selectedStage = _TrackingStage.availability;
      _selectedVisitsHubList = _VisitsHubList.primaryVisit;
    });
  }

  void _closeTrackingJourney() {
    setState(() {
      _isTrackingJourney = false;
      _selectedStage = _TrackingStage.availability;
      _selectedVisitsHubList = _VisitsHubList.primaryVisit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final journeys = _journeys[_selectedTab]!;
    final currentJourney = journeys[_selectedJourneyIndex];

    return Material(
      color: AppColors.softBackground,
      child: Stack(
        children: <Widget>[
          // Mesh Background for premium boutique feel
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
                              setState(() {
                                _selectedTab = tab;
                                _selectedJourneyIndex = 0;
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
                            child: _isTrackingJourney
                                ? _TrackingJourneyPanel(
                                    key: const ValueKey<String>('tracking'),
                                    journey: currentJourney,
                                    selectedStage: _selectedStage,
                                    onBack: _closeTrackingJourney,
                                    onStageChanged: (stage) {
                                      setState(() {
                                        _selectedStage = stage;
                                        if (stage == _TrackingStage.visitsHub) {
                                          _selectedVisitsHubList =
                                              _VisitsHubList.primaryVisit;
                                        }
                                      });
                                    },
                                    selectedVisitsHubList:
                                        _selectedVisitsHubList,
                                    onVisitsHubListChanged: (list) {
                                      setState(() {
                                        _selectedVisitsHubList = list;
                                      });
                                    },
                                  )
                                : _selectedTab == _ProfileCollectionTab.wishlist
                                ? _JourneySelectionPanel(
                                    key: const ValueKey<String>('selection'),
                                    journeys: journeys,
                                    selectedJourneyIndex: _selectedJourneyIndex,
                                    onJourneySelected: (index) {
                                      setState(() {
                                        _selectedJourneyIndex = index;
                                      });
                                    },
                                  )
                                : const _MyLandsPanel(
                                    key: ValueKey<String>('my-lands'),
                                    lands: _ownedLands,
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
                  ? _selectedStage == _TrackingStage.visitsHub
                        ? const _VisitsHubFloatingActions()
                        : _TrackingFloatingButton(onTap: _closeTrackingJourney)
                  : _selectedTab == _ProfileCollectionTab.wishlist
                  ? _StartTrackingCta(
                      label:
                          'START TRACKING ${_selectedJourneyIndex + 1} LANDS',
                      onTap: _openTrackingJourney,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProfileCollectionTab { wishlist, myLands }

enum _TrackingStage { availability, payment, visitsHub }

enum _VisitsHubList { primaryVisit, shortlist, finalList }

class _TrackedLandUiModel {
  const _TrackedLandUiModel({
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.pricePerAcreLabel,
    required this.fullBudgetLabel,
    required this.availabilityBadge,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final String priceLabel;
  final String pricePerAcreLabel;
  final String fullBudgetLabel;
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
          onTap: () => context.go('${AppRoutes.profile}/edit-profile'),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8D7),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
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
                    colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
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
    required this.selectedJourneyIndex,
    required this.onJourneySelected,
    super.key,
  });

  final List<_TrackedLandUiModel> journeys;
  final int selectedJourneyIndex;
  final ValueChanged<int> onJourneySelected;

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
              isSelected: selectedJourneyIndex == entry.key,
              onTap: () => onJourneySelected(entry.key),
            ),
          ),
        ),
      ],
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
                    : AppColors.white
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.deepOrange : AppColors.lightLine.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.ink.withValues(alpha: isSelected ? 0.08 : 0.04),
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
                  color: isSelected
                      ? AppColors.deepOrange
                      : Colors.transparent,
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
                journey.priceLabel,
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
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.3)],
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
    required this.journey,
    required this.selectedStage,
    required this.onBack,
    required this.onStageChanged,
    required this.selectedVisitsHubList,
    required this.onVisitsHubListChanged,
    super.key,
  });

  final _TrackedLandUiModel journey;
  final _TrackingStage selectedStage;
  final VoidCallback onBack;
  final ValueChanged<_TrackingStage> onStageChanged;
  final _VisitsHubList selectedVisitsHubList;
  final ValueChanged<_VisitsHubList> onVisitsHubListChanged;

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
            _TrackingStage.availability => _TrackedJourneyDetailCard(
              key: const ValueKey<String>('availability-stage'),
              journey: journey,
            ),
            _TrackingStage.payment => const _TrackedJourneyPaymentCard(
              key: ValueKey<String>('payment-stage'),
            ),
            _TrackingStage.visitsHub => _VisitsHubCard(
              key: const ValueKey<String>('visits-stage'),
              selectedList: selectedVisitsHubList,
              onChanged: onVisitsHubListChanged,
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
                    colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
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
                color: isSelected
                    ? AppColors.deepOrange
                    : AppColors.mutedText,
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
  const _TrackedJourneyDetailCard({required this.journey, super.key});

  final _TrackedLandUiModel journey;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.4)],
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
                        label: 'PRICE PER ACRE',
                        value: journey.pricePerAcreLabel,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: _JourneyMetric(
                        label: 'FULL BUDGET',
                        value: journey.fullBudgetLabel,
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
                        label: 'VISIT CART'.toUpperCase(),
                        isFilled: true,
                        onTap: () {},
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
  const _TrackedJourneyPaymentCard({super.key});

  static const List<({String date, String day, bool isSelected})> _visitDates =
      <({String date, String day, bool isSelected})>[
        (date: '4', day: 'SAT', isSelected: true),
        (date: '5', day: 'SUN', isSelected: false),
        (date: '6', day: 'MON', isSelected: false),
        (date: '7', day: 'TUE', isSelected: false),
        (date: '8', day: 'WED', isSelected: false),
        (date: '9', day: 'THU', isSelected: false),
        (date: '10', day: 'FRI', isSelected: false),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: key,
      gradient: LinearGradient(
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
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
              Icon(Icons.access_time_rounded, size: 15, color: AppColors.deepOrange),
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
              children: _visitDates
                  .map(
                    (visitDate) => Expanded(
                      child: _VisitDateChip(
                        date: visitDate.date,
                        day: visitDate.day,
                        isSelected: visitDate.isSelected,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.4)),
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
                  const _PaymentSummaryRow(
                    label: 'SELECTED PROPERTIES',
                    value: '0 LANDS',
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
          Center(
            child: SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.deepOrange,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size.fromHeight(48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.deepOrange.withValues(alpha: 0.4),
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(AppColors.deepOrange),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.deepOrange, AppColors.primaryOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.account_balance_wallet_rounded, size: 16),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'PAY SERVICE FEE (Rs 0)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
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
        ],
      ),
    );
  }
}

class _VisitDateChip extends StatelessWidget {
  const _VisitDateChip({
    required this.date,
    required this.day,
    required this.isSelected,
  });

  final String date;
  final String day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.softBackground.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.deepOrange : AppColors.lightLine.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              date,
              style: TextStyle(
                color: isSelected
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
          style: const TextStyle(
            color: AppColors.mutedText,
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
    super.key,
  });

  final _VisitsHubList selectedList;
  final ValueChanged<_VisitsHubList> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: key,
      color: AppColors.white,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine),
      padding: const EdgeInsets.all(6),
      child: Row(
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
                    colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
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
  });

  final String label;
  final VoidCallback onTap;
  final bool isFilled;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final textColor =
        foregroundColor ?? (isFilled ? AppColors.white : AppColors.ink);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.deepOrange : AppColors.white,
            gradient: isFilled
                ? const LinearGradient(
                    colors: [AppColors.deepOrange, AppColors.primaryOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFilled ? AppColors.deepOrange : AppColors.lightLine.withValues(alpha: 0.6),
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
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
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

class _StartTrackingCta extends StatelessWidget {
  const _StartTrackingCta({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.deepOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52,
              height: 52,
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
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 22,
                color: AppColors.white,
              ),
            ),
          ],
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
                const Color(0xFFF6A67C).withValues(alpha: 0.8)
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
