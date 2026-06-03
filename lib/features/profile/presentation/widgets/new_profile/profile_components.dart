import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';

// --- Custom FAB ---
class CustomProfileFab extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CustomProfileFab({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 9,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- App Bar ---
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xFFEEEEEE),
          height: 1.0,
        ),
      ),
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.park_outlined, color: AppColors.primaryOrange),
          SizedBox(width: 8),
          Text(
            'Garuda Lands',
            style: TextStyle(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- Top Tabs Component ---
class ProfileTopTabsCard extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ProfileTopTabsCard({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TabItem(
            icon: Icons.shopping_cart_outlined,
            label: 'CART',
            isSelected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _TabItem(
            icon: Icons.send_outlined,
            label: 'VISITS',
            isSelected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _TabItem(
            icon: Icons.account_balance_outlined,
            label: 'MY LANDS',
            isSelected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryOrange;
    final inactiveColor = const Color(0xFFAFA79F);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: isSelected
              ? BoxDecoration(
                  color: const Color(0xFFFFF9F5),
                  borderRadius: BorderRadius.circular(16),
                )
              : const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileActionIconsGrid extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ProfileActionIconsGrid({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout calculation for the bottom row
          final itemWidth = constraints.maxWidth / 3;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionItem(
                    icon: Icons.favorite_border,
                    label: 'WISHLIST',
                    isSelected: selectedIndex == 0,
                    onTap: () => onSelected(0),
                  ),
                  _ActionItem(
                    icon: Icons.receipt_long,
                    label: 'ENQUIRY\nCHARGES',
                    isSelected: selectedIndex == 1,
                    onTap: () => onSelected(1),
                  ),
                  _ActionItem(
                    icon: Icons.cases_outlined,
                    label: 'ENQUIRY',
                    isSelected: selectedIndex == 2,
                    onTap: () => onSelected(2),
                  ),
                ],
              ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  SizedBox(
                    width: itemWidth,
                    child: _ActionItem(
                      icon: Icons.shopping_cart_outlined,
                      label: 'CART',
                      isSelected: selectedIndex == 3,
                      onTap: () => onSelected(3),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _ActionItem(
                      icon: Icons.near_me_outlined,
                      label: 'VISITING CHARGES',
                      isSelected: selectedIndex == 4,
                      onTap: () => onSelected(4),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryOrange;
    final inactiveColor = const Color(0xFF8B8379);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              )
            : const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: FontWeight.w900,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
