import 'package:garuda_user_app/features/search/presentation/models/search_listing_ui_model.dart';

const List<SearchListingUiModel> searchListingCatalog = <SearchListingUiModel>[
  SearchListingUiModel(
    title: 'Near Shadnagar',
    price: 'Rs.74.0L',
    availability: 'AVAILABLE FOR MORTGAGE',
    area: '4 ac 30 gts',
    water: 'Borewell',
    soilType: 'Red',
    distance: '11 km',
    artworkType: SearchListingArtworkType.cityWalk,
    detailSections: <SearchListingDetailSection>[
      SearchListingDetailSection(
        title: 'OVERVIEW & MONEY',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(
            label: 'OWNER TYPE',
            value: 'Verified Farmer',
          ),
          SearchListingDetailField(
            label: 'REGISTRY',
            value: 'Original / Clear',
          ),
          SearchListingDetailField(
            label: 'AVAILABILITY',
            value: 'Available For Mortgage',
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'PRICE PER ACRE',
            value: 'Rs.74.0 Lakhs',
            isAccent: true,
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'AREA & PARCEL',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'LAND AREA', value: '4.30 Acres'),
          SearchListingDetailField(label: 'FRONTAGE', value: '120 ft road'),
          SearchListingDetailField(label: 'SURVEY', value: '14/2 & 14/3'),
          SearchListingDetailField(label: 'PLOT SHAPE', value: 'Rectangular'),
        ],
      ),
      SearchListingDetailSection(
        title: 'MAP & LOCATION',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'VILLAGE', value: 'Shadnagar'),
          SearchListingDetailField(label: 'ZONE', value: 'Agricultural'),
          SearchListingDetailField(label: 'HIGHWAY REACH', value: '11 km'),
          SearchListingDetailField(
            label: 'NEARBY MARKET',
            value: 'Weekly Bazaar',
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'LAND CHARACTERISTICS',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'SOIL', value: 'Red'),
          SearchListingDetailField(label: 'FENCING', value: 'Side fenced'),
          SearchListingDetailField(label: 'TOPOGRAPHY', value: 'Single Level'),
          SearchListingDetailField(label: 'FARM USE', value: 'Fruit / Layout'),
        ],
      ),
      SearchListingDetailSection(
        title: 'WATER RESOURCES',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'BOREWELL', value: 'Available'),
          SearchListingDetailField(label: 'SEASONAL FLOW', value: 'Active'),
          SearchListingDetailField(label: 'PIPELINE', value: 'Nearby'),
          SearchListingDetailField(label: 'TANK', value: '700 m'),
        ],
      ),
    ],
    documentStatuses: <String>['Patta', 'EC Verified', 'Passbook', 'Mutation'],
  ),
  SearchListingUiModel(
    title: 'Near Chevella',
    price: 'Rs.66.0L',
    availability: 'AVAILABLE FOR SALE',
    area: '8 ac 15 gts',
    water: 'Canal',
    soilType: 'Black',
    distance: '12 km',
    artworkType: SearchListingArtworkType.forestRoad,
    detailSections: <SearchListingDetailSection>[
      SearchListingDetailSection(
        title: 'OVERVIEW & MONEY',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'OWNER TYPE', value: 'Single Farmer'),
          SearchListingDetailField(
            label: 'REGISTRY',
            value: 'Original / Clear',
          ),
          SearchListingDetailField(
            label: 'AVAILABILITY',
            value: 'Available For Sale',
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'PRICE PER ACRE',
            value: 'Rs.66.0 Lakhs',
            isAccent: true,
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'AREA & PARCEL',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'LAND AREA', value: '8.15 Acres'),
          SearchListingDetailField(label: 'FRONTAGE', value: '150 ft road'),
          SearchListingDetailField(label: 'SURVEY', value: '31/A & 31/B'),
          SearchListingDetailField(label: 'PLOT SHAPE', value: 'Wide frontage'),
        ],
      ),
      SearchListingDetailSection(
        title: 'MAP & LOCATION',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'VILLAGE', value: 'Chevella'),
          SearchListingDetailField(label: 'ZONE', value: 'Agri / Farmhouse'),
          SearchListingDetailField(label: 'HIGHWAY REACH', value: '12 km'),
          SearchListingDetailField(
            label: 'NEARBY MARKET',
            value: 'Town Center',
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'LAND CHARACTERISTICS',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'SOIL', value: 'Black'),
          SearchListingDetailField(label: 'FENCING', value: 'Fully Fenced'),
          SearchListingDetailField(label: 'TOPOGRAPHY', value: 'Mild Slope'),
          SearchListingDetailField(label: 'FARM USE', value: 'Paddy / Orchard'),
        ],
      ),
      SearchListingDetailSection(
        title: 'WATER RESOURCES',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'CANAL', value: 'Available'),
          SearchListingDetailField(label: 'SEASONAL FLOW', value: 'Strong'),
          SearchListingDetailField(label: 'PIPELINE', value: 'On Road'),
          SearchListingDetailField(label: 'TANK', value: '1.2 km'),
        ],
      ),
    ],
    documentStatuses: <String>['Patta', 'Tax Paid', 'FMB', 'Aadhar Link'],
  ),
  SearchListingUiModel(
    title: 'Near Khajaguda',
    price: 'Rs.82.0L',
    availability: 'AVAILABLE FOR INVESTMENT',
    area: '3 ac 28 gts',
    water: 'Pipeline',
    soilType: 'Mixed',
    distance: '7 km',
    artworkType: SearchListingArtworkType.cityBridge,
    detailSections: <SearchListingDetailSection>[
      SearchListingDetailSection(
        title: 'OVERVIEW & MONEY',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(
            label: 'OWNER TYPE',
            value: 'Family Holding',
          ),
          SearchListingDetailField(
            label: 'REGISTRY',
            value: 'Original / Clear',
          ),
          SearchListingDetailField(
            label: 'AVAILABILITY',
            value: 'Available For Investment',
            isAccent: true,
          ),
          SearchListingDetailField(
            label: 'PRICE PER ACRE',
            value: 'Rs.82.0 Lakhs',
            isAccent: true,
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'AREA & PARCEL',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'LAND AREA', value: '3.28 Acres'),
          SearchListingDetailField(label: 'FRONTAGE', value: '95 ft road'),
          SearchListingDetailField(label: 'SURVEY', value: '18/4 & 18/5'),
          SearchListingDetailField(label: 'PLOT SHAPE', value: 'Corner Parcel'),
        ],
      ),
      SearchListingDetailSection(
        title: 'MAP & LOCATION',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'VILLAGE', value: 'Khajaguda'),
          SearchListingDetailField(label: 'ZONE', value: 'Growth Corridor'),
          SearchListingDetailField(label: 'HIGHWAY REACH', value: '7 km'),
          SearchListingDetailField(label: 'NEARBY MARKET', value: 'Ring Road'),
        ],
      ),
      SearchListingDetailSection(
        title: 'LAND CHARACTERISTICS',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'SOIL', value: 'Mixed'),
          SearchListingDetailField(label: 'FENCING', value: 'Open Sides'),
          SearchListingDetailField(label: 'TOPOGRAPHY', value: 'Gentle Rise'),
          SearchListingDetailField(
            label: 'FARM USE',
            value: 'Investment / Layout',
          ),
        ],
      ),
      SearchListingDetailSection(
        title: 'WATER RESOURCES',
        fields: <SearchListingDetailField>[
          SearchListingDetailField(label: 'PIPELINE', value: 'Available'),
          SearchListingDetailField(label: 'SEASONAL FLOW', value: 'Moderate'),
          SearchListingDetailField(label: 'BORE OPTION', value: 'Feasible'),
          SearchListingDetailField(label: 'TANK', value: '900 m'),
        ],
      ),
    ],
    documentStatuses: <String>['Patta', 'EC Verified', 'Mutation', 'NOC'],
  ),
];
