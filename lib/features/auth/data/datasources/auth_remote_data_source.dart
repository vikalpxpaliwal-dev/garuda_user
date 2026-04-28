import 'package:dio/dio.dart';
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
  Future<void> logout(String refreshToken);
  Future<void> deleteAccount();
  Future<String> forgotPassword(String email);
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
    String? photoUrl;

    if (photoPath != null) {
      if (photoPath.startsWith('http')) {
        photoUrl = photoPath;
      } else {
        final formData = FormData.fromMap({
          'photo': await MultipartFile.fromFile(photoPath),
          'document': '',
          'video': '',
        });

        final uploadResponse = await _apiService.post<Map<String, dynamic>>(
          'http://72.61.169.226:5000/api/upload-files',
          data: formData,
        );
        photoUrl = uploadResponse.data?['photoUrl'] as String?;
      }
    }

    final response = await _apiService.put(
      '/buyer/update',
      data: {
        'name': name,
        'phone': phone,
        if (photoUrl != null) 'photo': photoUrl,
      },
    );
    return UserResponseModel.fromJson(response.data);
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _apiService.post(
      '/buyer/logout',
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _apiService.post('/buyer/delete-account');
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await _apiService.post(
      '/buyer/forgot-password',
      data: {'email': email},
    );
    return response.data['message'] as String;
  }
}
