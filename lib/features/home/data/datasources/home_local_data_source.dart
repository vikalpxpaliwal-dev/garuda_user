import 'package:garuda_user_app/core/constants/app_constants.dart';
import 'package:garuda_user_app/features/home/data/models/contact_info_model.dart';
import 'package:garuda_user_app/features/home/data/models/hero_banner_model.dart';
import 'package:garuda_user_app/features/home/data/models/home_dashboard_model.dart';
import 'package:garuda_user_app/features/home/domain/entities/hero_banner.dart';

abstract interface class HomeLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboard();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeDashboardModel> getHomeDashboard() async {
    return Future<HomeDashboardModel>.delayed(
      AppConstants.mockLoadingDelay,
      () => const HomeDashboardModel(
        heroBanners: <HeroBannerModel>[
          HeroBannerModel(
            title: 'Finding land is easy',
            subtitle: 'FOR INVESTORS',
            buttonLabel: 'Browse land',
            tone: HeroBannerTone.investors,
          ),
          HeroBannerModel(
            title: 'Selling of land is easy now',
            subtitle: 'FOR FARMERS',
            buttonLabel: 'Start selling',
            tone: HeroBannerTone.farmers,
          ),
          HeroBannerModel(
            title: 'Work with us',
            subtitle: 'FOR AGENTS',
            buttonLabel: 'Join the network',
            tone: HeroBannerTone.agents,
          ),
        ],
        contactInfo: ContactInfoModel(
          title: 'CONTACT US',
          description: 'Talk to our land support team',
          phoneNumber: '8143806110',
          buttonLabel: 'Call now',
        ),
      ),
    );
  }
}
