import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';

LandEntity _sampleLand() {
  return const LandEntity(
    id: 7,
    village: 'Kothur',
    state: 'Telangana',
    district: 'Rangareddy',
    mandal: 'Shadnagar',
    landStatus: ['Available for sale'],
    mortgageStatus: ['Available for mortgage'],
    urgencyListing: ['Normal'],
    verificationPackage: true,
    isVerified: true,
    verificationStatus: 'verified',
    nearestTownKm: '11',
    createdAt: null,
    updatedAt: null,
    landDetails: LandDetailsEntity(
      totalAcres: 4.5,
      guntas: 30,
      pricePerAcres: 7400000,
      totalValue: 15000000,
      soilType: 'Red',
      nearestRoadType: 'BT Road',
      landAttachedToRoad: 'Yes',
      fencingStatus: 'Partial',
      waterSource: ['Borewell'],
      electricity: ['Available'],
      residence: [],
      numberOfBores: 2,
      farmPond: true,
      poultryShedNumber: 0,
      cowShedNumber: 0,
      trees: [],
    ),
    media: [],
    documents: [],
  );
}

void main() {
  group('LandMapper', () {
    test('maps availability and mortgage separately', () {
      final uiModel = LandMapper.toUiModel(_sampleLand());

      expect(uiModel.availability, contains('SALE'));
      expect(uiModel.mortgage, contains('MORTGAGE'));
      expect(uiModel.area, '4.5 ac 30 gts');
    });

    test('formatTotalValueParts uses Lakhs below one crore', () {
      final parts = LandMapper.formatTotalValueParts(5000000);

      expect(parts.suffix, ' L');
      expect(parts.amount, isNotEmpty);
    });

    test('formatVerificationLabel returns Verified when isVerified', () {
      expect(
        LandMapper.formatVerificationLabel(_sampleLand()),
        'Verified',
      );
    });
  });
}
