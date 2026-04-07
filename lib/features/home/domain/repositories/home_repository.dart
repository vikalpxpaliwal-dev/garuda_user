import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';

abstract interface class HomeRepository {
  Future<Result<HomeDashboard>> getHomeDashboard();
}
