import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';
import 'dart:math';

class LandMapper {
  static SearchListingUiModel toUiModel(LandEntity land) {
    final details = land.landDetails;
    
    // Choose artwork based on ID or soil type for consistency
    final artworkType = _getArtworkType(land.id);

    return SearchListingUiModel(
      title: 'Near ${land.village}',
      price: 'Rs.${_formatPrice(details.totalValue)}',
      availability: land.landStatus.isNotEmpty 
          ? land.landStatus.first.toUpperCase() 
          : 'AVAILABLE',
      area: '${details.totalAcres} ac ${details.guntas} gts',
      water: details.waterSource.isNotEmpty ? details.waterSource.first : 'Borewell',
      soilType: details.soilType,
      distance: 'Pending', // Distance not in API currently, setting default
      artworkType: artworkType,
      detailSections: _buildDetailSections(land),
      documentStatuses: land.documents.map((doc) => doc.docType).toList(),
    );
  }

  static SearchListingArtworkType _getArtworkType(int id) {
    // Deterministic selection based on ID
    final index = id % 3;
    switch (index) {
      case 0: return SearchListingArtworkType.cityWalk;
      case 1: return SearchListingArtworkType.forestRoad;
      case 2: return SearchListingArtworkType.cityBridge;
      default: return SearchListingArtworkType.cityWalk;
    }
  }

  static String _formatPrice(double value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    }
    return value.toStringAsFixed(0);
  }

  static List<SearchListingDetailSection> _buildDetailSections(LandEntity land) {
    final details = land.landDetails;
    return [
      SearchListingDetailSection(
        title: 'OVERVIEW & MONEY',
        fields: [
          const SearchListingDetailField(label: 'OWNER TYPE', value: 'Verified Farmer'),
          SearchListingDetailField(
            label: 'AVAILABILITY', 
            value: land.landStatus.join(', '),
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'PRICE PER ACRE', 
            value: 'Rs.${_formatPrice(details.pricePerAcres)}',
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'TOTAL VALUE', 
            value: 'Rs.${_formatPrice(details.totalValue)}',
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
          SearchListingDetailField(label: 'VILLAGE', value: land.village),
        ],
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
