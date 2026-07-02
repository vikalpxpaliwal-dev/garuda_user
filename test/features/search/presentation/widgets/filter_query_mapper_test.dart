import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/features/search/presentation/widgets/filter_query_mapper.dart';

void main() {
  test('toApiFilters maps location and budget filters', () {
    final filters = FilterQueryMapper.toApiFilters(
      const FilterQueryInput(
        state: 'Telangana',
        district: 'Rangareddy',
        town: 'Shadnagar',
        budget: RangeValues(1, 50),
        soilType: 'Red',
      ),
    );

    expect(filters['state'], 'Telangana');
    expect(filters['district'], 'Rangareddy');
    expect(filters['mandal'], 'Shadnagar');
    expect(filters['min_total_budget'], 10000000);
    expect(filters['max_total_budget'], 500000000);
    expect(filters['soil_type'], 'Red');
  });
}
