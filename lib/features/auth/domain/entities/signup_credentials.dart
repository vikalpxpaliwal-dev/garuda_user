import 'package:equatable/equatable.dart';

class SignupCredentials extends Equatable {
  const SignupCredentials({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.photo,
  });

  final String name;
  final String email;
  final String password;
  final String phone;
  final String photo;

  @override
  List<Object?> get props => [name, email, password, phone, photo];
}
