import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> signup(SignupRequestModel request);
}
