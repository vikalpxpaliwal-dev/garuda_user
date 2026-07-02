part of '../pages/profile_page.dart';

enum _ProfileCollectionTab { wishlist, myLands }

enum _TrackingStage { availability, payment, visitsHub }

enum _VisitsHubList { primaryVisit, shortlist, finalList }

class _TrackedLandUiModel {
  const _TrackedLandUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.trailingLabel,
    required this.primaryMetricLabel,
    required this.primaryMetricValue,
    required this.secondaryMetricLabel,
    required this.secondaryMetricValue,
    required this.availabilityBadge,
    required this.palette,
    this.imageUrl,
    this.availabilityStatus,
  });

  final int id;
  final String title;
  final String subtitle;
  final String trailingLabel;
  final String primaryMetricLabel;
  final String primaryMetricValue;
  final String secondaryMetricLabel;
  final String secondaryMetricValue;
  final String availabilityBadge;
  final List<Color> palette;
  final String? imageUrl;
  /// Raw status string from API, e.g. "available", "not_available"
  final String? availabilityStatus;
}

class _OwnedLandUiModel {
  const _OwnedLandUiModel({
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.palette,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String priceLabel;
  final List<Color> palette;
  final String? imageUrl;
}

class _ProfileAvailabilityMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  static List<_TrackedLandUiModel> toUiModels(List<AvailabilityEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];

      return _TrackedLandUiModel(
        id: land.id,
        title: _ProfileWishlistMapper._capitalize(land.mandal),
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        trailingLabel: _ProfileWishlistMapper._normalizeLabel(
          item.status,
          fallback: 'ACTIVE',
        ),
        primaryMetricLabel: 'FORM STATUS',
        primaryMetricValue: _ProfileWishlistMapper._normalizeLabel(
          land.formStatus,
          fallback: 'UNKNOWN',
        ),
        secondaryMetricLabel: 'VERIFICATION',
        secondaryMetricValue: land.verificationPackage
            ? 'VERIFIED'
            : 'STANDARD',
        availabilityBadge: 'TRACKING',
        palette: palette,
        imageUrl: land.imageUrl,
        availabilityStatus: item.status,
      );
    }).toList();
  }
}

class _ProfileOwnedLandMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF11253D), Color(0xFF526B7E), Color(0xFFDEE8F0)],
    <Color>[Color(0xFF23495C), Color(0xFF7CA5B8), Color(0xFFF6E6B3)],
  ];

  static List<_OwnedLandUiModel> toUiModels(List<ShortlistItemEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];

      return _OwnedLandUiModel(
        title: _ProfileWishlistMapper._capitalize(land.mandal),
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        priceLabel: 'TBD',
        palette: palette,
        imageUrl: land.imageUrl,
      );
    }).toList();
  }
}

class _ProfileWishlistMapper {
  static const List<List<Color>> _palettes = <List<Color>>[
    <Color>[Color(0xFF041E42), Color(0xFF0D5C5D), Color(0xFFFFB34A)],
    <Color>[Color(0xFF243B55), Color(0xFF141E30), Color(0xFFE98B2A)],
    <Color>[Color(0xFF1E3A5F), Color(0xFF496989), Color(0xFFF4B860)],
    <Color>[Color(0xFF233D4D), Color(0xFF4F6D7A), Color(0xFFFFB347)],
  ];

  static List<_TrackedLandUiModel> toUiModels(List<WishlistItemEntity> items) {
    return items.asMap().entries.map((entry) {
      final item = entry.value;
      final land = item.land;
      final palette = _palettes[entry.key % _palettes.length];
      final availabilityBadge = _normalizeLabel(
        land.landStatus.isNotEmpty ? land.landStatus.first : land.availability,
        fallback: 'WISHLISTED',
      );

      return _TrackedLandUiModel(
        id: land.id,
        title: _capitalize(land.mandal),
        subtitle:
            '${land.district.toUpperCase()} • ${land.state.toUpperCase()}',
        trailingLabel: _normalizeLabel(land.availability, fallback: 'ACTIVE'),
        primaryMetricLabel: 'FORM STATUS',
        primaryMetricValue: _normalizeLabel(
          land.formStatus,
          fallback: 'UNKNOWN',
        ),
        secondaryMetricLabel: 'VERIFICATION',
        secondaryMetricValue: land.verificationPackage
            ? 'VERIFIED'
            : 'STANDARD',
        availabilityBadge: availabilityBadge,
        palette: palette,
        imageUrl: land.imageUrl,
      );
    }).toList();
  }

  static String _normalizeLabel(String value, {required String fallback}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return fallback;
    }

    return trimmed.toUpperCase();
  }

  static String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Land';
    }

    final lower = trimmed.toLowerCase();
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }
}
