import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';

class SearchFilterPanel extends StatefulWidget {
  const SearchFilterPanel({
    required this.onClose,
    required this.onSearchResults,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<Map<String, dynamic>> onSearchResults;

  @override
  State<SearchFilterPanel> createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> {
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTown;

  RangeValues _budget = const RangeValues(0, 100);
  RangeValues _price = const RangeValues(0, 10);
  RangeValues _area = const RangeValues(0, 50);

  bool _showCharacteristics = false;

  String _selectedSoilType = 'All';
  String _selectedRoadType = 'All';
  String _selectedAttachedToRoad = 'All';
  String _selectedWaterSource = 'All';
  String _selectedFarmPond = 'All';
  String _selectedResidence = 'All';
  String _selectedFencingStatus = 'All';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SearchBloc>();
    if (bloc.state.locationStatus == LocationStatus.initial) {
      bloc.add(const GetLocationsEvent());
    }
  }

  List<String> _stateNames(List<StateEntity> states) =>
      states.map((s) => s.name).toList();

  List<String> _districtNames(List<StateEntity> states) {
    if (_selectedState == null) return const [];
    final state = states.where((s) => s.name == _selectedState).firstOrNull;
    return state?.districts.map((d) => d.name).toList() ?? const [];
  }

  List<String> _townNames(List<StateEntity> states) {
    if (_selectedState == null || _selectedDistrict == null) return const [];
    final state = states.where((s) => s.name == _selectedState).firstOrNull;
    final district = state?.districts
        .where((d) => d.name == _selectedDistrict)
        .firstOrNull;
    return district?.mandals.map((m) => m.name).toList() ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (prev, curr) =>
          prev.locationStatus != curr.locationStatus ||
          prev.states != curr.states,
      builder: (context, searchState) {
        final isLoading = searchState.locationStatus == LocationStatus.loading;
        final states = searchState.states;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.deepOrange,
                      ),
                    ),
                  ),
                ),

