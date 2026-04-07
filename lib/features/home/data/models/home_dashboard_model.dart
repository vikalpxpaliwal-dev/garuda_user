import 'package:garuda_user_app/features/home/data/models/contact_info_model.dart';
import 'package:garuda_user_app/features/home/data/models/hero_banner_model.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';

class HomeDashboardModel extends HomeDashboard {
  const HomeDashboardModel({
    required super.heroBanners,
    required super.contactInfo,
  });

  factory HomeDashboardModel.fromMap(Map<String, dynamic> map) {
    return HomeDashboardModel(
      heroBanners: (map['heroBanners'] as List<dynamic>)
          .map(
            (dynamic item) =>
                HeroBannerModel.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
      contactInfo: ContactInfoModel.fromMap(
        map['contactInfo'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'heroBanners': heroBanners
          .map(
            (heroBanner) => HeroBannerModel(
              title: heroBanner.title,
              subtitle: heroBanner.subtitle,
              buttonLabel: heroBanner.buttonLabel,
              tone: heroBanner.tone,
            ).toMap(),
          )
          .toList(),
      'contactInfo': ContactInfoModel(
        title: contactInfo.title,
        description: contactInfo.description,
        phoneNumber: contactInfo.phoneNumber,
        buttonLabel: contactInfo.buttonLabel,
      ).toMap(),
    };
  }
}
