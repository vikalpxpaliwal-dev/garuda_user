import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/home/data/models/contact_info_model.dart';
import 'package:garuda_user_app/features/home/data/models/hero_banner_model.dart';
import 'package:garuda_user_app/features/home/data/models/home_dashboard_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<HomeDashboardModel> getHomeDashboard();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<HomeDashboardModel> getHomeDashboard() async {
    final response = await _apiService.get<Map<String, dynamic>>('/buyer/home');
    final responseData = response.data;

    if (responseData == null) {
      throw StateError('Home dashboard response was empty');
    }

    final payload = responseData['data'] as Map<String, dynamic>? ?? responseData;
    final bannersJson =
        payload['heroBanners'] as List<dynamic>? ??
        payload['hero_banners'] as List<dynamic>? ??
        <dynamic>[];
    final contactJson =
        payload['contactInfo'] as Map<String, dynamic>? ??
        payload['contact_info'] as Map<String, dynamic>?;

    if (contactJson == null) {
      throw StateError('Home dashboard response missing contact info');
    }

    return HomeDashboardModel(
      heroBanners: bannersJson
          .map(
            (item) => HeroBannerModel.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
      contactInfo: ContactInfoModel.fromMap(contactJson),
    );
  }
}
