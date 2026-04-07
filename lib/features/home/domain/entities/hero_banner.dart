import 'package:equatable/equatable.dart';

enum HeroBannerTone { investors, farmers, agents }

class HeroBanner extends Equatable {
  const HeroBanner({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final HeroBannerTone tone;

  @override
  List<Object?> get props => <Object?>[title, subtitle, buttonLabel, tone];
}
