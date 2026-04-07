import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';

class GetHomeDashboard {
  const GetHomeDashboard(this._repository);

  final HomeRepository _repository;

  Future<Result<HomeDashboard>> call() {
    return _repository.getHomeDashboard();
  }
}
