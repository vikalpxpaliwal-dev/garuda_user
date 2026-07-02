part of '../pages/profile_page.dart';
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
    final title = land.mandal.isEmpty ? 'Land' : land.mandal;
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
                image: land.imageUrl != null && land.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(Uri.encodeFull(land.imageUrl!)),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {},
                      )
                    : null,
              ),
              child: Stack(
                children: <Widget>[
                  if (land.imageUrl == null || land.imageUrl!.isEmpty)
                    const Center(
                      child: Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 32),
                    ),
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

