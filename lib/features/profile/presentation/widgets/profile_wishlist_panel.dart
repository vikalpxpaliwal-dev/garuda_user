part of '../pages/profile_page.dart';

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final onSurface = scheme.onSurface;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final initial = state.user?.name.isNotEmpty == true
            ? state.user!.name[0].toUpperCase()
            : 'U';
        final name = state.user?.name ?? 'Profile';

        return Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.editProfile),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8D7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightLine.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.deepOrange.withValues(alpha: 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: AppColors.deepOrange,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.edit_note_rounded,
                                size: 18,
                                color: AppColors.mutedText,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepOrange.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'ACTIVE MEMBER',
                              style: context.text.microLabel.copyWith(
                                color: AppColors.deepOrange,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _LogoutButton(onTap: () => _showLogoutDialog(context)),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final scheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: scheme.surfaceContainerHighest,
        title: Text(
          'Logout',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout from your account?',
          style: TextStyle(
            color: AppColors.mutedText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: AppColors.mutedText,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(UserLoggedOut());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'LOGOUT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
        );
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Log out',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            child: Container(
              padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFE1E1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF0000).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.power_settings_new_rounded,
            color: Color(0xFFD32F2F),
            size: 22,
          ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectionTabs extends StatelessWidget {
  const _CollectionTabs({required this.selectedTab, required this.onChanged});

  final _ProfileCollectionTab selectedTab;
  final ValueChanged<_ProfileCollectionTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final onSurface = scheme.onSurface;
    final surfaceCard = context.surfaceCard;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: surfaceCard.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: onSurface.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _CollectionTabButton(
              icon: Icons.favorite_border_rounded,
              label: 'Wishlist',
              isSelected: selectedTab == _ProfileCollectionTab.wishlist,
              onTap: () => onChanged(_ProfileCollectionTab.wishlist),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CollectionTabButton(
              icon: Icons.cottage_outlined,
              label: 'My Lands',
              isSelected: selectedTab == _ProfileCollectionTab.myLands,
              onTap: () => onChanged(_ProfileCollectionTab.myLands),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionTabButton extends StatelessWidget {
  const _CollectionTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
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
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? surfaceCard : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      surfaceCard,
                      scheme.surface.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: isSelected
                ? Border.all(color: scheme.outline.withValues(alpha: 0.35))
                : null,
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: onSurface.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.deepOrange : AppColors.mutedText,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? onSurface : AppColors.mutedText,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _JourneySelectionPanel extends StatelessWidget {
  const _JourneySelectionPanel({
    required this.journeys,
    required this.selectedLandIds,
    required this.onJourneyTapped,
    super.key,
  });

  final List<_TrackedLandUiModel> journeys;
  final Set<int> selectedLandIds;
  final ValueChanged<int> onJourneyTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _JourneySectionHeader(),
        const SizedBox(height: 14),
        ...journeys.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _JourneyCard(
              journey: entry.value,
              isSelected: selectedLandIds.contains(entry.value.id),
              onTap: () => onJourneyTapped(entry.key),
            ),
          ),
        ),
      ],
    );
  }
}

class _WishlistLoadingPanel extends StatelessWidget {
  const _WishlistLoadingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }
}

class _WishlistErrorPanel extends StatelessWidget {
  const _WishlistErrorPanel({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.deepOrange,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _WishlistEmptyPanel extends StatelessWidget {
  const _WishlistEmptyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaceCard = context.surfaceCard;
    final onSurface = context.colors.onSurface;

    return CustomCard(
      key: key,
      gradient: LinearGradient(
        colors: [
          surfaceCard,
          context.colors.surface.withValues(alpha: 0.4),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: context.colors.outline.withValues(alpha: 0.35)),
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.favorite_border_rounded,
            size: 34,
            color: AppColors.deepOrange,
          ),
          const SizedBox(height: 12),
          Text(
            'YOUR WISHLIST IS EMPTY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add lands from the search details screen to see them here.',
            textAlign: TextAlign.center,
            style: context.text.caption.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _MyLandsPanel extends StatelessWidget {
  const _MyLandsPanel({required this.lands, super.key});

  final List<_OwnedLandUiModel> lands;

  @override
  Widget build(BuildContext context) {
    final onSurface = context.colors.onSurface;

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'LIST OF LANDS',
                style: TextStyle(
                  color: onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(999),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.add_rounded,
                          size: 14,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'LIST NEW LAND',
                          style: context.text.microLabel.copyWith(
                            color: AppColors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...lands.map(
          (land) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OwnedLandCard(land: land),
          ),
        ),
      ],
    );
  }
}
