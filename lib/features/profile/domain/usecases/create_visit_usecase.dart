import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class CreateVisitUseCase {
  const CreateVisitUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  }) {
    return _repository.createVisit(
      landIds: landIds,
      visitDate: visitDate,
      time: time,
      meetingStatus: meetingStatus,
    );
  }
}
