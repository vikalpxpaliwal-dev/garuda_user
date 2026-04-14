import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetCartUseCase {
  const GetCartUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<CartItemEntity>>> call() async {
    return _repository.getCart();
  }
}
