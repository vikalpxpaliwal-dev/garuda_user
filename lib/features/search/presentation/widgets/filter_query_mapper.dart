import 'dart:convert';

import 'package:flutter/material.dart';

class FilterQueryInput {
  const FilterQueryInput({
    this.state,
    this.district,
    this.town,
    this.budget = const RangeValues(0, 100),
    this.price = const RangeValues(0, 10),
    this.area = const RangeValues(0, 50),
    this.soilType = 'All',
    this.roadType = 'All',
    this.attachedToRoad = 'All',
    this.waterSource = 'All',
    this.farmPond = 'All',
    this.residence = 'All',
    this.fencingStatus = 'All',
  });

  final String? state;
  final String? district;
  final String? town;
  final RangeValues budget;
  final RangeValues price;
  final RangeValues area;
  final String soilType;
  final String roadType;
  final String attachedToRoad;
  final String waterSource;
  final String farmPond;
  final String residence;
  final String fencingStatus;
}

abstract final class FilterQueryMapper {
  static Map<String, dynamic> toApiFilters(FilterQueryInput input) {
    final filters = <String, dynamic>{};

    if (input.state != null) filters['state'] = input.state;
    if (input.district != null) filters['district'] = input.district;
    if (input.town != null) filters['mandal'] = input.town;

    if (input.budget.start > 0) {
      filters['min_total_budget'] = input.budget.start * 10000000;
    }
    if (input.budget.end < 100) {
      filters['max_total_budget'] = input.budget.end * 10000000;
    }

    if (input.price.start > 0) {
      filters['min_price_per_acre'] = input.price.start * 10000000;
    }
    if (input.price.end < 10) {
      filters['max_price_per_acre'] = input.price.end * 10000000;
    }

    if (input.area.start > 0) {
      filters['min_acres'] = input.area.start;
    }
    if (input.area.end < 50) {
      filters['max_acres'] = input.area.end;
    }

    if (input.soilType != 'All') filters['soil_type'] = input.soilType;
    if (input.roadType != 'All') {
      filters['nearest_road_type'] = input.roadType;
    }
    if (input.attachedToRoad != 'All') {
      filters['land_attached_to_road'] = input.attachedToRoad.toLowerCase();
    }
    if (input.waterSource != 'All') {
      filters['water_source'] = jsonEncode([input.waterSource]);
    }
    if (input.farmPond != 'All') {
      filters['farm_pond'] = input.farmPond == 'Yes';
    }
    if (input.residence != 'All') {
      filters['residence'] = input.residence == 'None'
          ? jsonEncode([])
          : jsonEncode([input.residence]);
    }
    if (input.fencingStatus != 'All') {
      filters['fencing_status'] = input.fencingStatus;
    }

    return filters;
  }
}
