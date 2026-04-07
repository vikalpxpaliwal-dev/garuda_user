import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.lightLine)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: <Widget>[
                _BottomNavItem(
                  label: AppStrings.homeTab,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => _onDestinationSelected(0),
                ),
                _BottomNavItem(
                  label: AppStrings.searchTab,
                  icon: Icons.search_outlined,
                  selectedIcon: Icons.search_rounded,
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => _onDestinationSelected(1),
                ),
                _BottomNavItem(
                  label: AppStrings.profileTab,
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  isSelected: navigationShell.currentIndex == 2,
                  onTap: () => _onDestinationSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.deepOrange : AppColors.mutedText;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(isSelected ? selectedIcon : icon, size: 20, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
