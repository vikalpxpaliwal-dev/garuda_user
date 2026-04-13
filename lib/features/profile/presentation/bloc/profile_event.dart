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
