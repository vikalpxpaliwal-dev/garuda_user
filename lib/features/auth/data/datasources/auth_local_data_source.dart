import 'dart:convert';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getUser();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_data';

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    // UserEntity is Equatable, and UserDataModel extends it.
    // For storage, we can reuse UserDataModel's fromJson/toJson if we add toJson.
    // Since UserEntity is domain, we usually convert to model before saving.
    final userMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'photo': user.photo,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };
    await _prefs.setString(_userKey, jsonEncode(userMap));
  }

  @override
  Future<UserEntity?> getUser() async {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return UserDataModel.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
  }
}
