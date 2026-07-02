import 'package:garuda_user_app/core/utils/relative_date_formatter.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';

class LandMapper {
  static const String _unavailable = 'Not available';

  static SearchListingUiModel toUiModel(LandEntity land) {
    final details = land.landDetails;
    final artworkType = _getArtworkType(land.id);

    return SearchListingUiModel(
      title: land.mandal,
      price: '₹${_formatPrice(details.pricePerAcres)}/ac',
      availability: _formatStatus(land.landStatus, fallback: 'AVAILABLE'),
      mortgage: _formatStatus(land.mortgageStatus, fallback: 'N/A'),
      area: '${details.totalAcres} ac ${details.guntas} gts',
      water: details.waterSource.isNotEmpty
          ? details.waterSource.first
          : _unavailable,
      soilType: details.soilType.isNotEmpty ? details.soilType : _unavailable,
      distance: formatDistance(land.nearestTownKm),
      updatedLabel: formatUpdatedLabel(land.updatedAt),
      verificationLabel: formatVerificationLabel(land),
      artworkType: artworkType,
      detailSections: _buildDetailSections(land),
      documentStatuses: land.documents.map((doc) => doc.docType).toList(),
      imageUrl: _pickImageUrl(land.media),
    );
  }

  static String formatDistance(String? nearestTownKm) {
    final km = nearestTownKm?.trim();
    if (km == null || km.isEmpty) return _unavailable;
    return '$km km';
  }

  static String formatUpdatedLabel(DateTime? updatedAt) {
    return RelativeDateFormatter.format(updatedAt);
  }

  static String formatVerificationLabel(LandEntity land) {
    if (land.isVerified) return 'Verified';

    final status = land.verificationStatus?.trim();
    if (status != null && status.isNotEmpty) {
      return _humanizeStatus(status);
    }

    if (land.verificationPackage) return 'Verification package';

    return _unavailable;
  }

  static SearchListingArtworkType _getArtworkType(int id) {
    final index = id % 3;
    switch (index) {
      case 0:
        return SearchListingArtworkType.cityWalk;
      case 1:
        return SearchListingArtworkType.forestRoad;
      case 2:
        return SearchListingArtworkType.cityBridge;
      default:
        return SearchListingArtworkType.cityWalk;
    }
  }

  static String? _pickImageUrl(List<MediaEntity> media) {
    for (final m in media) {
      if (m.type == 'image' && m.category == 'default') return m.url;
    }
    for (final m in media) {
      if (m.type == 'image') return m.url;
    }
    return null;
  }

  static String _formatStatus(List<String> statuses, {required String fallback}) {
    if (statuses.isEmpty) return fallback;
    return statuses.join(', ').toUpperCase();
  }

  static String _humanizeStatus(String value) {
    return value
        .replaceAll('_', ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String _formatPrice(double value) {
    final parts = formatTotalValueParts(value);
    return '${parts.amount}${parts.suffix}';
  }

  static ({String amount, String suffix}) formatTotalValueParts(double value) {
    if (value >= 10000000) {
      return (
        amount: (value / 10000000).toStringAsFixed(2),
        suffix: ' Cr',
      );
    }
    if (value >= 100000) {
      return (
        amount: (value / 100000).toStringAsFixed(1),
        suffix: ' L',
      );
    }
    return (amount: value.toStringAsFixed(0), suffix: '');
  }

  static List<SearchListingDetailSection> _buildDetailSections(LandEntity land) {
    final details = land.landDetails;
    return [
      SearchListingDetailSection(
        title: 'OVERVIEW & MONEY',
        fields: [
          const SearchListingDetailField(label: 'OWNER TYPE', value: 'Verified Farmer'),
          SearchListingDetailField(
            label: 'SALE AVAILABILITY',
            value: _formatStatus(land.landStatus, fallback: 'N/A'),
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'MORTGAGE AVAILABILITY',
            value: _formatStatus(land.mortgageStatus, fallback: 'N/A'),
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'VERIFICATION',
            value: formatVerificationLabel(land),
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'LAST UPDATED',
            value: formatUpdatedLabel(land.updatedAt),
          ),
          SearchListingDetailField(
            label: 'PRICE PER ACRE',
            value: '₹${_formatPrice(details.pricePerAcres)}/ac',
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'TOTAL VALUE',
            value: '₹${_formatPrice(details.totalValue)}',
            isAccent: true,
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'AREA & PARCEL',
        fields: [
          SearchListingDetailField(label: 'LAND AREA', value: '${details.totalAcres} Acres'),
          SearchListingDetailField(label: 'GUNTAS', value: '${details.guntas} Guntas'),
          SearchListingDetailField(label: 'ROAD TYPE', value: details.nearestRoadType),
          SearchListingDetailField(label: 'ATTACHED TO ROAD', value: details.landAttachedToRoad),
        ],
      ),
      SearchListingDetailSection(
        title: 'LOCATION',
        fields: [
          SearchListingDetailField(label: 'STATE', value: land.state),
          SearchListingDetailField(label: 'DISTRICT', value: land.district),
          SearchListingDetailField(label: 'MANDAL', value: land.mandal),
          SearchListingDetailField(
            label: 'DISTANCE',
            value: formatDistance(land.nearestTownKm),
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'TREES DETAIL',
        fields: details.trees
            .map(
              (tree) => SearchListingDetailField(
                label: tree.type.toUpperCase(),
                value: tree.count.toString(),
              ),
            )
            .toList(),
      ),
      SearchListingDetailSection(
        title: 'CHARACTERISTICS',
        fields: [
          SearchListingDetailField(label: 'SOIL', value: details.soilType),
          SearchListingDetailField(label: 'FENCING', value: details.fencingStatus),
          SearchListingDetailField(label: 'ELECTRICITY', value: details.electricity.join(', ')),
          SearchListingDetailField(label: 'RESIDENCE', value: details.residence.join(', ')),
        ],
      ),
      SearchListingDetailSection(
        title: 'RESOURCES',
        fields: [
          SearchListingDetailField(label: 'WATER SOURCE', value: details.waterSource.join(', ')),
          SearchListingDetailField(label: 'BORES', value: details.numberOfBores.toString()),
          SearchListingDetailField(label: 'FARM POND', value: details.farmPond ? 'Available' : 'No'),
        ],
      ),
    ];
  }
}
