part of 'search_listing_detail_page.dart';

class _TreesSection extends StatelessWidget {
  const _TreesSection({required this.land, required this.useWideLayout});

  final LandEntity land;
  final bool useWideLayout;

  @override
  Widget build(BuildContext context) {
    final trees = land.landDetails.trees;
    final columns = useWideLayout ? 4 : 2;
    final rows = <Widget>[];

    for (var i = 0; i < trees.length; i += columns) {
      final rowChildren = <Widget>[];
      for (var j = 0; j < columns; j++) {
        final index = i + j;
        if (index < trees.length) {
          rowChildren.add(
            Expanded(
              child: _TreePropItem(
                type: trees[index].type,
                count: trees[index].count,
              ),
            ),
          );
        } else {
          rowChildren.add(const Expanded(child: SizedBox()));
        }
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _TreePropItem extends StatelessWidget {
  const _TreePropItem({required this.type, required this.count});

  final String type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final onSurface = context.colors.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.energy_savings_leaf_outlined,
          size: 16,
          color: AppColors.deepOrange,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type.toUpperCase(),
                style: TextStyle(
                  color: onSurface,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count TREES',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
