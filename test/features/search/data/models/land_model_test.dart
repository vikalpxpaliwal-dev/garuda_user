import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/features/search/data/mappers/land_api_mapper.dart';
import 'package:garuda_user_app/features/search/data/models/land_model.dart';
import 'package:garuda_user_app/features/search/presentation/utils/land_mapper.dart';

void main() {
  group('LandApiMapper', () {
    test('parseTreeCount handles numeric and string counts', () {
      expect(LandApiMapper.parseTreeCount(8), 8);
      expect(LandApiMapper.parseTreeCount('12 Trees'), 12);
      expect(LandApiMapper.parseTreeCount(''), 0);
    });

    test('prepareLandJson maps legacy tree counts into landDetails.trees', () {
      final prepared = LandApiMapper.prepareLandJson(<String, dynamic>{
        'landDetails': <String, dynamic>{
          'mango_trees_number': '10 Trees',
          'coconut_trees_number': '3 Trees',
        },
      });

      final trees = prepared['landDetails']['trees'] as List<dynamic>;
      expect(trees, hasLength(2));
      expect(trees.first['type'], 'Mango');
      expect(trees.first['count'], 10);
    });
  });

  group('LandModel.fromJson', () {
    late Map<String, dynamic> sampleJson;

    setUp(() {
      final file = File('test/fixtures/land_sample.json');
      sampleJson = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    });

    test('parses root tree[], mortgage, sale status, and string tree counts', () {
      final model = LandModel.fromJson(sampleJson);
      final entity = model.toEntity();

      expect(model.landStatus, ['Available for sale']);
      expect(model.mortgageStatus, ['Available for mortgage']);
      expect(model.trees, hasLength(2));
      expect(model.trees.first.count, 12);
      expect(model.trees.last.count, 4);
      expect(entity.landDetails.trees.first.type, 'Mango');
      expect(entity.landDetails.trees.first.count, 12);
    });

    test('formats total value inputs for UI mapper', () {
      final entity = LandModel.fromJson(sampleJson).toEntity();
      final uiModel = LandMapper.toUiModel(entity);

      expect(uiModel.availability, contains('SALE'));
      expect(uiModel.mortgage, contains('MORTGAGE'));
      expect(uiModel.area, '4.5 ac 30 gts');
      expect(LandMapper.formatTotalValueParts(entity.landDetails.totalValue).suffix,
          ' Cr');
    });
  });
}
