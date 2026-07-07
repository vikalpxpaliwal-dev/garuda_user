part of 'search_listing_detail_page.dart';

class _DetailPropertiesList extends StatelessWidget {
  const _DetailPropertiesList({required this.land, required this.listing});

  final LandEntity land;
  final SearchListingUiModel listing;

  @override
  Widget build(BuildContext context) {
    final useWideLayout = ResponsiveGrid.isExpandedWidth(context);
    final onSurface = context.colors.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRow(
            _buildPropItem(context,
              Icons.verified_outlined,
              'VERIFICATION',
              listing.verificationLabel.toUpperCase(),
            ),
            _buildPropItem(context,
              Icons.access_time,
              'AVAILABILITY',
              listing.availability.toUpperCase(),
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(context,
              Icons.account_balance_outlined,
              'MORTGAGE',
              listing.mortgage,
            ),
            _buildPropItem(context,
              Icons.update,
              'UPDATED',
              listing.updatedLabel.toUpperCase(),
            ),
          ),
          _buildDivider(context),
          _buildRow(
            _buildPropItem(context,
              Icons.location_on_outlined,
              'DISTRICT',
              land.district.toUpperCase(),
            ),
            _buildPropItem(context,
              Icons.location_city_outlined,
              'MANDAL',
              land.mandal.toUpperCase(),
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(context,
              Icons.route_outlined,
              'DISTANCE FROM MANDAL',
              listing.distance.toUpperCase(),
            ),
            const SizedBox(),
          ),
          _buildDivider(context),
          _buildRow(
            _buildPropItem(context,
              Icons.add_road,
              'NEAREST ROAD',
              land.landDetails.nearestRoadType.toUpperCase(),
            ),
            _buildPropItem(context,
              Icons.share_location_outlined,
              'ATTACHED TO ROAD',
              land.landDetails.landAttachedToRoad.toUpperCase(),
            ),
          ),
          _buildDivider(context),
          _buildRow(
            _buildPropItem(context,
              Icons.landscape_outlined,
              'SOIL TYPE',
              land.landDetails.soilType.toUpperCase(),
            ),
            _buildPropItem(context,
              Icons.water_drop_outlined,
              'WATER SOURCE',
              land.landDetails.waterSource.isNotEmpty
                  ? land.landDetails.waterSource.join(', ').toUpperCase()
                  : 'NONE',
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(context,
              Icons.waves,
              'NO. OF BORES',
              land.landDetails.numberOfBores.toString(),
            ),
            _buildPropItem(context,
              Icons.pool_outlined,
              'FARM POND',
              land.landDetails.farmPond ? 'YES' : 'NO',
            ),
          ),
          _buildDivider(context),
          _buildRow(
            _buildPropItem(context,
              Icons.house_outlined,
              'RESIDENCE',
              land.landDetails.residence.isNotEmpty
                  ? land.landDetails.residence.join(', ').toUpperCase()
                  : 'NO',
            ),
            _buildPropItem(context,
              Icons.home_work_outlined,
              'POULTRY SHED',
              land.landDetails.poultryShedNumber > 0
                  ? land.landDetails.poultryShedNumber.toString()
                  : 'NO',
            ),
          ),
          const SizedBox(height: 24),
          _buildRow(
            _buildPropItem(context,
              Icons.pets_outlined,
              'COW SHED',
              land.landDetails.cowShedNumber > 0
                  ? land.landDetails.cowShedNumber.toString()
                  : 'NO',
            ),
            const SizedBox(),
          ),
          _buildDivider(context),
          _buildRow(
            _buildPropItem(context,
              Icons.electric_bolt_outlined,
              'ELECTRICITY',
              land.landDetails.electricity.isNotEmpty
                  ? land.landDetails.electricity.join(', ').toUpperCase()
                  : 'NONE',
            ),
            _buildPropItem(context,
              Icons.fence_outlined,
              'FENCING STATUS',
              land.landDetails.fencingStatus.toUpperCase(),
            ),
          ),
          _buildDivider(context),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.park_outlined,
                  size: 14,
                  color: AppColors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'TREES',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (land.landDetails.trees.isEmpty)
            Text(
              'No trees available',
              style: TextStyle(
                color: context.colors.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            )
          else
            _TreesSection(land: land, useWideLayout: useWideLayout),
          _buildDivider(context),
        ],
      ),
    );
  }

  Widget _buildRow(Widget col1, Widget col2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: col1),
        Expanded(child: col2),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final outline = context.colors.outline;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / (4 + 4)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: 4,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: outline.withValues(alpha: 0.4),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildPropItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final onSurface = context.colors.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.deepOrange),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
