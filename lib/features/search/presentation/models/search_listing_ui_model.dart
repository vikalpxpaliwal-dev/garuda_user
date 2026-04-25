enum SearchListingArtworkType { cityWalk, forestRoad, cityBridge }

class SearchListingUiModel {
  const SearchListingUiModel({
    required this.title,
    required this.price,
    required this.availability,
    required this.area,
    required this.water,
    required this.soilType,
    required this.distance,
    required this.artworkType,
    required this.detailSections,
    required this.documentStatuses,
    this.imageUrl,
  });

  final String title;
  final String price;
  final String availability;
  final String area;
  final String water;
  final String soilType;
  final String distance;
  final SearchListingArtworkType artworkType;
  final List<SearchListingDetailSection> detailSections;
  final List<String> documentStatuses;
  final String? imageUrl;
}

class SearchListingDetailSection {
  const SearchListingDetailSection({required this.title, required this.fields});

  final String title;
  final List<SearchListingDetailField> fields;
}

class SearchListingDetailField {
  const SearchListingDetailField({
    required this.label,
    required this.value,
    this.isAccent = false,
  });

  final String label;
  final String value;
  final bool isAccent;
}
