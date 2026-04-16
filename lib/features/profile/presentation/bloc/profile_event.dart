import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  const UpdateProfileRequested({
    required this.name,
    required this.phone,
    this.photoPath,
  });

  final String name;
  final String phone;
  final String? photoPath;

  @override
  List<Object?> get props => [name, phone, photoPath];
}

class LogoutRequested extends ProfileEvent {}

class DeleteAccountRequested extends ProfileEvent {}

class WishlistRequested extends ProfileEvent {
  const WishlistRequested();
}

class CreateAvailabilityRequested extends ProfileEvent {
  const CreateAvailabilityRequested({required this.landIds});

  final List<int> landIds;

  @override
  List<Object?> get props => [landIds];
}

class GetAvailabilitiesRequested extends ProfileEvent {
  const GetAvailabilitiesRequested();

  @override
  List<Object?> get props => [];
}

class CreateCartRequested extends ProfileEvent {
  const CreateCartRequested({required this.landIds});

  final List<int> landIds;

  @override
  List<Object?> get props => [landIds];
}

class GetCartRequested extends ProfileEvent {
  const GetCartRequested();

  @override
  List<Object?> get props => [];
}

class GetVisitsRequested extends ProfileEvent {
  const GetVisitsRequested();

  @override
  List<Object?> get props => [];
}

class GetShortlistsRequested extends ProfileEvent {
  const GetShortlistsRequested();

  @override
  List<Object?> get props => [];
}

class GetFinalsRequested extends ProfileEvent {
  const GetFinalsRequested();

  @override
  List<Object?> get props => [];
}

class CreateShortlistRequested extends ProfileEvent {
  const CreateShortlistRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class DeleteShortlistRequested extends ProfileEvent {
  const DeleteShortlistRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class CreateFinalRequested extends ProfileEvent {
  const CreateFinalRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class DeleteFinalRequested extends ProfileEvent {
  const DeleteFinalRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class CreatePaymentRequested extends ProfileEvent {
  const CreatePaymentRequested({
    required this.landIds,
    required this.amount,
  });

  final List<int> landIds;
  final int amount;

  @override
  List<Object?> get props => [landIds, amount];
}

class CreateVisitRequested extends ProfileEvent {
  const CreateVisitRequested({
    required this.landIds,
    required this.visitDate,
    required this.time,
  });

  final List<int> landIds;
  final String visitDate;
  final String time;

  @override
  List<Object?> get props => [landIds, visitDate, time];
}
