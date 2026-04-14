import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class CreatePaymentUseCase {
  const CreatePaymentUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  }) {
    return _repository.createPayment(
      landIds: landIds,
      amount: amount,
      paymentStatus: paymentStatus,
    );
  }
}
