part of '../pages/profile_page.dart';

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
                const SizedBox(height: 12),
                // Availability status indicator
                Builder(
                  builder: (context) {
                    final isAvailable =
                        journey.availabilityStatus?.toLowerCase() == 'available';
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isAvailable
                                ? AppColors.forestGreen
                                : AppColors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAvailable
                              ? 'AVAILABLE FOR VISIT'
                              : 'NOT AVAILABLE FOR VISIT',
                          style: TextStyle(
                            color: isAvailable
                                ? AppColors.forestGreen
                                : AppColors.deepOrange,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    );
                  },
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
                    if (journey.availabilityStatus?.toLowerCase() == 'available') ...<Widget>[
                      Expanded(
                        child: _TrackingActionButton(
                          label: isInCart ? '✓ IN CART' : 'VISIT CART',
                          isFilled: !isInCart,
                          foregroundColor: isInCart ? AppColors.deepOrange : null,
                          onTap: onVisitCart,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
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

