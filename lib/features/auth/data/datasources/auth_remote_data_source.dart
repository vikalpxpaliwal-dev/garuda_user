import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/login_response_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_response_model.dart';
import 'package:garuda_user_app/features/auth/data/models/user_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<String> refresh(String refreshToken);
  Future<UserResponseModel> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  });
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    final response = await _apiService.post(
      '/buyer/signup',
      data: request.toJson(),
    );
    return SignupResponseModel.fromJson(response.data);
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _apiService.post(
      '/buyer/login',
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }

  @override
  Future<String> refresh(String refreshToken) async {
    final response = await _apiService.post(
      '/buyer/refresh',
      data: {'refreshToken': refreshToken},
    );
    return response.data['accessToken'] as String;
  }

  @override
  Future<UserResponseModel> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  }) async {
    // In a professional app, you'd use FormData if uploading a file.
    // For now, we'll simulate the update.
    final response = await _apiService.post(
      '/buyer/update-profile',
      data: {
        'name': name,
        'phone': phone,
        if (photoPath != null) 'photo': photoPath,
      },
    );
    return UserResponseModel.fromJson(response.data);
  }

  @override
  Future<void> deleteAccount() async {
    await _apiService.post('/buyer/delete-account');
  }
}
