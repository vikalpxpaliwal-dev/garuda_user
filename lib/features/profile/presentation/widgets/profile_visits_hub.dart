part of '../pages/profile_page.dart';

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
    final profileState = profileFeatureStateOf(context);
    final land = item.land;
    final palette = _palettes[item.id % _palettes.length];
    final title =
        'LAND #${land.id} • ${land.mandal.isEmpty ? 'LOCATION' : land.mandal.toUpperCase()}';
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
                                  context.read<ShortlistBloc>().add(
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
                                      context.read<ShortlistBloc>().add(
                                        DeleteFinalRequested(
                                          landId: item.landId,
                                        ),
                                      );
                                    })
                            : (isDeleteShortlistLoading
                                  ? null
                                  : () {
                                      context.read<ShortlistBloc>().add(
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



