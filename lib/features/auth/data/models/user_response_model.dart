import 'package:garuda_user_app/features/auth/data/models/signup_response_model.dart';

class UserResponseModel {
  const UserResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final UserDataModel data;
}
