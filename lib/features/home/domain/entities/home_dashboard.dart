import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/home/domain/entities/contact_info.dart';
import 'package:garuda_user_app/features/home/domain/entities/hero_banner.dart';

class HomeDashboard extends Equatable {
  const HomeDashboard({required this.heroBanners, required this.contactInfo});

  final List<HeroBanner> heroBanners;
  final ContactInfo contactInfo;

  @override
  List<Object?> get props => <Object?>[heroBanners, contactInfo];
}
