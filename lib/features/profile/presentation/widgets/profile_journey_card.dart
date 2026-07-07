part of '../pages/profile_page.dart';

class _JourneySectionHeader extends StatelessWidget {
  const _JourneySectionHeader();

  @override
  Widget build(BuildContext context) {
    final onSurface = context.colors.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'SELECT LAND JOURNEY',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'CHOOSE PROPERTIES TO TRACK PROGRESS.',
                style: context.text.microLabel.copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
        ),
        Icon(
          Icons.track_changes_rounded,
          size: 18,
          color: AppColors.primaryOrange.withValues(alpha: 0.75),
        ),
      ],
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.journey,
    required this.isSelected,
    required this.onTap,
  });

  final _TrackedLandUiModel journey;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final onSurface = scheme.onSurface;
    final surfaceCard = context.surfaceCard;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceCard,
            gradient: LinearGradient(
              colors: [
                surfaceCard,
                isSelected
                    ? scheme.surface.withValues(alpha: 0.5)
                    : surfaceCard,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.deepOrange
                  : scheme.outline.withValues(alpha: 0.35),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: onSurface.withValues(
                  alpha: isSelected ? 0.08 : 0.04,
                ),
                blurRadius: isSelected ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.deepOrange : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepOrange
                        : scheme.outline.withValues(alpha: 0.35),
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 12, color: scheme.onPrimary)
                    : null,
              ),
              const SizedBox(width: 14),
              _JourneyThumbnail(colors: journey.palette, imageUrl: journey.imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      journey.title,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      journey.subtitle.toUpperCase(),
                      style: context.text.microLabel.copyWith(
                        color: AppColors.deepOrange,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                journey.trailingLabel,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnedLandCard extends StatelessWidget {
  const _OwnedLandCard({required this.land});

  final _OwnedLandUiModel land;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final onSurface = scheme.onSurface;
    final surfaceCard = context.surfaceCard;

    return CustomCard(
      gradient: LinearGradient(
        colors: [
          surfaceCard,
          scheme.surface.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      child: Row(
        children: <Widget>[
          _OwnedLandThumbnail(colors: land.palette, imageUrl: land.imageUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  land.title,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.deepOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      land.subtitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            land.priceLabel,
            style: TextStyle(
              color: onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
