import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/search/data/models/land_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<List<LandModel>> getLands();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService _apiService;

  SearchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<LandModel>> getLands() async {
    final response = await _apiService.get('/buyer/land');

    if (response.data != null && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LandModel.fromJson(json)).toList();
    }

    return [];
  }
}
