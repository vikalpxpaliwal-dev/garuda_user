part of '../pages/profile_page.dart';

class _JourneySectionHeader extends StatelessWidget {
  const _JourneySectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'SELECT LAND JOURNEY',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'CHOOSE PROPERTIES TO TRACK PROGRESS.',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            gradient: LinearGradient(
              colors: [
                AppColors.white,
                isSelected
                    ? AppColors.softBackground.withValues(alpha: 0.5)
                    : AppColors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.deepOrange
                  : AppColors.lightLine.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.ink.withValues(
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
                        : AppColors.lightLine,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: AppColors.white)
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
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      journey.subtitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                journey.trailingLabel,
                style: const TextStyle(
                  color: AppColors.ink,
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
    return CustomCard(
      gradient: LinearGradient(
        colors: [
          AppColors.white,
          AppColors.softBackground.withValues(alpha: 0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
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
                  style: const TextStyle(
                    color: AppColors.ink,
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
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