              _buildLabel('STATE'),
              _buildDropdown(
                value: _selectedState,
                hint: 'All States',
                options: _stateNames(states),
                onChanged: (val) {
                  setState(() {
                    _selectedState = val;
                    _selectedDistrict = null;
                    _selectedTown = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('DISTRICT'),
              _buildDropdown(
                value: _selectedDistrict,
                hint: 'All Districts',
                options: _districtNames(states),
                onChanged: (val) {
                  setState(() {
                    _selectedDistrict = val;
                    _selectedTown = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('TOWN'),
              _buildDropdown(
                value: _selectedTown,
                hint: 'All Towns',
                options: _townNames(states),
                onChanged: (val) {
                  setState(() => _selectedTown = val);
                },
              ),
              const SizedBox(height: 32),

              _buildRangeSlider(
                label: 'TOTAL BUDGET',
                values: _budget,
                min: 0,
                max: 100,
                suffix: 'Cr',
                prefix: '₹ ',
                onChanged: (val) => setState(() => _budget = val),
              ),
              const SizedBox(height: 24),

              _buildRangeSlider(
                label: 'PRICE PER ACRE',
                values: _price,
                min: 0,
                max: 10,
                suffix: 'Cr',
                prefix: '₹ ',
                onChanged: (val) => setState(() => _price = val),
              ),
              const SizedBox(height: 24),

              _buildRangeSlider(
                label: 'AREA RANGE (ACRES)',
                values: _area,
                min: 0,
                max: 50,
                suffix: 'ac',
                prefix: '',
                onChanged: (val) => setState(() => _area = val),
              ),
              const SizedBox(height: 32),

              // Collapsible Property Characteristics
              InkWell(
                onTap: () => setState(
                  () => _showCharacteristics = !_showCharacteristics,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PROPERTY CHARACTERISTICS',
                        style: TextStyle(
                          color: AppColors.deepOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Icon(
                        _showCharacteristics
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.deepOrange,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              if (_showCharacteristics) ...[
                const SizedBox(height: 32),
                _buildRadioGrid(
                  label: 'LAND SOIL TYPE',
                  options: [
                    'All',
                    'Red',
                    'Black',
                    'Mixed Red',
                    'Sandy',
                    'Alluvial',
                  ],
                  selectedValue: _selectedSoilType,
                  onChanged: (val) => setState(() => _selectedSoilType = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'NEAREST ROAD TYPE',
                  options: [
                    'All',
                    'Highway',
                    'Double Road',
                    'Single Road',
                    'Gravel Road',
                  ],
                  selectedValue: _selectedRoadType,
                  onChanged: (val) => setState(() => _selectedRoadType = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'ATTACHED TO ROAD',
                  options: ['All', 'Yes', 'No'],
                  selectedValue: _selectedAttachedToRoad,
                  onChanged: (val) =>
                      setState(() => _selectedAttachedToRoad = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'WATER SOURCE',
                  options: ['All', 'Borewell', 'Canal', 'Open Well'],
                  selectedValue: _selectedWaterSource,
                  onChanged: (val) =>
                      setState(() => _selectedWaterSource = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'FARM POND',
                  options: ['All', 'Yes', 'No'],
                  selectedValue: _selectedFarmPond,
                  onChanged: (val) => setState(() => _selectedFarmPond = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'RESIDENCE',
                  options: [
                    'All',
                    'Developed Farm House',
                    'RCC House',
                    'Asbestos Shed',
                    'Hut',
                    'None',
                  ],
                  selectedValue: _selectedResidence,
                  onChanged: (val) => setState(() => _selectedResidence = val),
                ),
                const SizedBox(height: 24),
                _buildRadioGrid(
                  label: 'FENCING STATUS',
                  options: [
                    'All',
                    'All sides with gate',
                    'All sides',
                    'Partially',
                    'No',
                  ],
                  selectedValue: _selectedFencingStatus,
                  onChanged: (val) =>
                      setState(() => _selectedFencingStatus = val),
                ),
              ],

              const SizedBox(height: 40),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _onSearchPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.deepOrange,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Show Results',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearchPressed() {
    final filters = <String, dynamic>{};

    if (_selectedState != null) filters['state'] = _selectedState;
    if (_selectedDistrict != null) filters['district'] = _selectedDistrict;
    if (_selectedTown != null) filters['mandal'] = _selectedTown;

    if (_budget.start > 0) {
      filters['min_total_budget'] = _budget.start * 10000000;
    }
    if (_budget.end < 100) {
      filters['max_total_budget'] = _budget.end * 10000000;
    }

    if (_price.start > 0) {
      filters['min_price_per_acre'] = _price.start * 10000000;
    }
    if (_price.end < 10) {
      filters['max_price_per_acre'] = _price.end * 10000000;
    }

    if (_area.start > 0) {
      filters['min_acres'] = _area.start;
    }
    if (_area.end < 50) {
      filters['max_acres'] = _area.end;
    }

    if (_selectedSoilType != 'All') filters['soil_type'] = _selectedSoilType;
    if (_selectedRoadType != 'All') {
      filters['nearest_road_type'] = _selectedRoadType;
    }

    if (_selectedAttachedToRoad != 'All') {
      filters['land_attached_to_road'] = _selectedAttachedToRoad.toLowerCase();
    }

    if (_selectedWaterSource != 'All') {
      filters['water_source'] = jsonEncode([_selectedWaterSource]);
    }

    if (_selectedFarmPond != 'All') {
      filters['farm_pond'] = _selectedFarmPond == 'Yes';
    }

    if (_selectedResidence != 'All') {
      if (_selectedResidence == 'None') {
        filters['residence'] = jsonEncode([]);
      } else {
        filters['residence'] = jsonEncode([_selectedResidence]);
      }
    }

    if (_selectedFencingStatus != 'All') {
      filters['fencing_status'] = _selectedFencingStatus;
    }

    widget.onSearchResults(filters);
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.mutedText,
            size: 20,
          ),
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRangeSlider({
    required String label,
    required RangeValues values,
    required double min,
    required double max,
    required String suffix,
    required String prefix,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(label),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '$prefix${values.start.toStringAsFixed(values.start == values.start.roundToDouble() ? 0 : 1)} - $prefix${values.end.toStringAsFixed(values.end == values.end.roundToDouble() ? 0 : 1)} $suffix',
                style: const TextStyle(
                  color: AppColors.deepOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: AppColors.deepOrange,
            inactiveTrackColor: AppColors.deepOrange.withValues(alpha: 0.2),
            thumbColor: AppColors.white,
            overlayShape: SliderComponentShape.noOverlay,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 7,
              elevation: 2,
            ),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$prefix${values.start.toStringAsFixed(values.start == values.start.roundToDouble() ? 0 : 1)} $suffix',
              style: const TextStyle(
                color: AppColors.deepOrange,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$prefix${values.end.toStringAsFixed(values.end == values.end.roundToDouble() ? 0 : 1)} $suffix',
              style: const TextStyle(
                color: AppColors.deepOrange,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioGrid({
    required String label,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 44, // Fixed height for each item
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.softBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepOrange.withValues(alpha: 0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.deepOrange,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.deepOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
