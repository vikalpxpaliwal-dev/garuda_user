import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

class SignupResponseModel {
  const SignupResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final UserDataModel data;
}

class UserDataModel extends UserEntity {
  const UserDataModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.photo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
