part of '../pages/profile_page.dart';

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: context.text.microLabel.copyWith(
          color: AppColors.white,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _VisitsHubTabButton extends StatelessWidget {
  const _VisitsHubTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.white,
                        AppColors.softBackground.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              boxShadow: isSelected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : const <BoxShadow>[],
            ),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: context.text.microLabel.copyWith(
                  color: isSelected ? AppColors.deepOrange : AppColors.ink,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisitsHubFloatingActions extends StatelessWidget {
  const _VisitsHubFloatingActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _VisitsHubFab(
          icon: Icons.phone_in_talk_rounded,
          semanticsLabel: 'Contact support by chat',
        ),
        SizedBox(height: 10),
        _VisitsHubFab(
          icon: Icons.call_rounded,
          semanticsLabel: 'Call support',
        ),
      ],
    );
  }
}

class _VisitsHubFab extends StatelessWidget {
  const _VisitsHubFab({
    required this.icon,
    required this.semanticsLabel,
  });

  final IconData icon;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.deepOrange,
              gradient: const LinearGradient(
                colors: [AppColors.deepOrange, AppColors.primaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

class _OwnedLandThumbnail extends StatelessWidget {
  const _OwnedLandThumbnail({required this.colors, this.imageUrl});

  final List<Color> colors;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                Uri.encodeFull(imageUrl!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              )
            else
              const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JourneyThumbnail extends StatelessWidget {
  const _JourneyThumbnail({required this.colors, this.imageUrl});

  final List<Color> colors;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                Uri.encodeFull(imageUrl!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              )
            else
              const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrackedJourneyHeroArtwork extends StatelessWidget {
  const _TrackedJourneyHeroArtwork({required this.journey});

  final _TrackedLandUiModel journey;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SizedBox(
        height: 182,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      journey.palette[0],
                      journey.palette[1],
                      const Color(0xFFF7F0C8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            if (journey.imageUrl != null && journey.imageUrl!.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  Uri.encodeFull(journey.imageUrl!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
                ),
              )
            else
              const Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3AC45B),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  journey.availabilityBadge,
                  style: context.text.microLabel.copyWith(
                    color: AppColors.white,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    journey.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    journey.subtitle.toUpperCase(),
                    style: context.text.microLabel.copyWith(
                      color: const Color(0xFFFFA462),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyMetric extends StatelessWidget {
  const _JourneyMetric({
    required this.label,
    required this.value,
    required this.alignment,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(
          label,
          textAlign: textAlign,
          style: context.text.microLabel.copyWith(letterSpacing: 0.35),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: textAlign,
          style: context.text.caption.copyWith(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TrackingActionButton extends StatelessWidget {
  const _TrackingActionButton({
    required this.label,
    required this.onTap,
    this.isFilled = false,
    this.foregroundColor,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isFilled;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null || isLoading;
    final scheme = context.colors;
    final onSurface = scheme.onSurface;
    final textColor =
        foregroundColor ?? (isFilled ? scheme.onPrimary : onSurface);
    final effectiveTextColor = isDisabled
        ? textColor.withValues(alpha: 0.55)
        : textColor;
    final unfilledSurface = scheme.surfaceContainerHighest;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: isFilled
                ? AppColors.deepOrange.withValues(alpha: isDisabled ? 0.75 : 1)
                : unfilledSurface.withValues(alpha: isDisabled ? 0.82 : 1),
            gradient: isFilled
                ? const LinearGradient(
                    colors: [AppColors.deepOrange, AppColors.primaryOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFilled
                  ? AppColors.deepOrange
                  : scheme.outline.withValues(alpha: 0.35),
            ),
            boxShadow: [
              if (isFilled)
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              else
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isFilled ? AppColors.white : AppColors.deepOrange,
                          ),
                        ),
                      )
                    : Text(
                        label,
                        maxLines: 1,
                        style: context.text.microLabel.copyWith(
                          color: effectiveTextColor,
                          letterSpacing: 0.6,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackingFloatingButton extends StatelessWidget {
  const _TrackingFloatingButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close tracking journey',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.deepOrange,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF6A67C),
                  const Color(0xFFF6A67C).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFF6A67C).withValues(alpha: 0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.remove_rounded,
              size: 20,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityArrowButton extends StatelessWidget {
  const _AvailabilityArrowButton({
    required this.onTap,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isLoading ? 'Loading' : 'Continue',
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.deepOrange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            gradient: const LinearGradient(
              colors: [AppColors.deepOrange, Color(0xFFFFA63C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 32,
                  ),
          ),
        ),
      ),
    );
  }
}
