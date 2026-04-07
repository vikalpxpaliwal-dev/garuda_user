import 'package:garuda_user_app/features/auth/data/models/signup_response_model.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserDataModel.fromJson(json['data'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  final bool success;
  final String message;
  final UserDataModel data;
  final String accessToken;
  final String refreshToken;
}
