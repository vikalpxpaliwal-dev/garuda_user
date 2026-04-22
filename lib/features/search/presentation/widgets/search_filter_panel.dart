import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';

class SearchFilterPanel extends StatefulWidget {
  const SearchFilterPanel({
    required this.onClose,
    required this.onSearchResults,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onSearchResults;

  @override
  State<SearchFilterPanel> createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> {
  static const List<String> _states = <String>[
    'Telangana',
    'Andhra Pradesh',
    'Karnataka',
  ];

  static const List<String> _districts = <String>[
    'Rangareddy',
    'Mahabubnagar',
    'Medchal',
  ];

  static const List<String> _mandals = <String>[
    'Shadnagar',
    'Chevella',
    'Khajaguda',
  ];

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMandal;
  RangeValues _priceRange = const RangeValues(0, 500);
  RangeValues _budgetRange = const RangeValues(0, 50);
  bool _deepFiltersExpanded = false;

  // Deep Filter States
  String? _selectedLandStatus;
  bool _isFarmhouse = false;
  String? _selectedRoadType;
  RangeValues _distanceRange = const RangeValues(0, 20);
  String? _selectedWaterSource;
  String? _selectedBoundaryStatus;
  bool _isPoultryShed = false;
  bool _isCowShed = false;
  bool _isFarmPond = false;
  String? _selectedPhaseType;

  static const List<String> _landStatuses = ['Clear Title', 'Patta Land', 'Assigned Land'];
  static const List<String> _roadTypes = ['National Highway', 'State Highway', 'BT Road', 'Metal Road', 'Dirt Road'];
  static const List<String> _waterSources = ['Borewell', 'Canal', 'Open Well', 'River', 'Rainfed'];
  static const List<String> _boundaryStatuses = ['Fenced', 'Compound Wall', 'Stones Marked'];
  static const List<String> _phaseTypes = ['Single Phase', '3 Phase', 'High Tension'];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'SEARCH FILTERS',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              InkWell(
                onTap: widget.onClose,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.softBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionLabel('STATE'),
          const SizedBox(height: 10),
          _FilterDropdown(
            value: _selectedState,
            hint: 'Select State',
            options: _states,
            onChanged: (value) => setState(() => _selectedState = value),
          ),
          const SizedBox(height: 18),
          const Row(
            children: <Widget>[
              Expanded(child: _SectionLabel('DISTRICT')),
              SizedBox(width: 12),
              Expanded(child: _SectionLabel('MANDAL')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _FilterDropdown(
                  value: _selectedDistrict,
                  hint: 'District',
                  options: _districts,
                  onChanged: (value) =>
                      setState(() => _selectedDistrict = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterDropdown(
                  value: _selectedMandal,
                  hint: 'Mandal',
                  options: _mandals,
                  onChanged: (value) => setState(() => _selectedMandal = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _DashedDivider(),
          const SizedBox(height: 20),
          _RangeFilterSection(
            label: 'PRICE PER ACRE (LAKHS)',
            values: _priceRange,
            max: 500,
            suffix: 'L',
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          const SizedBox(height: 20),
          _RangeFilterSection(
            label: 'TOTAL BUDGET (CRORES)',
            values: _budgetRange,
            max: 50,
            suffix: 'Cr',
            onChanged: (values) => setState(() => _budgetRange = values),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              setState(() {
                _deepFiltersExpanded = !_deepFiltersExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: AppColors.deepOrange,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'DEEP FILTERS',
                      style: TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 240),
                    turns: _deepFiltersExpanded ? 0.5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _deepFiltersExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(height: 12),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SubSectionHeader(
                    icon: Icons.verified_user_outlined,
                    label: 'OWNERSHIP & STATUS',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('LAND STATUS'),
                            const SizedBox(height: 8),
                            _FilterDropdown(
                              value: _selectedLandStatus,
                              hint: 'Any Status',
                              options: _landStatuses,
                              onChanged: (val) => setState(() => _selectedLandStatus = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: _ToggleField(
                          label: 'FARMHOUSE',
                          value: _isFarmhouse,
                          onChanged: (val) => setState(() => _isFarmhouse = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SubSectionHeader(
                    icon: Icons.add_road_rounded,
                    label: 'ROAD CONNECTIVITY',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('ATTACHED ROAD'),
                            const SizedBox(height: 8),
                            _FilterDropdown(
                              value: _selectedRoadType,
                              hint: 'Road Type',
                              options: _roadTypes,
                              onChanged: (val) => setState(() => _selectedRoadType = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('DIST. FROM TOWN (KM)'),
                            const SizedBox(height: 4),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,
                                activeTrackColor: AppColors.deepOrange,
                                inactiveTrackColor: const Color(0xFFF7D8C2),
                                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                                rangeThumbShape: const _FilterRangeThumbShape(radius: 8),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: RangeSlider(
                                values: _distanceRange,
                                min: 0,
                                max: 20,
                                onChanged: (val) => setState(() => _distanceRange = val),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_distanceRange.start.round()} km',
                                  style: const TextStyle(
                                    color: AppColors.deepOrange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${_distanceRange.end.round()} km',
                                  style: const TextStyle(
                                    color: AppColors.deepOrange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SubSectionHeader(
                    icon: Icons.water_drop_outlined,
                    label: 'WATER & BOUNDARY',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('WATER SOURCE'),
                            const SizedBox(height: 8),
                            _FilterDropdown(
                              value: _selectedWaterSource,
                              hint: 'Any',
                              options: _waterSources,
                              onChanged: (val) => setState(() => _selectedWaterSource = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('BOUNDARY STATUS'),
                            const SizedBox(height: 8),
                            _FilterDropdown(
                              value: _selectedBoundaryStatus,
                              hint: 'Any',
                              options: _boundaryStatuses,
                              onChanged: (val) => setState(() => _selectedBoundaryStatus = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SubSectionHeader(
                    icon: Icons.home_outlined,
                    label: 'PROPERTY FACILITIES',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ToggleField(
                          label: 'POULTRY SHED',
                          value: _isPoultryShed,
                          onChanged: (val) => setState(() => _isPoultryShed = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ToggleField(
                          label: 'COW SHED',
                          value: _isCowShed,
                          onChanged: (val) => setState(() => _isCowShed = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _ToggleField(
                          label: 'FARM POND',
                          value: _isFarmPond,
                          onChanged: (val) => setState(() => _isFarmPond = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FilterLabel('ELECTRICITY'),
                            const SizedBox(height: 8),
                            _FilterDropdown(
                              value: _selectedPhaseType,
                              hint: 'Phase Type',
                              options: _phaseTypes,
                              onChanged: (val) => setState(() => _selectedPhaseType = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onSearchResults,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deepOrange,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search_rounded, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Search Results',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final String hint;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              color: AppColors.deepOrange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.primaryOrange,
          ),
          style: const TextStyle(
            color: AppColors.deepOrange,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: AppColors.white,
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.deepOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _RangeFilterSection extends StatelessWidget {
  const _RangeFilterSection({
    required this.label,
    required this.values,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final RangeValues values;
  final double max;
  final String suffix;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionLabel(label),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: AppColors.deepOrange,
            inactiveTrackColor: const Color(0xFFF7D8C2),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            rangeThumbShape: const _FilterRangeThumbShape(),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: RangeSlider(
            values: values,
            min: 0,
            max: max,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RangeValueChip(
              prefix: 'MIN:',
              value: values.start.round().toString(),
              suffix: suffix,
            ),
            _RangeValueChip(
              prefix: 'MAX:',
              value: values.end.round().toString(),
              suffix: suffix,
              emphasizeValue: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _RangeValueChip extends StatelessWidget {
  const _RangeValueChip({
    required this.prefix,
    required this.value,
    required this.suffix,
    this.emphasizeValue = false,
  });

  final String prefix;
  final String value;
  final String suffix;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '$prefix ',
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: '$value ',
              style: TextStyle(
                color: emphasizeValue ? AppColors.deepOrange : AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: suffix,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _SubSectionHeader extends StatelessWidget {
  const _SubSectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.ink,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          width: double.infinity,
          color: AppColors.lightLine.withValues(alpha: 0.6),
        ),
      ],
    );
  }
}

class _ToggleField extends StatelessWidget {
  const _ToggleField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.deepOrange,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.lightLine,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _DeepFilterChip extends StatelessWidget {
  const _DeepFilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.lightLine),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.deepOrange,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / 8).floor();

          return Row(
            children: List<Widget>.generate(
              dashCount,
              (_) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: AppColors.lightLine,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterRangeThumbShape extends RangeSliderThumbShape {
  const _FilterRangeThumbShape({this.radius = 6});

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.square(radius * 2 + 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    TextDirection textDirection = TextDirection.ltr,
    required SliderThemeData sliderTheme,
    Thumb thumb = Thumb.start,
    bool isPressed = false,
  }) {
    final Canvas canvas = context.canvas;
    final fillPaint = Paint()..color = AppColors.white;
    final borderPaint = Paint()
      ..color = AppColors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, borderPaint);
  }
}
