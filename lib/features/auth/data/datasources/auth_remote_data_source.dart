import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/login_response_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/signup',
      data: request.toJson(),
    );

    return SignupResponseModel.fromJson(response.data!);
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/login',
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data!);
  }
}
