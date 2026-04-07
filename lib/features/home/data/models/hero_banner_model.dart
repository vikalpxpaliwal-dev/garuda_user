import 'package:garuda_user_app/features/home/domain/entities/hero_banner.dart';

class HeroBannerModel extends HeroBanner {
  const HeroBannerModel({
    required super.title,
    required super.subtitle,
    required super.buttonLabel,
    required super.tone,
  });

  factory HeroBannerModel.fromMap(Map<String, dynamic> map) {
    return HeroBannerModel(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      buttonLabel: map['buttonLabel'] as String,
      tone: HeroBannerTone.values.byName(map['tone'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'buttonLabel': buttonLabel,
      'tone': tone.name,
    };
  }
}
