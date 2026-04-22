import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/home/domain/entities/contact_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportCard extends StatelessWidget {
  const ContactSupportCard({required this.contactInfo, super.key});

  final ContactInfo contactInfo;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: LinearGradient(
        colors: [AppColors.white, AppColors.softBackground.withValues(alpha: 0.5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(20),
      border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 14,
                  color: AppColors.deepOrange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                contactInfo.title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.deepOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final String cleanNumber = contactInfo.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
              final Uri telUri = Uri(scheme: 'tel', path: cleanNumber);
              if (await canLaunchUrl(telUri)) {
                await launchUrl(telUri);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightLine.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.call_rounded,
                    size: 16,
                    color: AppColors.deepOrange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    contactInfo.phoneNumber,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
