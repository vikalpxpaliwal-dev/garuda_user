part of '../pages/profile_page.dart';

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
    final profileState = profileFeatureStateOf(context);
    final palette = _palettes[item.id % _palettes.length];
    final title = land.mandal.isEmpty ? 'LAND' : land.mandal.toUpperCase();
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
            child: SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: palette,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  if (land.imageUrl != null && land.imageUrl!.isNotEmpty)
                    Image.network(
                      Uri.encodeFull(land.imageUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white54,
                          size: 32,
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 32,
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
                            style: context.text.microLabel.copyWith(
                              color: AppColors.white,
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
                            child: Text(
                              'SHORTLISTED',
                              style: context.text.microLabel.copyWith(
                                color: AppColors.white,
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
                              style: context.text.microLabel.copyWith(
                                color: AppColors.primaryOrange,
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
                              style: context.text.microLabel.copyWith(
                                color: AppColors.white,
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
                                  context.read<ShortlistBloc>().add(
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
                                context.read<ShortlistBloc>().add(
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
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
          style: context.text.microLabel.copyWith(
            color: isSelected ? AppColors.deepOrange : AppColors.mutedText,
          ),
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
    return SizedBox(
      height: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              style: context.text.caption.copyWith(
                color: isDisabled
                    ? AppColors.mutedText.withValues(alpha: 0.5)
                    : isSelected
                    ? AppColors.deepOrange
                    : AppColors.mutedText,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: context.text.microLabel.copyWith(
            color: isDisabled
                ? AppColors.mutedText.withValues(alpha: 0.5)
                : AppColors.mutedText,
            letterSpacing: 0.25,
          ),
        ),
      ],
      ),
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
            style: context.text.microLabel.copyWith(
              color: isAccent ? AppColors.deepOrange : AppColors.mutedText,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Text(
          value,
          style: context.text.caption.copyWith(
            color: color,
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

