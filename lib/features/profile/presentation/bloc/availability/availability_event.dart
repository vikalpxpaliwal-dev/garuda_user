import 'package:equatable/equatable.dart';

sealed class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object?> get props => [];
}

class CreateAvailabilityRequested extends AvailabilityEvent {
  const CreateAvailabilityRequested({required this.landIds});

  final List<int> landIds;

  @override
  List<Object?> get props => [landIds];
}

class GetAvailabilitiesRequested extends AvailabilityEvent {
  const GetAvailabilitiesRequested();
}
