import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';

final class AppScaffoldMessage {
  AppScaffoldMessage._();

  static void showSuccess(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      accentColor: const Color(0xFF2E7D32),
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context: context,
      message: message,
      accentColor: const Color(0xFFC62828),
      icon: Icons.error_rounded,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color accentColor,
    required IconData icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: EdgeInsets.zero,
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accentColor.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(icon, size: 16, color: accentColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
