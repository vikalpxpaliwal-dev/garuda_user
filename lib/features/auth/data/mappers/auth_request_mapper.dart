import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';

class AuthRequestMapper {
  const AuthRequestMapper._();

  static LoginRequestModel toLoginRequestModel(LoginCredentials credentials) {
    return LoginRequestModel(
      email: credentials.email,
      password: credentials.password,
    );
  }

  static SignupRequestModel toSignupRequestModel(SignupCredentials credentials) {
    return SignupRequestModel(
      name: credentials.name,
      email: credentials.email,
      password: credentials.password,
      phone: credentials.phone,
      photo: credentials.photo,
    );
  }
}
